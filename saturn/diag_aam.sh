#! /bin/bash

cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_dyn" | sed s/'0000: AAM_dyn budget mass + vel:'/' '/g > epsilon.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_vel " | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $4}' > aam_dissip.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_vel " | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dyn.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_vel " | sed s/'0000: AAM_vel  : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $6}' > aam_phys.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_vel+ " | sed s/'AAM_vel+ : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dissip_plus.txt
cat icosa_lmdz_?.out icosa_lmdz_??.out | grep "AAM_vel- " | sed s/'AAM_vel- : time,old,new,dissip,dyn,phys '/' '/g | awk '{print $5}' > aam_dissip_moins.txt

