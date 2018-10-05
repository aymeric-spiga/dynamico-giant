##################################
import numpy as np
import netCDF4 as nc
##################################

### NetCDF file on 32 levels that contains q, theta_rhodz, u, ulon, ulat
ncfile="startfi_270_aspiga.nc"

### Get variables
file = nc.Dataset(ncfile,'r')


controle     = file.variables['controle'][:]
soildepth    = file.variables['soildepth'][:]
latitude    = file.variables['latitude'][:]
longitude    = file.variables['longitude'][:]
area         = file.variables['area'][:]
phisfi       = file.variables['phisfi'][:]
albedodat    = file.variables['albedodat'][:]
ZMEA         = file.variables['ZMEA'][:]
ZSTD         = file.variables['ZSTD'][:]
ZSIG         = file.variables['ZSIG'][:]
ZGAM         = file.variables['ZGAM'][:]
ZTHE         = file.variables['ZTHE'][:]
inertiedat   = file.variables['inertiedat'][:,:]
tsurf        = file.variables['tsurf'][:]
tsoil        = file.variables['tsoil'][:,:]
emis         = file.variables['emis'][:]
q2           = file.variables['q2'][:,:]
cloudfrac    = file.variables['cloudfrac'][:,:] 
totcloudfrac = file.variables['totcloudfrac'][:]
hice         = file.variables['hice'][:]
dummy        = file.variables['dummy'][:]


file.close()

###################################################################################################
###                         Creation of NetCDF file on 64 levels 
###################################################################################################
index = 100
physical_points = 252812
subsurface_layers = 18
nlayer_plus_1 = 65
number_of_advected_fields = 1
nlayer = 64
#nlayer = 32
ocean_layers = 2

output = nc.Dataset('startfi_270.nc','w',format='NETCDF4')

output.createDimension('index',index)
output.createDimension('physical_points',physical_points)
output.createDimension('subsurface_layers',subsurface_layers)
output.createDimension('nlayer_plus_1',nlayer_plus_1)
output.createDimension('number_of_advected_fields',number_of_advected_fields)
output.createDimension('nlayer',nlayer)
output.createDimension('ocean_layers',ocean_layers)
output.createDimension('Time',0)

controle_lvl64     = output.createVariable('controle','f4','index')
soildepth_lvl64    = output.createVariable('soildepth','f4','subsurface_layers')
latitude_lvl64     = output.createVariable('longitude','f4','physical_points')
longitude_lvl64    = output.createVariable('latitude','f4','physical_points')
area_lvl64         = output.createVariable('area','f4','physical_points')
phisfi_lvl64       = output.createVariable('phisfi','f4','physical_points')
albedodat_lvl64    = output.createVariable('albedodat','f4','physical_points')
ZMEA_lvl64         = output.createVariable('ZMEA','f4','physical_points')
ZSTD_lvl64         = output.createVariable('ZSTD','f4','physical_points')
ZSIG_lvl64         = output.createVariable('ZSIG','f4','physical_points')
ZGAM_lvl64         = output.createVariable('ZGAM','f4','physical_points')
ZTHE_lvl64         = output.createVariable('ZTHE','f4','physical_points')
inertiedat_lvl64   = output.createVariable('inertiedat','f4',('subsurface_layers','physical_points'))
tsurf_lvl64        = output.createVariable('tsurf','f4','physical_points')
tsoil_lvl64        = output.createVariable('tsoil','f4',('subsurface_layers','physical_points'))
emis_lvl64         = output.createVariable('emis','f4','physical_points')
q2_lvl64           = output.createVariable('q2','f4',('nlayer_plus_1','physical_points'))
cloudfrac_lvl64    = output.createVariable('cloudfrac','f4',('nlayer','physical_points'))
totcloudfrac_lvl64 = output.createVariable('totcloudfrac','f4','physical_points')
hice_lvl64         = output.createVariable('hice','f4','physical_points')
dummy_lvl64        = output.createVariable('dummy','f4','physical_points')

############################### GET ATTRIBUTES FOR VARIABLES #######################################

controle_lvl64.title     = 'Control parameter'
soildepth_lvl64.title    = 'Soil id-layer depth'
longitude_lvl64.title    = 'Longitude of physics grid'
latitude_lvl64.title     = 'Latitude of physics grid'
area_lvl64.title         = 'mesh area'
phisfi_lvl64.title       = 'Geoopential at the surface'
albedodat_lvl64.title    = 'Albedo of bare surface'
ZMEA_lvl64.title         = 'Relief: mean relief'
ZSTD_lvl64.title         = 'Relief: Standard deviation'
ZSIG_lvl64.title         = 'Relief: sigma parameter'
ZGAM_lvl64.title         = 'Relief: gamma parameter'
ZTHE_lvl64.title         = 'Relief: theta parameter'
inertiedat_lvl64.title   = 'Soil thermal inertia' 
tsurf_lvl64.title        = 'Surface temperature'
tsoil_lvl64.title        = 'Soi ltemperature'
emis_lvl64.title         = 'Surface emissivity'
q2_lvl64.title           = 'pbl wind variance'
cloudfrac_lvl64.title     = 'Cloud fraction'
totcloudfrac_lvl64.title = 'Totla fraction'
hice_lvl64.title         = 'Height og oceanic ice'
dummy_lvl64.title        = 'tracer on surface'

################################# GET VALUES OF VARIABLES ##########################################

controle_lvl64[:]     = controle
soildepth_lvl64[:]    = soildepth
latitude_lvl64[:]     = latitude
longitude_lvl64[:]    = longitude
area_lvl64[:]         = area
phisfi_lvl64[:]       = phisfi
albedodat_lvl64[:]    = albedodat
ZMEA_lvl64[:]         = ZMEA
ZSTD_lvl64[:]         = ZSTD
ZSIG_lvl64[:]         = ZSIG
ZGAM_lvl64[:]         = ZGAM
ZTHE_lvl64[:]         = ZTHE
inertiedat_lvl64[:]   = inertiedat
tsurf_lvl64[:]        = tsurf
tsoil_lvl64[:]        = tsoil
emis_lvl64[:]         = emis
totcloudfrac_lvl64[:] = totcloudfrac
hice_lvl64[:]         = hice
dummy_lvl64[:]        = dummy

for i in range(32):
	cloudfrac_lvl64[i,:] = cloudfrac[i,:]
for i in range(33):
	q2_lvl64[i,:]        = q2[i,:]

for i in range(32):
	cloudfrac_lvl64[i+32,:] = cloudfrac[31,:]
for i in range(32):
	q2_lvl64[i+33,:]        = q2[32,:]



output.close()
