#! /bin/bash

vert=64
vert=32

cd ../../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -cpp NODYN \
 -b 20x25 -s 1 \
 -t 0 \
 -d 8x128x${vert} \
 -arch CICLADifort \
 -parallel none \
 -j 8 \
 -p std \
 newstart

cd -
ln -sf ../../code/LMDZ.COMMON/bin/newstart_8x128x${vert}_phystd_seq.e newstart.e

./newstart.e < saturn_newstart.ref



# -t 1
