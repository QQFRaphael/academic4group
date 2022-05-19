import numpy as np
import xarray as xr

import sys
sys.path.append("../utils/")
from water_vapor_flux import water_vapor_flux_div_column

dsu = xr.open_dataset('../data/uwnd.mon.mean.nc')
dsv = xr.open_dataset('../data/vwnd.mon.mean.nc')
dsq = xr.open_dataset('../data/q.mon.mean.nc')

lat = dsu['lat'] 
lon = dsu['lon'] 

lev = dsu['level']

uwnd = dsu['uwnd']
vwnd = dsv['vwnd']

time = dsu['time']

sp = dsq['q']

uq,vq,div=water_vapor_flux_div_column(sp,uwnd,vwnd,lat,lon,lev)


uq = xr.DataArray(uq,coords=[("time",time.values),("lat",lat.values),("lon",lon.values)], name="uq")
vq = xr.DataArray(vq,coords=[("time",time.values),("lat",lat.values),("lon",lon.values)], name="vq")
div = xr.DataArray(div,coords=[("time",time.values),("lat",lat.values),("lon",lon.values)], name="div")


div.to_netcdf("div.nc")
uq.to_netcdf("uq.nc")
vq.to_netcdf("vq.nc")

#ncl_div = dsdiv['div'][0,0,:,:]
#
##div = np.gradient(uwnd, lon, axis=3) + np.gradient(vwnd, lat, axis=2)
#
#xx, yy = np.meshgrid(lon, lat)
#
#dx = np.cos(yy) * np.gradient(xx, axis=1) * 6378388.0
#dy = np.gradient(yy,axis=0) * 6378388.0
#
#
#div2 = np.gradient(uwnd, axis=1)/dx + np.gradient(vwnd,axis=0)/dy - vwnd/6378388.0*np.tan(yy)
#div2 = xr.DataArray(div2, coords=[("lat",dsu['lat']),("lon",dsu['lon'])])
