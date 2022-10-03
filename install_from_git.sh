#! /bin/bash

###############
### CONFIG ###
ver_dyn=HEAD # ICOSAGCM
ver_phys=HEAD # ARCH ICOSA_LMDZ LMDZ.COMMON LMDZ.GENERIC
ver_xios=HEAD # XIOS
ver_ioipsl=453 # IOIPSL
###############

# ###############
# ### CONFIG ###
# ver_dyn=90f7138a60ebd3644fbbc42bc9dfa22923386385 # ICOSAGCM
# ver_phys=2655 # ARCH ICOSA_LMDZ LMDZ.COMMON LMDZ.GENERIC
# ver_xios=2298 # XIOS
# ver_ioipsl=453 # IOIPSL
# ###############

rm -rf code
#get LMDZ form gitlab instead of svn
git clone git@gitlab.in2p3.fr:la-communaut-des-mod-les-atmosph-riques-plan-taires/git-trunk.git code

cd code

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
