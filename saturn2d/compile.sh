#! /bin/bash

vert=64
vert=32

cd ../code/LMDZ.COMMON/ioipsl
./install_ioipsl_ifort.bash
cd -

cd ../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -cpp NODYN \
 -b 20x25 -s 1 \
 -t 0 \
 -d 8x128x${vert} \
 -arch CICLADifort \
 -parallel mpi \
 -j 8 \
 -p std \
 gcm
cd -
ln -sf ../code/LMDZ.COMMON/bin/gcm_8x128x${vert}_phystd_para.e gcm.e

# -t 1
