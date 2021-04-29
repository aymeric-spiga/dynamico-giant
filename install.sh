#! /bin/bash

##############
### CONFIG ###
ver_dyn="5df634f9cd565660ad324a10d489baf44b3e6204"
ver_phys=2471
ver_xios=2060
ver_ioipsl=310
##############

###############
#### CONFIG ###
#ver_dyn=687 # ICOSAGCM
#ver_phys=1911 # ARCH ICOSA_LMDZ LMDZ.COMMON LMDZ.GENERIC
#ver_xios=1459 # XIOS
#ver_ioipsl=302 # IOIPSL
###############

rm -rf code
svn co -q -N http://svn.lmd.jussieu.fr/Planeto/trunk code

cd code

echo "get DYNAMICO..."
#svn co -r $ver_dyn -q http://forge.ipsl.jussieu.fr/dynamico/svn/codes/icosagcm/trunk ICOSAGCM
git clone https://gitlab.in2p3.fr/ipsl/projets/dynamico/dynamico.git ICOSAGCM
cd ICOSAGCM
git checkout $ver_dyn
cd ..

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

