
echo "Install ioipsl"

echo "1) Before ioipsl installation, you have to install the model."
echo "If not, please use install.sh before install_ioipsl.sh"
echo "2) For the first installation, a login and a password are necessary"
echo "Please contact TGCC computing center to get the login/password."

echo "Start..."
cd code/LMDZ.COMMON/ioipsl/
#./install_ioipsl_centos-ifort.bash
#./install_ioipsl_irene-amd.bash
#./install_ioipsl_mesu.bash
#./install_ioipsl_ciclad-ifort.bash
#./install_ioipsl_jeanzay.bash
./install_ioipsl_occigen.bash
#./install_ioipsl_gfortran.bash
#./install_ioipsl_jeanzay_pgi.bash
#./install_ioipsl_pgf90.bash
#./install_ioipsl_ifort.bash
#./install_ioipsl_MesoPSL.bash
cd ../../../
echo "...end"
