#! /bin/bash

##############
### CONFIG ###
ver_dyn=HEAD # obsolete. should be a gitlab code.
ver_phys=HEAD
ver_xios=HEAD
ver_ioipsl=HEAD
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

echo "...end"
