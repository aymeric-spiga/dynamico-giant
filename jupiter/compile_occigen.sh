#! /bin/bash

here=$PWD

cd ../code/ICOSA_LMDZ/
./make_icosa_lmdz -p std -p_opt "-b 20x25 -s 2" -parallel mpi_omp -arch X64_OCCIGEN -arch_path ../ARCH -job 8 > $here/log_compile 2>&1
ls -l bin/icosa_lmdz.exe
cp -rf bin/icosa_lmdz.exe $here
cd $here

cp ../code/XIOS/bin/xios_server.exe ./
