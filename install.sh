#! /bin/bash

###############
### CONFIG ###
ver_dyn=90f7138a60ebd3644fbbc42bc9dfa22923386385 # ICOSAGCM
ver_phys=2653 # ARCH ICOSA_LMDZ LMDZ.COMMON LMDZ.GENERIC
ver_xios=2298 # XIOS
ver_ioipsl=453 # IOIPSL
###############

rm -rf code
svn co -q -N http://svn.lmd.jussieu.fr/Planeto/trunk code

cd code

echo "get PHYSICS..."
svn update -r $ver_phys -q LMDZ.COMMON
svn update -r $ver_phys -q LMDZ.GENERIC

echo "get interface..."
svn update -r $ver_phys -q ICOSA_LMDZ
svn update -r $ver_phys -q ARCH

echo "get I/O libraries..."
svn co -r $ver_xios -q http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk XIOS
svn co -r $ver_ioipsl -q http://forge.ipsl.jussieu.fr/heat/svn/codes/dynamico_lmdz/aquaplanet/IOIPSL

echo "get FCM..."
svn -q co http://forge.ipsl.jussieu.fr/fcm/svn/PATCHED/FCM_V1.2
echo "please add "$PWD"/FCM_V1.2/bin/ to PATH environment variable"

echo "from gitlab, get DYNAMICO..."
git clone https://gitlab.in2p3.fr/ipsl/projets/dynamico/dynamico.git ICOSAGCM
cd ICOSAGCM
git checkout $ver_dyn
cd ..

echo "...end"
