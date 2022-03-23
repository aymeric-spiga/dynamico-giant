##################################
import numpy as np
import netCDF4 as nc
from scipy import *
##################################

### NetCDF file on 61 levels created by makestart: just to take theta_rhodz and u, ulon and ulat from the 30th to 61st vertical levels 
ncfile="start_icosa_5.nc"
file = nc.Dataset(ncfile,'r')
theta_61             = file.variables['theta_rhodz'][:,:]
u_61                 = file.variables['u'][:,:]
ulon_61              = file.variables['ulon'][:,:]
ulat_61              = file.variables['ulat'][:,:]
### NetCDF file on 32 levels that contains q,theta_rhodz, u, ulon, ulat
ncfile="start_icosa_270_aspiga.nc"

### Get variables
file = nc.Dataset(ncfile,'r')

lat_mesh            = file.variables['lat_mesh'][:]
lon_mesh            = file.variables['lon_mesh'][:]
bounds_lon_mesh     = file.variables['bounds_lon_mesh'][:,:]
bounds_lat_mesh     = file.variables['bounds_lon_mesh'][:,:]
lev                 = file.variables['lev'][:]
nq                  = file.variables['nq'][:]
lat_u               = file.variables['lat_u'][:]
lon_u               = file.variables['lon_u'][:]
bounds_lon_u        = file.variables['bounds_lon_u'][:,:]
bounds_lat_u        = file.variables['bounds_lat_u'][:,:]
iteration           = file.variables['iteration'][:]
ps                  = file.variables['ps'][:,:]
phis                = file.variables['phis'][:,:]
q                   = file.variables['q'][:,:,:,:] 
#theta_32            = file.variables['theta_rhodz'][:,:,:]
u_32                = file.variables['u'][:,:,:]
ulat_32             = file.variables['ulat'][:,:,:]
ulon_32             = file.variables['ulon'][:,:,:]

file.close()

#########################################################################################################
###                              Creation of NetCDF file on 64 levels 
#########################################################################################################

axis_nbounds = 2
cell_mesh = 252812
nvertex_mesh = 6
nq = 1
cell_u = 758430
nvertex_u= 2

newlvl = 61

output = nc.Dataset('start_icosa_270.nc','w',format='NETCDF4')

output.createDimension('cell_mesh',cell_mesh)
output.createDimension('lev',newlvl)
output.createDimension('nq',nq)
output.createDimension('cell_u',cell_u)
output.createDimension('axis_nbounds',axis_nbounds)
output.createDimension('nvertex_mesh',nvertex_mesh)
output.createDimension('nvertex_u',nvertex_u)
output.createDimension('time_counter',0)

lat_mesh_new         = output.createVariable('lat_mesh','f4','cell_mesh')
lon_mesh_new         = output.createVariable('lon_mesh','f4','cell_mesh')
bounds_lon_mesh_new  = output.createVariable('bounds_lon_mesh','f4',('cell_mesh','nvertex_mesh'))
bounds_lat_mesh_new  = output.createVariable('bounds_lat_mesh','f4',('cell_mesh','nvertex_mesh'))
lev_new              = output.createVariable('lev','f4','lev')
nq_new               = output.createVariable('nq','f4','nq')
lat_u_new            = output.createVariable('lat_u','f4','cell_u')
lon_u_new            = output.createVariable('lon_u','f4','cell_u')
bounds_lon_u_new     = output.createVariable('bounds_lon_u','f4',('cell_u','nvertex_u'))
bounds_lat_u_new     = output.createVariable('bounds_lat_u','f4',('cell_u','nvertex_u'))
iteration_new        = output.createVariable('iteration','f4')#,0)
ps_new               = output.createVariable('ps','f4',('cell_mesh'))
phis_new             = output.createVariable('phis','f4',('cell_mesh'))
q_new                = output.createVariable('q','f4',('nq','lev','cell_mesh'))
theta_new            = output.createVariable('theta_rhodz','f4',('lev','cell_mesh'))
u_new                = output.createVariable('u','f4',('lev','cell_u'))
ulat_new             = output.createVariable('ulat','f4',('lev','cell_mesh'))
ulon_new             = output.createVariable('ulon','f4',('lev','cell_mesh'))

################################ GET GLOBAL ATTRIBUTES FOR NEW FILE ######################################

output.name        = 'restart_icosa'
output.description = 'Created by xios'
output.title       = 'Created by xios'
output.Conventions = 'CF-1.6'
output.timeStamp   = '2018-Jun-01 20:49:38 GMT'
output.uuid        = 'cfddba90-e494-44e1-b07d-1bd53a2a748a' 

################################# GET ATTRIBUTES FOR NEW VARIABLES #######################################

q_new.online_operation     = 'once'
q_new.coordinates          = 'lat_mesh lon_mesh'

ps_new.online_operation    = 'once'
ps_new.coordinates         = 'lat_mesh lon_mesh'

phis_new.online_operation  = 'once'
phis_new.coordinates       = 'lat_mesh lon_mesh'

theta_new.online_operation = 'once'
theta_new.coordinates      = 'lat_mesh lon_mesh'

ulon_new.online_operation  = 'once'
ulon_new.coordinates       = 'lat_mesh lon_mesh'

ulat_new.online_operation  = 'once'
ulat_new.coordinates       = 'lat_mesh lon_mesh'

u_new.online_operation     = 'once'
u_new.coordinates          = 'lat_u lon_u'
	
lat_mesh_new.standard_name = 'latitude'
lat_mesh_new.long_name     = 'Latitude'
lat_mesh_new.units         = 'degrees_north'
lat_mesh_new.bounds        = 'bounds_lat_mesh'

lon_mesh_new.standard_name = 'longitude'
lon_mesh_new.long_name     = 'Longitude'
lon_mesh_new.units         = 'degrees_east'
lon_mesh_new.bounds        = 'bounds_lon_mesh'

lat_u_new.standard_name    = 'latitude'
lat_u_new.long_name        = 'Latitude'
lat_u_new.units            = 'degrees_north'
lat_u_new.bounds           = 'bounds_lat_u'

lon_u_new.standard_name    = 'longitude'
lon_u_new.long_name        = 'Longitude'
lon_u_new.units            = 'degrees_east'
lon_u_new.bounds           = 'bounds_lon_u'

#nqlvl64.name = 'nq'

lev_new.standard_name      = 'atmosphere_hybrid_sigma_pressure_coordinate'
lev_new.long_name          = 'hybrid level at midpoints'
lev_new.positive           = 'down'

#iteration.online_operation  = 'once'
#iteration.coordinates       = ' '

################################# GET VALUES FOR NEW VARIABLES ########################################

lat_mesh_new[:]            = lat_mesh
lon_mesh_new[:]            = lon_mesh
bounds_lon_mesh_new[:]     = bounds_lon_mesh
bounds_lat_mesh_new[:]     = bounds_lat_mesh
nq_new[:]                  = nq
lat_u_new[:]               = lat_u
lon_u_new[:]               = lon_u
bounds_lon_u_new[:]        = bounds_lon_u
bounds_lat_u_new[:]        = bounds_lat_u
iteration_new[:]           = 8.608032e+07 #time iteration value of this specific start file
ps_new[:]                  = ps[0,:]
phis_new[:]                = phis[0,:]
lev_new[:]                 = range(1,62,1)
theta_new[:]               = theta_61

# Initialisation:
u_new[:,:]    = 0.
ulon_new[:,:] = 0.
ulat_new[:,:] = 0.

# Calculations:
for i in range(26):
	u_new[i,:]     = u_32[0,i,:]
	ulon_new[i,:]  = ulon_32[0,i,:]
	ulat_new[i,:]  = ulat_32[0,i,:]

# Linear decreasing to zero between 30th and 45th vertical levels
#for i in range(15):
#	u_new[i+30,:]     = (15-i)*u_32[0,29,:]/15.
#	ulon_new[i+30,:]  = (15-i)*ulon_32[0,29,:]/15.
#	ulat_new[i+30,:]  = (15-i)*ulat_32[0,29,:]/15.
# Exponential decreasing to zero between 30th and 45th vertical levels 
#for i in range(15):
#	u_new[i+30,:]     = 
#	ulon_new[i+30,:]  = 
#	ulat_new[i+30,:]  = 
# Mix the start_icosa_270.nc's troposphere (the first 30 vertical levels) and 
# the start_icosa_5.nc's stratosphere (the last 31 vertical levels)
# PLUS shift of the difference between u_32[29,:] and u_61[30,:] for the stratosphere profil 
for i in range(35):
	u_new[i+26,:]    = u_61[i+26,:]    - (u_61[26,:]-u_new[25,:])
	ulon_new[i+26,:] = ulon_61[i+26,:] - (ulon_61[26,:]-ulon_new[25,:])
	ulat_new[i+26,:] = ulat_61[i+26,:] - (ulat_61[26,:]-ulat_new[25,:])

for i in range(30):
	q_new[:,i,:]    = q[0,:,i,:]
for i in range(31):
	q_new[:,i+30,:] = q[0,:,29,:]

print "i, u_extended, q_extended"
for i in range(61):
        print i,   u_new[i,3456],       q_new[0,i,3456]

# tests
print("q_lvl32",shape(q))
print("q_lvl64",shape(q_new))
print("level",shape(lev_new))


output.close()
