import numpy as np
import cmaps as cmps
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
from sklearn.feature_selection import f_regression
from cartopy.util import add_cyclic_point
from shapely.geometry.polygon import Polygon

import sys
sys.path.append("../utils/")

from conform_dim import conform_dim
from mon2season import Month_to_Season
from Linear_Regression_dim import Linear_Regression_dim
from ck import ck, ke
from tibet_shp_load import tibet_shp_load
from vertical_integration import vertical_integration2
from draw_polar_steoro import draw_north_polar_steoro


re = 6378388.0

uu = xr.open_dataset('../data/uwnd.mon.mean.nc')
vv = xr.open_dataset('../data/vwnd.mon.mean.nc')

lev = uu['level'] #.loc[1000:100]

lat = uu['lat'].loc[:0] 
lon = uu['lon'] 

nlon, nlat = np.meshgrid(lon * np.pi / 180.0, lat * np.pi / 180.0)

dlat = np.gradient(nlat, axis=0) 
dlon = np.gradient(nlon, axis=1)

dx = re * np.cos(nlat) * dlon
dy = dlat * re 

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

tibet_shp = tibet_shp_load("../utils/tibet_shape")


for season in ["SON", "OND", "NDJ"]:
	uwnd = Month_to_Season(uu['uwnd'].loc[:,:,:0,:], season, "ave", 1979, 2020)
	vwnd = Month_to_Season(vv['vwnd'].loc[:,:,:0,:], season, "ave", 1979, 2020)
	
	u_ave = uwnd.mean(dim="time")
	v_ave = vwnd.mean(dim="time")

	ua, ua_sig = Linear_Regression_dim(uwnd, sic_idx, 0)
	va, va_sig = Linear_Regression_dim(vwnd, sic_idx, 0)

	CK = ck(ua, va, u_ave, v_ave, dx, dy) 

	CK = xr.DataArray(CK,coords=[("lev",lev.values),("lat",lat.values),("lon",lon.values)])

	CK = vertical_integration2(CK, lev) * 1e3
	CK = xr.DataArray(CK,coords=[("lat",lat.values),("lon",lon.values)])
	CK.loc[90,:] = 0.0
	CK.to_netcdf("CK-%s.nc" % season)

	# plot var
	
	plt.close
	
	CK, lon1 = add_cyclic_point(CK, coord=lon)
	
	fig, ax = draw_north_polar_steoro(10)
	
	levels = [-2.0,-1.5,-1.0,-0.5,0,0.5,1.0,1.5,2.0]
	
	im = ax.contourf(lon1, lat, CK, transform=ccrs.PlateCarree(), extend="both", cmap=cmps.BlueDarkRed18, levels=levels)
	
	cb = plt.colorbar(im, orientation='horizontal',  shrink=0.8)
	cb.ax.tick_params(labelsize=18)
		
	pgon = Polygon(tibet_shp)
	ax.add_geometries([pgon], crs=ccrs.PlateCarree(), facecolor="none", edgecolor='black', linewidth=1.0)

	fig.show()
	fig.savefig("%s.png" % season, dpi=1000)
	
	print("%s" % season)