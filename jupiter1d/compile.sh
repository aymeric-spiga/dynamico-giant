#! /bin/bash

vert=64
#vert=32

cd ../trunk/LMDZ.COMMON
./makelmdz_fcm -full \
 -b 20x25 -s 2 \
 -t 0 \
 -d $vert \
 -arch X64_OCCIGEN -arch_path ../ARCH \
 -parallel none \
 -j 8 \
 -p std \
 rcm1d
cd -
cp -rf ../trunk/LMDZ.COMMON/bin/rcm1d_${vert}_phystd_seq.e . 


