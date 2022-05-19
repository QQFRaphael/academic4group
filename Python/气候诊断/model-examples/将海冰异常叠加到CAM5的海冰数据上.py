import cmaps as cmps
import numpy as np
import xarray as xr

import sys
sys.path.append("../utils/")

from lonFlip import lonFlip_EW, lonFlip_360

ds1 = xr.open_dataset('sea_ice.nc')
ds2 = xr.open_dataset('anom.nc')

ds2 = lonFlip_360(ds2)
ds2 = ds2.sortby(ds2.lat)

lat = ds1['lat']
lon = ds1['lon']

ice_cov = ds1['ice_cov']

anom = ds2['sic']

anom.loc[:71,:] = 0.0
anom.loc[80:,:] = 0.0
anom.loc[:,:120] = 0.0
anom.loc[:,225:] = 0.0

# anom.fillna(0.0) not work
nflag = anom.isnull()
anom = np.where(nflag, 0.0, anom)
anom = xr.DataArray(anom,coords=[("lat",lat.values),("lon",lon.values)],name="sic")

#anom.to_netcdf("aa.nc",encoding={'lat':{'_FillValue': None}})


ice_cov[8,:,:] = ice_cov[8,:,:] + anom
ice_cov[9,:,:] = ice_cov[9,:,:] + anom
ice_cov[10,:,:] = ice_cov[10,:,:] + anom

ds3 = xr.open_dataset('sea_ice.nc')
ds3['ice_cov'].values = ice_cov

ds3.to_netcdf("test.nc", format="NETCDF3_CLASSIC", encoding={ 'lon':{'_FillValue': None},
	'lat':{'_FillValue': None},
	'time':{'_FillValue': None},
	'ice_cov':{'_FillValue': None},
	'ice_cov_prediddle':{'_FillValue': None},
	'SST_cpl':{'_FillValue': None},
	'SST_cpl_prediddle':{'_FillValue': None}
	})