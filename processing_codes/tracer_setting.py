###############################################################
import numpy as np
import netCDF4 as nc
###############################################################


# =============================================================
#                       --- ARGUMENTS ---
# =============================================================


## ncfile_name  netcdf file to be modified
ncfile_name = '/store/aboissinot/Makestarts/start_icosa_nbp40_64lvl_p10bar_1SA.nc'

## profile      new vertical profile
profile = '/home/aboissinot/profiles/h2o_profile/h2o_profile_1SAp10-2bar_64lvlp10bar.txt'

## tracer q index
iq = 0


# =============================================================
#              --- TRACER PROFILE MODIFICATION ---
# =============================================================


## open netcdf file

ncdf = nc.Dataset(ncfile_name,'r+')

## load current q profile

q_old = ncdf['q'][iq,:,:]

## load replacing q profile

q_new = np.loadtxt(profile, unpack=True)
q_new = np.transpose(np.tile(q_new[:], (q_old.shape[1],1)))

## computations

if not np.all(q_new.shape==q_old.shape):
   print 'ERROR: new profile shape does not match the pre-existing one'
   print q_new.shape, ' not equal to ', q_old.shape
else:
   ncdf['q'][iq,:,:] = q_new

## close netcdf file

ncdf.close()

