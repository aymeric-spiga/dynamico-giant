#! /bin/bash

###############
### CONFIG ###
ver_dyn=90f7138a60ebd3644fbbc42bc9dfa22923386385 # ICOSAGCM
ver_phys= 2655 #2653 # ARCH ICOSA_LMDZ LMDZ.COMMON LMDZ.GENERIC
ver_xios= 2319 #2298 # XIOS
ver_ioipsl= 453 # IOIPSL
###############

echo "Start..."
rm -rf code
svn co -q -N http://svn.lmd.jussieu.fr/Planeto/trunk code

cd code

echo "1/9: get PHYSICS... (1/2) LMDZ.COMMON"
svn update -r $ver_phys -q LMDZ.COMMON
echo "2/9: get PHYSICS... (2/2) LMDZ.GENERIC"
svn update -r $ver_phys -q LMDZ.GENERIC

echo "3/9: get interface... (1/3) ICOSA_LMDZ"
svn update -r $ver_phys -q ICOSA_LMDZ
echo "4/9: get interface... (2/3) ARCH"
svn update -r $ver_phys -q ARCH
echo "5/9: get interface... (3/3) DOC"
svn update -r $ver_phys DOC

echo "6/9: get I/O libraries... (1/2) IOIPSL"
svn co -r $ver_xios -q http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk XIOS
echo "7/9: get I/O libraries... (2/2) XIOS"
svn co -r $ver_ioipsl -q http://forge.ipsl.jussieu.fr/heat/svn/codes/dynamico_lmdz/aquaplanet/IOIPSL

echo "8/9: get FCM..."
svn -q co http://forge.ipsl.jussieu.fr/fcm/svn/PATCHED/FCM_V1.2
echo "please add "$PWD"/FCM_V1.2/bin/ to PATH environment variable"

echo "9/9: from gitlab, get DYNAMICO..."
git clone https://gitlab.in2p3.fr/ipsl/projets/dynamico/dynamico.git ICOSAGCM
cd ICOSAGCM
git checkout $ver_dyn
cd ..

echo "...end"
