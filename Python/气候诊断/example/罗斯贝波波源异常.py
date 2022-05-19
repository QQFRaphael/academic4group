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
from draw_polar_steoro import draw_north_polar_steoro
from Linear_Regression_dim import Linear_Regression_dim
from rossby_wave_source import RWS

mylev = 200

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

dsu = xr.open_dataset('../data/uwnd.mon.mean.nc')
dsv = xr.open_dataset('../data/vwnd.mon.mean.nc')

year_start = 1979
year_end = 2020
year = range(year_start, year_end)

dsu = lonFlip_EW(dsu)
dsv = lonFlip_EW(dsv)

lat = dsu['lat']
lon = dsu['lon']

uwnd = dsu['uwnd'].loc[:,200,:,:]
vwnd = dsv['vwnd'].loc[:,200,:,:]

tibet_shp = tibet_shp_load("../utils/tibet_shape")

for myseason in ["SON","OND","NDJ"]:
	uwnd_son = Month_to_Season(uwnd, myseason, "ave", year_start, year_end)
	vwnd_son = Month_to_Season(vwnd, myseason, "ave", year_start, year_end)

	rws = RWS(uwnd_son, vwnd_son)
	
	hgt_reg, reg_sig = Linear_Regression_dim(rws, sic_idx, 0)
	hgt_reg_xr = xr.DataArray(hgt_reg*1e11,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])
	
	# plot var
	
	plt.close
	
	hgt_reg_xr, lon1 = add_cyclic_point(hgt_reg_xr, coord=lon)
	reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)
	
	fig, ax = draw_north_polar_steoro(10)
	
	levels = np.linspace(-5,5,21)
	
	im = ax.contourf(lon1, lat, hgt_reg_xr, levels=levels, cmap=cmps.BlueDarkRed18, transform=ccrs.PlateCarree(), extend="both")
	
	cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::2], shrink=0.8)
	cb.ax.tick_params(labelsize=18)
	
	# plot significant regions
	sig1 = ax.contourf(lon2, lat, reg_sig_xr, [np.min(reg_sig_xr),0.2], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
	
	pgon = Polygon(tibet_shp)
	ax.add_geometries([pgon], crs=ccrs.PlateCarree(), facecolor="none", edgecolor='black', linewidth=1.0)
	
	fig.show()
	fig.savefig("%s.png" % myseason, dpi=1000)
	
	print("%s" % myseason)