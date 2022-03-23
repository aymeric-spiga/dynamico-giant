#! /bin/bash

here=$PWD

#echo "----- update code"
cd ../code
#svn update * | tail -n 7 > log_svn
#cat log_svn


# PRINT THE CURRENT VERSION OF CODE
\rm icosa_lmdz.version
echo "****** CODE VERSION *******" >> icosa_lmdz.version
var="DYNAMICO --> "`svn info ICOSAGCM 2> /dev/null | grep "vision"`
echo $var >> icosa_lmdz.version
var="PHYSICS --> "`svn info ICOSA_LMDZ 2> /dev/null | grep "vision"`
echo $var >> icosa_lmdz.version
var="XIOS --> "`svn info XIOS 2> /dev/null | grep "vision"`
echo $var >> icosa_lmdz.version
echo "****** CODE VERSION *******" >> icosa_lmdz.version

echo "----- compile code (please wait)"
cd ICOSA_LMDZ
./make_icosa_lmdz -p std -p_opt "-b 20x25 -s 1" -parallel mpi_omp -arch X64_OCCIGEN -arch_path ../ARCH -full -job 8 > $here/log_compile 2>&1

echo "----- executables should be here"
ls -l bin/icosa_lmdz.exe
ls -l ../XIOS/bin/xios_server.exe

echo "----- copy executables to current directory"
cd $here
cp -rf ../code/ICOSA_LMDZ/bin/icosa_lmdz.exe ./
cp -rf ../code/XIOS/bin/xios_server.exe ./
cp -rf ../code/icosa_lmdz.version ./
