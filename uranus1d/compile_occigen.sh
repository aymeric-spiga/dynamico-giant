#! /bin/bash

vert=48

echo "----- compile code (please wait)"
cd ../code/LMDZ.COMMON
./makelmdz_fcm -full \
 -b 20x25 -s 3 \
 -t 0 \
 -d $vert \
 -arch X64_OCCIGEN -arch_path ../ARCH \
 -parallel none \
 -j 8 \
 -p std \
 rcm1d

echo "----- executable should be here"
ls -l bin/rcm1d_${vert}_phystd_seq.e

echo "----- copy executable to current directory"
cd $here
cp -rf ../trunk/LMDZ.COMMON/bin/rcm1d_${vert}_phystd_seq.e ./
mv rcm1d_${vert}_phystd_seq.e rcm1d.e


