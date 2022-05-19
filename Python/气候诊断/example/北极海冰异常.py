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

ds = xr.open_dataset('../data/HadISST_ice.nc')

year_start = 1979
year_end = 2020
year = range(year_start, year_end)
nyears = year_end - year_start + 1

var = ds['sic']
lat = ds['latitude']
lon = ds['longitude']

season_name = ["SON", "OND", "NDJ"]

sic_idx = np.array(np.loadtxt('../sic-idx/idx-filter.txt'))

projection = ccrs.NorthPolarStereo()

for myseason in season_name:
	var_son = Month_to_Season(var, myseason, "ave", year_start, year_end)
	
	var_reg, reg_sig = Linear_Regression_dim(var_son, sic_idx, 0)
	var_reg_xr = xr.DataArray(var_reg,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])
	
	# plot var
	
	plt.close
	
	var_reg_xr, lon1 = add_cyclic_point(var_reg_xr, coord=lon)
	#reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)
	
	fig, ax = draw_north_polar_steoro(60)
	
	levels = np.linspace(-0.14,0.14,29)
	
	im = ax.contourf(lon1, lat, var_reg_xr, levels=levels, cmap='bwr', transform=ccrs.PlateCarree(), extend="both")
	
	cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::4], shrink=0.8)
	cb.ax.tick_params(labelsize=18)
	
	# plot significant regions
	sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
	
	fig.show()
	fig.savefig("%s.png" % myseason, dpi=1000)
	
	print("%s" % myseason)
	
