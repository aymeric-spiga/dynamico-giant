#! /bin/bash

vert=40

cd ../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -b 20x25 -s 2 \
 -t 0 \
 -d $vert \
 -arch ifort_CICLAD -arch_path ../../arch \
 -parallel none \
 -j 8 \
 -p std \
 rcm1d
cd -

cp ../code/LMDZ.COMMON/bin/rcm1d_${vert}_phystd_seq.e .
mv rcm1d_${vert}_phystd_seq.e rcm1d.e
