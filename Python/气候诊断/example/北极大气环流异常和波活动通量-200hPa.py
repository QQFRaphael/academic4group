import cmaps as cmps
import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeat

from cartopy.util import add_cyclic_point
from shapely.geometry.polygon import Polygon
from sklearn.feature_selection import f_regression
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER

import sys
sys.path.append("../utils/")

from mon2season import Month_to_Season
from lonFlip import lonFlip_EW, lonFlip_360
from tibet_shp_load import tibet_shp_load
from tnflux import tnflux
from draw_polar_steoro import draw_north_polar_steoro
from Linear_Regression_dim import Linear_Regression_dim

mylev = 200

#sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")
sic_idx = np.loadtxt("../test/myidx.txt")

dsz = xr.open_dataset('../data/hgt.mon.mean.nc')
dsu = xr.open_dataset('../data/uwnd.mon.mean.nc')
dsv = xr.open_dataset('../data/vwnd.mon.mean.nc')
dst = xr.open_dataset('../data/air.mon.mean.nc')

year_start = 1979
year_end = 2020
year = range(year_start, year_end)

dsz = lonFlip_EW(dsz)
dsu = lonFlip_EW(dsu)
dsv = lonFlip_EW(dsv)

hgt = dsz['hgt'].loc[:,200,:0,:]
lat = dsz['lat'].loc[:0]
lon = dsz['lon']

uwnd = dsu['uwnd'].loc[:,200,:0,:]
vwnd = dsv['vwnd'].loc[:,200,:0,:]

uwnd_son = Month_to_Season(uwnd, "SON", "ave", year_start, year_end)
vwnd_son = Month_to_Season(vwnd, "SON", "ave", year_start, year_end)

u_c = uwnd_son.mean(dim="time")
v_c = vwnd_son.mean(dim="time")

for myseason in ["SON","OND","NDJ"]:
	hgt_son = Month_to_Season(hgt, myseason, "ave", year_start, year_end)
	uwnd_son = Month_to_Season(uwnd, myseason, "ave", year_start, year_end)
	vwnd_son = Month_to_Season(vwnd, myseason, "ave", year_start, year_end)
	
	hgt_reg, reg_sig = Linear_Regression_dim(hgt_son, sic_idx, 0)
	hgt_reg_xr = xr.DataArray(hgt_reg,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])
	
	Fx, Fy = tnflux(u_c, v_c, hgt_reg_xr, mylev, lat, lon, 0.01)
	
	Fx.loc[11:,:] = np.nan
	Fy.loc[11:,:] = np.nan
	
	tibet_shp = tibet_shp_load("../utils/tibet_shape")
	
	# plot var
	
	plt.close
	
	hgt_reg_xr, lon1 = add_cyclic_point(hgt_reg_xr, coord=lon)
	reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)
	
	Fx, lonFx = add_cyclic_point(Fx, coord=lon)
	Fy, lonFy = add_cyclic_point(Fy, coord=lon)
	
	fig, ax = draw_north_polar_steoro(10)
	
	levels = np.arange(-40,40+5,5)
	
	im = ax.contourf(lon1, lat, hgt_reg_xr, levels=levels, cmap=cmps.BlueDarkRed18, transform=ccrs.PlateCarree(), extend="both")
	
	cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::2], shrink=0.8)
	cb.ax.tick_params(labelsize=18)
	
	# plot significant regions
	sig1 = ax.contourf(lon2, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
	
	pgon = Polygon(tibet_shp)
	ax.add_geometries([pgon], crs=ccrs.PlateCarree(), facecolor="none", edgecolor='black', linewidth=1.0)
	
	# plot wave activity flux
	fontproperties = {"size":14}
	waf = ax.quiver(lonFx[::2], lat[::2], Fx[::2,::2], Fy[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0018, scale=2.0, headwidth=4)
	waf_key = ax.quiverkey(waf, 0.85, -0.13, 0.20, "0.20", color="black", fontproperties=fontproperties)
	
	fig.show()
	fig.savefig("%s.png" % myseason, dpi=1000)
	
	print("%s" % myseason)
	
