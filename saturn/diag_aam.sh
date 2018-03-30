#! /bin/bash

cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_dyn" | sed s/'0000: AAM_dyn budget mass + vel:'/' '/g > epsilon.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_mass " | sed s/'0000: AAM_mass : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}' > aam_mass.txt
#cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_mass " | sed s/'0000: AAM_mass : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $1}' > aam_time.txt

cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel "  | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}' > aam_vel.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel "  | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}' > aam_dissip.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel "  | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dyn.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel "  | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $6}' > aam_phys.txt

cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel+ " | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}' > aam_vel_plus.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel+ " | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}' > aam_dissip_plus.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel+ " | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dyn_plus.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel+ " | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $6}' > aam_phys_plus.txt

cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel- " | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}' > aam_vel_moins.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel- " | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}' > aam_dissip_moins.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel- " | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dyn_moins.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_vel- " | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $6}' > aam_phys_moins.txt

\rm diag_aam*png
./diag_aam.py

eog diag_aam_4_pert.png
