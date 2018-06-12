#! /bin/bash

here=$PWD

#echo "----- update code"
cd ../code
#svn update * | tail -n 7 > log_svn
#cat log_svn

echo "----- compile code (please wait)"
cd ICOSA_LMDZ
./make_icosa_lmdz -p std -p_opt "-b 20x25 -s 1" -parallel mpi_omp -arch X64_OCCIGEN -arch_path ../ARCH -job 8 > $here/log_compile 2>&1

echo "----- executables should be here"
ls -l bin/icosa_lmdz.exe
ls -l ../XIOS/bin/xios_server.exe

echo "----- copy executables to current directory"
cd $here
cp -rf ../code/ICOSA_LMDZ/bin/icosa_lmdz.exe ./
cp -rf ../code/XIOS/bin/xios_server.exe ./
