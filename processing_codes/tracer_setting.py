###############################################################
import numpy as np
import netCDF4 as nc
###############################################################


# =============================================================
#                       --- ARGUMENTS ---
# =============================================================


## ncfile_name  netcdf file to be modified
ncfile_name = '/scratch/cnt0027/lmd1167/dbardet/dynamico-giant-recent/jupiter/start_icosa_water.nc'

## profile      new vertical profile
profile = '/scratch/cnt0027/lmd1167/dbardet/dynamico-giant-recent/jupiter/h2o_ice_profile.txt'

## tracer q index
iq = 1


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

