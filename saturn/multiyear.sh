#! /bin/bash

# clear log
rm -rf log

### - selection tous les 500 jours
### - calcul precast
### - rename
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_[1-9].nc   /store/dbardet/saturn_96lvl_318k/Xhistins_10.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_01.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_1[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_20.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_02.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_2[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_30.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_03.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_3[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_40.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_04.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_4[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_50.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_05.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_5[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_60.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_06.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_6[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_70.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_07.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_7[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_80.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_08.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_8[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_90.nc  Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_09.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_9[1-9].nc  /store/dbardet/saturn_96lvl_318k/Xhistins_100.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_10.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_10[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_110.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_11.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_11[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_120.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_12.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_12[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_130.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_13.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_13[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_140.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_14.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_14[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_150.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_15.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_15[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_160.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_16.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_16[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_170.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_17.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_17[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_180.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_18.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_18[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_190.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_19.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_19[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_200.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_20.nc 
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_20[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_210.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_21.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_21[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_220.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_22.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_22[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_230.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_23.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_23[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_240.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_24.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_24[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_250.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_25.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_25[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_260.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_26.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_26[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_270.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_27.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_27[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_280.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_28.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_28[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_290.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_29.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_29[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_300.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_30.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_30[1-9].nc /store/dbardet/saturn_96lvl_318k/Xhistins_310.nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_31.nc
ncrcat -O -d time_counter,,,25 /store/dbardet/saturn_96lvl_318k/Xhistins_31[1-8].nc Xhistins_tmp.nc ; ~/dynanalysis/precast.py >> log ; mv precast.nc precast_32.nc


# ajouter un record dimension
rm -rf tprecast*
find precast_??.nc -exec ncks --mk_rec_dmn time_counter {} t{} \;

# tout concaténer dans un fichier tprecast_99.nc
ncrcat -O tprecast_??.nc ccat_precast_96lvl_318k_testpsi_TEM.nc
