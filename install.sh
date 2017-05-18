#! /bin/bash

rm -rf code
svn co -q -N http://svn.lmd.jussieu.fr/Planeto/trunk code

cd code

echo "get DYNAMICO..."
svn co -q http://forge.ipsl.jussieu.fr/dynamico/svn/codes/icosagcm/trunk ICOSAGCM

echo "get PHYSICS..."
svn update -q LMDZ.COMMON
svn update -q LMDZ.GENERIC

echo "get interface..."
svn update -q ICOSA_LMDZ
svn update -q ARCH

echo "get I/O libraries..."
svn co -q http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk XIOS
svn co -q http://forge.ipsl.jussieu.fr/heat/svn/codes/dynamico_lmdz/aquaplanet/IOIPSL

echo "fix"
cd ..
cp fix/arch-X64_OCCIGEN.fcm code/IOIPSL/arch/
