import cmaps as cmps
import numpy as np
import xarray as xr
import cartopy.crs as ccrs
import matplotlib.pyplot as plt
from shapely.geometry.polygon import Polygon
from sklearn.feature_selection import f_regression

import sys
sys.path.append("../utils/")

from mon2season import Month_to_Season
from tibet_shp_load import tibet_shp_load
from Linear_Regression_dim import Linear_Regression_dim
from draw_PlateCarree import draw_PlateCarree

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

ds = xr.open_dataset('../data/cru_ts4.05.1901.2020.pre.dat.nc')

year_start = 1979
year_end = 2020
year = range(year_start, year_end)

prec = ds['pre'].loc[:,10:,-60:130]
lat = ds['lat'].loc[10:]
lon = ds['lon'].loc[-60:130]

tibet_shp = tibet_shp_load("../utils/tibet_shape")

projection = ccrs.PlateCarree()


for myseason in ["SON","OND","NDJ"]:
	prec_son = Month_to_Season(prec, myseason, "add", year_start, year_end)
	
	prec_reg, reg_sig = Linear_Regression_dim(prec_son, sic_idx, 0)

	prec_reg_xr = xr.DataArray(prec_reg,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])

	tibet_shp = tibet_shp_load("../utils/tibet_shape")
	
	# plot var
	
	plt.close

	fig, ax = draw_PlateCarree(20,80,-50,120)

	levels = np.arange(-10,10+2,2)
   
	im = ax.contourf(lon, lat, prec_reg_xr, levels=levels, cmap='RdYlGn', extend='both', transform=projection)
	cb = plt.colorbar(im, orientation='horizontal', ticks=np.arange(-10,10+2,2), shrink=0.8)
	cb.ax.tick_params(labelsize=18)

   # plot significant regions
	sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1],hatches=['..'], colors="none", zorder=1, transform=projection)

	pgon = Polygon(tibet_shp)
	ax.add_geometries([pgon], crs=projection, facecolor="None", edgecolor='k', linewidth=1.0)

	fig.show()
	fig.savefig( "%s.png" % myseason, dpi=1000)