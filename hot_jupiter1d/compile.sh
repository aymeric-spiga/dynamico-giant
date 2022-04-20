#! /bin/bash

vert=40
#vert=32

cd ../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -b 26x27 -s 1 \
 -t 0 \
 -d $vert \
 -arch MesoPSL -arch_path ../ARCH \
 -parallel none \
 -j 8 \
 -p std \
 rcm1d
cd -
cp -rf ../code/LMDZ.COMMON/bin/rcm1d_${vert}_phystd_seq.e . 


