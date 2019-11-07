#! /bin/bash

vert=64
vert=32

lati=128
lati=360

cd ../code/LMDZ.COMMON/ioipsl
./install_ioipsl_ifort.bash
cd -

cd ../code/LMDZ.COMMON
###
./makelmdz_fcm \
 -cpp NODYN \
 -b 20x25 -s 1 \
 -t 0 \
 -d 8x${lati}x${vert} \
 -arch CICLADifort \
 -parallel mpi \
 -j 8 \
 -p std \
 gcm
###
./makelmdz_fcm \
 -cpp NODYN \
 -b 20x25 -s 1 \
 -t 0 \
 -d 8x${lati}x${vert} \
 -arch CICLADifort \
 -parallel none \
 -j 8 \
 -p std \
 newstart
###
cd -
cp ../code/LMDZ.COMMON/bin/gcm_8x${lati}x${vert}_phystd_para.e ./
cp ../code/LMDZ.COMMON/bin/newstart_8x${lati}x${vert}_phystd_seq.e ./makestart/


