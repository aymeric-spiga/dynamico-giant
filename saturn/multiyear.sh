#! /bin/bash

# clear log
rm -rf log

# - selection tous les 500 jours
# - calcul precast
# - rename
ncrcat -O -d time_counter,,,25 Xhistins_[1-9].nc   Xhistins_10.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_01.nc 
ncrcat -O -d time_counter,,,25 Xhistins_1[1-9].nc  Xhistins_20.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_02.nc 
ncrcat -O -d time_counter,,,25 Xhistins_2[1-9].nc  Xhistins_30.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_03.nc 
ncrcat -O -d time_counter,,,25 Xhistins_3[1-9].nc  Xhistins_40.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_04.nc 
ncrcat -O -d time_counter,,,25 Xhistins_4[1-9].nc  Xhistins_50.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_05.nc 
ncrcat -O -d time_counter,,,25 Xhistins_5[1-9].nc  Xhistins_60.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_06.nc 
ncrcat -O -d time_counter,,,25 Xhistins_6[1-9].nc  Xhistins_70.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_07.nc 
ncrcat -O -d time_counter,,,25 Xhistins_7[1-9].nc  Xhistins_80.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_08.nc 
ncrcat -O -d time_counter,,,25 Xhistins_8[1-9].nc  Xhistins_90.nc  Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_09.nc 
ncrcat -O -d time_counter,,,25 Xhistins_9[1-9].nc  Xhistins_100.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_10.nc 
ncrcat -O -d time_counter,,,25 Xhistins_10[1-9].nc Xhistins_110.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_11.nc 
ncrcat -O -d time_counter,,,25 Xhistins_11[1-9].nc Xhistins_120.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_12.nc 
ncrcat -O -d time_counter,,,25 Xhistins_12[1-9].nc Xhistins_130.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_13.nc 
ncrcat -O -d time_counter,,,25 Xhistins_13[1-9].nc Xhistins_140.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_14.nc 
ncrcat -O -d time_counter,,,25 Xhistins_14[1-9].nc Xhistins_150.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_15.nc 
ncrcat -O -d time_counter,,,25 Xhistins_15[1-9].nc Xhistins_160.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_16.nc 
ncrcat -O -d time_counter,,,25 Xhistins_16[1-9].nc Xhistins_170.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_17.nc 
ncrcat -O -d time_counter,,,25 Xhistins_17[1-9].nc Xhistins_180.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_18.nc 
ncrcat -O -d time_counter,,,25 Xhistins_18[1-9].nc Xhistins_190.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_19.nc 
ncrcat -O -d time_counter,,,25 Xhistins_19[1-9].nc Xhistins_200.nc Xhistins_tmp.nc ; ./precast.py >> log ; mv precast.nc precast_20.nc 

# ajouter un record dimension
find precast_??.nc -exec ncks --mk_rec_dmn time_counter {} t{} \;

# tout concaténer dans un fichier tprecast_99.nc
ncrcat tprecast_??.nc tprecast_99.nc
