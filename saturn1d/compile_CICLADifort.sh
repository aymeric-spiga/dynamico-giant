#! /bin/bash

#vert=64
#vert=32
#vert=61
vert=96

cd ../code/LMDZ.COMMON/ioipsl/
./install_ioipsl_ciclad-ifort.bash
cd -

cd ../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -b 20x25 -s 1 \
 -t 0 \
 -d $vert \
 -arch CICLADifort -arch_path ../ARCH \
 -parallel none \
 -j 8 \
 -p std \
 rcm1d
cd -
ln -sf ../code/LMDZ.COMMON/bin/rcm1d_${vert}_phystd_seq.e rcm1d.e


