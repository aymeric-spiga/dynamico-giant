MODULE caldyn_kernels_base_mod
  USE icosa
  USE transfert_mod
  USE disvert_mod
  USE omp_para
  USE trace
  IMPLICIT NONE
  PRIVATE

  INTEGER, PARAMETER,PUBLIC :: energy=1, enstrophy=2
  TYPE(t_field),POINTER,PUBLIC :: f_out_u(:), f_qu(:), f_qv(:)
  REAL(rstd),SAVE,POINTER :: out_u(:,:), p(:,:), qu(:,:)
  !$OMP THREADPRIVATE(out_u, p, qu)

  ! temporary shared variables for caldyn
  TYPE(t_field),POINTER,PUBLIC :: f_pk(:),f_wwuu(:),f_planetvel(:), &
                                  f_Fel(:), f_gradPhi2(:), f_wil(:), f_Wetadot(:)

  INTEGER, PUBLIC :: caldyn_conserv
  !$OMP THREADPRIVATE(caldyn_conserv) 

  TYPE(t_message),PUBLIC :: req_ps, req_mass, req_theta_rhodz, req_u, req_qu, req_geopot, req_w

  PUBLIC :: compute_geopot, compute_caldyn_vert, compute_caldyn_vert_nh

CONTAINS

  !**************************** Geopotential *****************************

  SUBROUTINE compute_geopot(rhodz,theta, ps,pk,geopot) 
    REAL(rstd),INTENT(IN)    :: rhodz(iim*jjm,llm)
    REAL(rstd),INTENT(IN)    :: theta(iim*jjm,llm,nqdyn) ! active scalars : theta/entropy, moisture, ...
    REAL(rstd),INTENT(INOUT) :: ps(iim*jjm)
    REAL(rstd),INTENT(OUT)   :: pk(iim*jjm,llm)       ! Exner function (compressible) /Lagrange multiplier (Boussinesq)
    REAL(rstd),INTENT(INOUT) :: geopot(iim*jjm,llm+1) ! geopotential

    INTEGER :: i,j,ij,l
    REAL(rstd) :: Rd, p_ik, exner_ik, temp_ik, qv, chi, Rmix, gv
    INTEGER    :: ij_omp_begin_ext, ij_omp_end_ext

    CALL trace_start("compute_geopot")

!$OMP BARRIER

    CALL distrib_level(ij_begin_ext,ij_end_ext, ij_omp_begin_ext,ij_omp_end_ext)

    Rd = kappa*cpp

    IF(dysl_geopot) THEN
#include "../kernels/compute_geopot.k90"
    ELSE
    ! Pressure is computed first top-down (temporarily stored in pk)
    ! Then Exner pressure and geopotential are computed bottom-up
    ! Works also when caldyn_eta=eta_mass          

    IF(boussinesq) THEN ! compute geopotential and pk=Lagrange multiplier
       ! specific volume 1 = dphi/g/rhodz
       !         IF (is_omp_level_master) THEN ! no openMP on vertical due to dependency
       DO l = 1,llm
          !DIR$ SIMD
          DO ij=ij_omp_begin_ext,ij_omp_end_ext         
             geopot(ij,l+1) = geopot(ij,l) + g*rhodz(ij,l)
          ENDDO
       ENDDO
       ! use hydrostatic balance with theta*rhodz to find pk (Lagrange multiplier=pressure) 
       ! uppermost layer
       !DIR$ SIMD
       DO ij=ij_begin_ext,ij_end_ext         
          pk(ij,llm) = ptop + (.5*g)*theta(ij,llm,1)*rhodz(ij,llm)
       END DO
       ! other layers
       DO l = llm-1, 1, -1
          !          !$OMP DO SCHEDULE(STATIC) 
          !DIR$ SIMD
          DO ij=ij_begin_ext,ij_end_ext         
             pk(ij,l) = pk(ij,l+1) + (.5*g)*(theta(ij,l,1)*rhodz(ij,l)+theta(ij,l+1,1)*rhodz(ij,l+1))
          END DO
       END DO
       ! now pk contains the Lagrange multiplier (pressure)
    ELSE ! non-Boussinesq, compute pressure, Exner pressure or temperature, then geopotential
       ! uppermost layer
       
       SELECT CASE(caldyn_thermo)
          CASE(thermo_theta, thermo_entropy)
             !DIR$ SIMD
             DO ij=ij_omp_begin_ext,ij_omp_end_ext
                pk(ij,llm) = ptop + (.5*g)*rhodz(ij,llm)
             END DO
             ! other layers
             DO l = llm-1, 1, -1
                !DIR$ SIMD
                DO ij=ij_omp_begin_ext,ij_omp_end_ext         
                   pk(ij,l) = pk(ij,l+1) + (.5*g)*(rhodz(ij,l)+rhodz(ij,l+1))
                END DO
             END DO
             ! surface pressure (for diagnostics)
             IF(caldyn_eta==eta_lag) THEN
                DO ij=ij_omp_begin_ext,ij_omp_end_ext         
                   ps(ij) = pk(ij,1) + (.5*g)*rhodz(ij,1)
                END DO
             END IF
          CASE(thermo_moist) ! theta(ij,l,2) = qv = mv/md
             !DIR$ SIMD
             DO ij=ij_omp_begin_ext,ij_omp_end_ext
                pk(ij,llm) = ptop + (.5*g)*rhodz(ij,llm)*(1.+theta(ij,l,2))
             END DO
             ! other layers
             DO l = llm-1, 1, -1
                !DIR$ SIMD
                DO ij=ij_omp_begin_ext,ij_omp_end_ext         
                   pk(ij,l) = pk(ij,l+1) + (.5*g)*(          &
                        rhodz(ij,l)  *(1.+theta(ij,l,2)) +   &
                        rhodz(ij,l+1)*(1.+theta(ij,l+1,2)) )
                END DO
             END DO
             ! surface pressure (for diagnostics)
             IF(caldyn_eta==eta_lag) THEN
                DO ij=ij_omp_begin_ext,ij_omp_end_ext         
                   ps(ij) = pk(ij,1) + (.5*g)*rhodz(ij,1)*(1.+theta(ij,l,2))
                END DO
             END IF
          END SELECT

       DO l = 1,llm
          SELECT CASE(caldyn_thermo)
          CASE(thermo_theta)
             !DIR$ SIMD
             DO ij=ij_omp_begin_ext,ij_omp_end_ext
                p_ik = pk(ij,l)
                exner_ik = cpp * (p_ik/preff) ** kappa
                pk(ij,l) = exner_ik
                ! specific volume v = kappa*theta*pi/p = dphi/g/rhodz
                geopot(ij,l+1) = geopot(ij,l) + (g*kappa)*rhodz(ij,l)*theta(ij,l,1)*exner_ik/p_ik
             ENDDO
          CASE(thermo_entropy) ! theta is in fact entropy = cpp*log(theta/Treff) = cpp*log(T/Treff) - Rd*log(p/preff)
             !DIR$ SIMD
             DO ij=ij_omp_begin_ext,ij_omp_end_ext
                p_ik = pk(ij,l)
                temp_ik = Treff*exp((theta(ij,l,1) + Rd*log(p_ik/preff))/cpp)
                pk(ij,l) = temp_ik
                ! specific volume v = Rd*T/p = dphi/g/rhodz
                geopot(ij,l+1) = geopot(ij,l) + (g*Rd)*rhodz(ij,l)*temp_ik/p_ik
             ENDDO
          CASE(thermo_moist) ! theta is moist pseudo-entropy per dry air mass
             DO ij=ij_omp_begin_ext,ij_omp_end_ext
                p_ik = pk(ij,l)
                qv = theta(ij,l,2) ! water vaper mixing ratio = mv/md
                Rmix = Rd+qv*Rv
                chi = ( theta(ij,l,1) + Rmix*log(p_ik/preff) ) / (cpp + qv*cppv) ! log(T/Treff)
                temp_ik = Treff*exp(chi)
                pk(ij,l) = temp_ik
                ! specific volume v = R*T/p = dphi/g/rhodz
                ! R = (Rd + qv.Rv)/(1+qv)
                geopot(ij,l+1) = geopot(ij,l) + g*Rmix*rhodz(ij,l)*temp_ik/(p_ik*(1+qv))
             ENDDO
          CASE DEFAULT
             STOP
          END SELECT
       ENDDO
    END IF

    END IF ! dysl

    !ym flush geopot
    !$OMP BARRIER

    CALL trace_end("compute_geopot")

  END SUBROUTINE compute_geopot

  SUBROUTINE compute_caldyn_vert(u,theta,rhodz,convm, wflux,wwuu, dps,dtheta_rhodz,du)
    REAL(rstd),INTENT(IN)  :: u(iim*3*jjm,llm)
    REAL(rstd),INTENT(IN)  :: theta(iim*jjm,llm,nqdyn)
    REAL(rstd),INTENT(IN)  :: rhodz(iim*jjm,llm)
    REAL(rstd),INTENT(INOUT)  :: convm(iim*jjm,llm)  ! mass flux convergence

    REAL(rstd),INTENT(INOUT) :: wflux(iim*jjm,llm+1) ! vertical mass flux (kg/m2/s)
    REAL(rstd),INTENT(INOUT) :: wwuu(iim*3*jjm,llm+1)
    REAL(rstd),INTENT(INOUT) :: du(iim*3*jjm,llm)
    REAL(rstd),INTENT(INOUT) :: dtheta_rhodz(iim*jjm,llm,nqdyn)
    REAL(rstd),INTENT(OUT) :: dps(iim*jjm)

    ! temporary variable    
    INTEGER :: i,j,ij,l,iq
    REAL(rstd) :: p_ik, exner_ik, dF_deta, dFu_deta
    INTEGER    :: ij_omp_begin, ij_omp_end

    CALL trace_start("compute_caldyn_vert")

    CALL distrib_level(ij_begin,ij_end, ij_omp_begin,ij_omp_end)

    !    REAL(rstd) :: wwuu(iim*3*jjm,llm+1) ! tmp var, don't know why but gain 30% on the whole code in opemp
    ! need to be understood

    !    wwuu=wwuu_out
    CALL trace_start("compute_caldyn_vert")

    !$OMP BARRIER   
!!! cumulate mass flux convergence from top to bottom
    !  IF (is_omp_level_master) THEN
    DO  l = llm-1, 1, -1
       !    IF (caldyn_conserv==energy) CALL test_message(req_qu) 

!!$OMP DO SCHEDULE(STATIC) 
       !DIR$ SIMD
       DO ij=ij_omp_begin,ij_omp_end         
          convm(ij,l) = convm(ij,l) + convm(ij,l+1)
       ENDDO
    ENDDO
    !  ENDIF

    !$OMP BARRIER
    ! FLUSH on convm
!!!!!!!!!!!!!!!!!!!!!!!!!

    ! compute dps
    IF (is_omp_first_level) THEN
       !DIR$ SIMD
       DO ij=ij_begin,ij_end         
          ! dps/dt = -int(div flux)dz
          dps(ij) = convm(ij,1)
       ENDDO
    ENDIF

!!! Compute vertical mass flux (l=1,llm+1 done by caldyn_BC)
    DO l=ll_beginp1,ll_end
       !    IF (caldyn_conserv==energy) CALL test_message(req_qu) 
       !DIR$ SIMD
       DO ij=ij_begin,ij_end         
          ! w = int(z,ztop,div(flux)dz) + B(eta)dps/dt
          ! => w>0 for upward transport
          wflux( ij, l ) = bp(l) * convm( ij, 1 ) - convm( ij, l ) 
       ENDDO
    ENDDO

    !--> flush wflux  
    !$OMP BARRIER

    DO iq=1,nqdyn
       DO l=ll_begin,ll_endm1
       !DIR$ SIMD
          DO ij=ij_begin,ij_end         
             dtheta_rhodz(ij, l, iq) = dtheta_rhodz(ij, l, iq)  -   0.5 * &
                  ( wflux(ij,l+1) * (theta(ij,l,iq) + theta(ij,l+1,iq)))
          END DO
       END DO
       DO l=ll_beginp1,ll_end
          !DIR$ SIMD
          DO ij=ij_begin,ij_end         
             dtheta_rhodz(ij, l, iq) = dtheta_rhodz(ij, l, iq)  +   0.5 * &
                  ( wflux(ij,l) * (theta(ij,l-1,iq) + theta(ij,l,iq) ) )
          END DO
       END DO
    END DO

      ! conservative vertical transport of momentum : (F/m)du/deta = 1/m
      ! (d/deta(Fu)-u.dF/deta)
      DO l = ll_beginp1, ll_end
         !DIR$ SIMD
         DO ij=ij_begin, ij_end
            wwuu(ij+u_right,l) = .25*(wflux(ij,l)+wflux(ij+t_right,l))*(u(ij+u_right,l)+u(ij+u_right,l-1)) ! Fu
            wwuu(ij+u_lup,l) = .25*(wflux(ij,l)+wflux(ij+t_lup,l))*(u(ij+u_lup,l)+u(ij+u_lup,l-1)) ! Fu
            wwuu(ij+u_ldown,l) = .25*(wflux(ij,l)+wflux(ij+t_ldown,l))*(u(ij+u_ldown,l)+u(ij+u_ldown,l-1)) ! Fu
         END DO
      END DO
      ! make sure wwuu is up to date
      !$OMP BARRIER
      DO l = ll_begin, ll_end
         !DIR$ SIMD
        DO ij=ij_begin, ij_end
            dFu_deta = wwuu(ij+u_right,l+1)-wwuu(ij+u_right,l) ! d/deta (F*u)
            dF_deta = .5*(wflux(ij,l+1)+wflux(ij+t_right,l+1)-(wflux(ij,l)+wflux(ij+t_right,l))) !d/deta(F)
            du(ij+u_right,l) = du(ij+u_right,l) - (dFu_deta-u(ij+u_right,l)*dF_deta) / (.5*(rhodz(ij,l)+rhodz(ij+t_right,l))) !(F/m)du/deta
            dFu_deta = wwuu(ij+u_lup,l+1)-wwuu(ij+u_lup,l) ! d/deta (F*u)
            dF_deta = .5*(wflux(ij,l+1)+wflux(ij+t_lup,l+1)-(wflux(ij,l)+wflux(ij+t_lup,l))) !d/deta(F)
            du(ij+u_lup,l) = du(ij+u_lup,l) - (dFu_deta-u(ij+u_lup,l)*dF_deta) / (.5*(rhodz(ij,l)+rhodz(ij+t_lup,l))) ! (F/m)du/deta
            dFu_deta = wwuu(ij+u_ldown,l+1)-wwuu(ij+u_ldown,l) ! d/deta (F*u)
            dF_deta = .5*(wflux(ij,l+1)+wflux(ij+t_ldown,l+1)-(wflux(ij,l)+wflux(ij+t_ldown,l))) !d/deta(F)
            du(ij+u_ldown,l) = du(ij+u_ldown,l) - (dFu_deta-u(ij+u_ldown,l)*dF_deta) / (.5*(rhodz(ij,l)+rhodz(ij+t_ldown,l))) !(F/m)du/deta
         END DO
      END DO

!    ! Compute vertical transport
!    DO l=ll_beginp1,ll_end
!       !DIR$ SIMD
!       DO ij=ij_begin,ij_end         
!          wwuu(ij+u_right,l) = 0.5*( wflux(ij,l) + wflux(ij+t_right,l)) * (u(ij+u_right,l) - u(ij+u_right,l-1))
!          wwuu(ij+u_lup,l) = 0.5* ( wflux(ij,l) + wflux(ij+t_lup,l)) * (u(ij+u_lup,l) - u(ij+u_lup,l-1))
!          wwuu(ij+u_ldown,l) = 0.5*( wflux(ij,l) + wflux(ij+t_ldown,l)) * (u(ij+u_ldown,l) - u(ij+u_ldown,l-1))
!       ENDDO
!    ENDDO
!
!    !--> flush wwuu  
!    !$OMP BARRIER
!
!    ! Add vertical transport to du
!    DO l=ll_begin,ll_end
!       !DIR$ SIMD
!       DO ij=ij_begin,ij_end         
!          du(ij+u_right, l )   = du(ij+u_right,l)  - (wwuu(ij+u_right,l+1)+ wwuu(ij+u_right,l)) / (rhodz(ij,l)+rhodz(ij+t_right,l))
!          du(ij+u_lup, l )     = du(ij+u_lup,l)    - (wwuu(ij+u_lup,l+1)  + wwuu(ij+u_lup,l))   / (rhodz(ij,l)+rhodz(ij+t_lup,l))
!          du(ij+u_ldown, l )   = du(ij+u_ldown,l)  - (wwuu(ij+u_ldown,l+1)+ wwuu(ij+u_ldown,l)) / (rhodz(ij,l)+rhodz(ij+t_ldown,l))
!       ENDDO
!    ENDDO
!
!    !  DO l=ll_beginp1,ll_end
!    !!DIR$ SIMD
!    !      DO ij=ij_begin,ij_end         
!    !        wwuu_out(ij+u_right,l) = wwuu(ij+u_right,l)
!    !        wwuu_out(ij+u_lup,l)   = wwuu(ij+u_lup,l)
!    !        wwuu_out(ij+u_ldown,l) = wwuu(ij+u_ldown,l)
!    !     ENDDO
!    !   ENDDO

    CALL trace_end("compute_caldyn_vert")

  END SUBROUTINE compute_caldyn_vert

  SUBROUTINE compute_caldyn_vert_NH(mass,geopot,W,wflux, W_etadot, du,dPhi,dW)
    REAL(rstd),INTENT(IN) :: mass(iim*jjm,llm)
    REAL(rstd),INTENT(IN) :: geopot(iim*jjm,llm+1)
    REAL(rstd),INTENT(IN) :: W(iim*jjm,llm+1)
    REAL(rstd),INTENT(IN) :: wflux(iim*jjm,llm+1)
    REAL(rstd),INTENT(INOUT) :: du(iim*3*jjm,llm)
    REAL(rstd),INTENT(INOUT) :: dPhi(iim*jjm,llm+1)
    REAL(rstd),INTENT(INOUT) :: dW(iim*jjm,llm+1)
    REAL(rstd) :: W_etadot(iim*jjm,llm) ! vertical flux of vertical momentum
    ! local arrays
    REAL(rstd) :: eta_dot(iim*jjm, llm) ! eta_dot in full layers
    REAL(rstd) :: wcov(iim*jjm,llm) ! covariant vertical momentum in full layers
    ! indices and temporary values
    INTEGER    :: ij, l
    REAL(rstd) :: wflux_ij, w_ij

    CALL trace_start("compute_caldyn_vert_nh")

    IF(dysl) THEN
!$OMP BARRIER
#include "../kernels/caldyn_vert_NH.k90"
!$OMP BARRIER
    ELSE
#define ETA_DOT(ij) eta_dot(ij,1)
#define WCOV(ij) wcov(ij,1)

    DO l=ll_begin,ll_end
       ! compute the local arrays
       !DIR$ SIMD
       DO ij=ij_begin_ext,ij_end_ext
          wflux_ij = .5*(wflux(ij,l)+wflux(ij,l+1))
          w_ij = .5*(W(ij,l)+W(ij,l+1))/mass(ij,l)
          W_etadot(ij,l) = wflux_ij*w_ij
          ETA_DOT(ij) = wflux_ij / mass(ij,l)
          WCOV(ij) = w_ij*(geopot(ij,l+1)-geopot(ij,l))
       ENDDO
       ! add NH term to du
      !DIR$ SIMD
      DO ij=ij_begin,ij_end
          du(ij+u_right,l) = du(ij+u_right,l) &
               - .5*(WCOV(ij+t_right)+WCOV(ij)) &
               *ne_right*(ETA_DOT(ij+t_right)-ETA_DOT(ij))
          du(ij+u_lup,l) = du(ij+u_lup,l) &
               - .5*(WCOV(ij+t_lup)+WCOV(ij)) &
               *ne_lup*(ETA_DOT(ij+t_lup)-ETA_DOT(ij))
          du(ij+u_ldown,l) = du(ij+u_ldown,l) &
               - .5*(WCOV(ij+t_ldown)+WCOV(ij)) &
               *ne_ldown*(ETA_DOT(ij+t_ldown)-ETA_DOT(ij))
       END DO
    ENDDO
    ! add NH terms to dW, dPhi
    ! FIXME : TODO top and bottom
    DO l=ll_beginp1,ll_end ! inner interfaces only
       !DIR$ SIMD
       DO ij=ij_begin,ij_end
          dPhi(ij,l) = dPhi(ij,l) - wflux(ij,l) &
               * (geopot(ij,l+1)-geopot(ij,l-1))/(mass(ij,l-1)+mass(ij,l))
       END DO
    END DO
    DO l=ll_begin,ll_end
       !DIR$ SIMD
       DO ij=ij_begin,ij_end
          dW(ij,l+1) = dW(ij,l+1) + W_etadot(ij,l) ! update inner+top interfaces
          dW(ij,l)   = dW(ij,l)   - W_etadot(ij,l) ! update bottom+inner interfaces
       END DO
    END DO

#undef ETA_DOT
#undef WCOV

    END IF ! dysl
    CALL trace_end("compute_caldyn_vert_nh")

  END SUBROUTINE compute_caldyn_vert_NH
END MODULE caldyn_kernels_base_mod
