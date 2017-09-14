#! /bin/bash

##############
### CONFIG ###
ver_dyn=532
ver_phys=1711
ver_xios=1137
ver_ioipsl=195
##############

rm -rf code
svn co -q -N http://svn.lmd.jussieu.fr/Planeto/trunk code

cd code

echo "get DYNAMICO..."
svn co -r $ver_dyn -q http://forge.ipsl.jussieu.fr/dynamico/svn/codes/icosagcm/trunk ICOSAGCM

echo "get PHYSICS..."
svn update -r $ver_phys -q LMDZ.COMMON
svn update -r $ver_phys -q LMDZ.GENERIC

echo "...(apply patch)"
patch -p0 < ../code.patch/patch_bdycond_physiq_mod.F90.1711

echo "get interface..."
svn update -r $ver_phys -q ICOSA_LMDZ
svn update -r $ver_phys -q ARCH

echo "get I/O libraries..."
svn co -r $ver_xios -q http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk XIOS
svn co -r $ver_ioipsl -q http://forge.ipsl.jussieu.fr/heat/svn/codes/dynamico_lmdz/aquaplanet/IOIPSL

cd -

echo "get remap..."
svn co -q http://forge.ipsl.jussieu.fr/heat/svn/codes/remap
