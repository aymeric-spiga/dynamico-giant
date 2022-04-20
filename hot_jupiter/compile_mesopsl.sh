#! /bin/bash

here=$PWD

#echo "----- update code"
cd ../code
#svn update * | tail -n 7 > log_svn
#cat log_svn


# PRINT THE CURRENT VERSION OF CODE
\rm icosa_lmdz.version
echo "****** CODE VERSION *******" >> icosa_lmdz.version
var="DYNAMICO --> "`svn info ICOSAGCM 2> /dev/null | grep "Revision:"`
echo $var >> icosa_lmdz.version
var="PHYSICS --> "`svn info ICOSA_LMDZ 2> /dev/null | grep "Revision:"`
echo $var >> icosa_lmdz.version
var="XIOS --> "`svn info XIOS 2> /dev/null | grep "Revision:"`
echo $var >> icosa_lmdz.version
echo "****** CODE VERSION *******" >> icosa_lmdz.version

cd LMDZ.COMMON/arch

echo "----- compile code (please wait)"
cd ../../ICOSA_LMDZ
# cd ICOSA_LMDZ
# ./make_icosa_lmdz -p std -p_opt "-b 26x27 -s 2" -parallel mpi -arch MesoPSL -arch_path ../ARCH -full -job 8 > $here/log_compile 2>&1
# ./make_icosa_lmdz -p std -p_opt "-b 26x27 -s 2" -debug -parallel mpi -arch MesoPSL -arch_path ../ARCH -full -job 8 > $here/log_compile 2>&1 #for debug mode
./make_icosa_lmdz -p std -p_opt "-b 26x27 -s 1" -parallel mpi -arch MesoPSL -arch_path ../ARCH -full -job 8 > $here/log_compile 2>&1
# ./make_icosa_lmdz -p std -p_opt "-b 26x27 -s 1" -debug -parallel mpi -arch MesoPSL -arch_path ../ARCH -full -job 8 > $here/log_compile 2>&1 #debug mode
echo "----- executables should be here"
ls -l bin/icosa_lmdz.exe
ls -l ../XIOS/bin/xios_server.exe

echo "----- copy executables to current directory"
cd $here
cp -rf ../code/ICOSA_LMDZ/bin/icosa_lmdz.exe ./
cp -rf ../code/XIOS/bin/xios_server.exe ./
cp -rf ../code/icosa_lmdz.version ./

echo "----- create symbolic links of initial start files"
ln -s makestart/restart_icosa.nc start_icosa.nc
ln -s makestart/restartfi.nc startfi.nc

echo "----- create symbolic links of executables to makestart directory"
cd makestart
ln -s ../icosa_lmdz.exe icosa_lmdz.exe
ln -s ../xios_server.exe xios_server.exe
