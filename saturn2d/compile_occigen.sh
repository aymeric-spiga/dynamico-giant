#! /bin/bash

here=$PWD

#vert=64
#vert=32
#vert=61
vert=96

#lati=128
lati=360

#cd ../code/LMDZ.COMMON/ioipsl
#./install_ioipsl_ifort.bash
#cd -

cd ../code/LMDZ.COMMON
###
echo "------ compile gcm (please wait) ------"
./makelmdz_fcm \
 -d 8x360x96 \
 -p std \
 -p_opt "-b 20x25 -s 1" \
 -parallel mpi \
 -arch X64_OCCIGEN \
 -arch_path arch \
 -full \
 -job 8 \
 -cpp NODYN \
 gcm > $here/log_compile_gcm 2>&1
###
echo "------ copy gcm executable to current directory ------"
cd $here
cp -rf ../code/LMDZ.COMMON/bin/gcm_8x${lati}x${vert}_phystd_para.e ./

cd ../code/LMDZ.COMMON
###
echo "------ compile newstart (please wait) ------"
./makelmdz_fcm \
 -d 8x360x96 \
 -p std \
 -p_opt "-b 20x25 -s 1" \
 -arch X64_OCCIGEN \
 -arch_path arch \
 -full \
 -job 8 \
 -cpp NODYN \
 newstart > $here/log_compile_newstart 2>&1
###
echo "------ copy newstart executable to current directory ------"
cd $here
cp -rf ../code/LMDZ.COMMON/bin/newstart_8x${lati}x${vert}_phystd_seq.e ./makestart/
