#! /bin/bash

\rm aam_epsilon.txt
touch aam_epsilon.txt

\rm aam_dissip_plus.txt
touch aam_dissip_plus.txt

\rm aam_dissip_moins.txt
touch aam_dissip_moins.txt

\rm aam_mass.txt
touch aam_mass.txt

\rm aam_vel.txt
touch aam_vel.txt

\rm aam_dyn.txt
touch aam_dyn.txt
 
\rm aam_dyn_plus.txt
touch aam_dyn_plus.txt

\rm aam_dyn_moins.txt
touch aam_dyn_moins.txt

for filename in icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out; do
  echo $filename
  grep "AAM_dyn"   $filename | sed s/'0000: AAM_dyn budget mass + vel:'/' '/g                                   >> aam_epsilon.txt
  grep "AAM_vel+ " $filename | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}'  >> aam_dissip_plus.txt
  grep "AAM_vel- " $filename | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}'  >> aam_dissip_moins.txt
  grep "AAM_mass " $filename | sed s/'0000: AAM_mass : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}'  >> aam_mass.txt
  grep "AAM_vel "  $filename | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $3}'  >> aam_vel.txt
  grep "AAM_vel "  $filename | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}'  >> aam_dyn.txt
  grep "AAM_vel+ " $filename | sed s/'0000: AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}'  >> aam_dyn_plus.txt
  grep "AAM_vel- " $filename | sed s/'0000: AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}'  >> aam_dyn_moins.txt
done
exit


# plus rapide ci-dessus (boucle + grep)

cat icosa_lmdz_?.out icosa_lmdz_??.out icosa_lmdz_???.out | grep "AAM_dyn" | sed s/'0000: AAM_dyn budget mass + vel:'/' '/g > aam_epsilon.txt
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

#\rm diag_aam*png
#./diag_aam.py
#eog diag_aam_4_pert.png
