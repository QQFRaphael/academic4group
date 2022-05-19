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
from lonFlip import lonFlip_EW, lonFlip_360
from Linear_Regression_dim import Linear_Regression_dim
from draw_PlateCarree import draw_PlateCarree

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

ds = lonFlip_EW(xr.open_dataset('div.nc'))
duq = lonFlip_EW(xr.open_dataset('uq.nc'))
dvq = lonFlip_EW(xr.open_dataset('vq.nc'))

year_start = 1979
year_end = 2020
year = range(year_start, year_end)

prec = ds['div'].loc[:,:10,-60:130]

uu = duq['uq'].loc[:,:10,-60:130]
vv = dvq['vq'].loc[:,:10,-60:130]

lat = ds['lat'].loc[:10]
lon = ds['lon'].loc[-60:130]

tibet_shp = tibet_shp_load("../utils/tibet_shape")

projection = ccrs.PlateCarree()


for myseason in ["SON","OND","NDJ"]:
	prec_son = Month_to_Season(prec, myseason, "ave", year_start, year_end)
	prec_son.values = prec_son.values*1E5

	uq_son = Month_to_Season(uu, myseason, "ave", year_start, year_end)
	uq_son.values = uq_son.values / 1000.0

	vq_son = Month_to_Season(vv, myseason, "ave", year_start, year_end)
	vq_son.values = vq_son.values / 1000.0
	
	prec_reg, reg_sig = Linear_Regression_dim(prec_son, sic_idx, 0)

	prec_reg_xr = xr.DataArray(prec_reg,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])

	uq_reg, uq_sig = Linear_Regression_dim(uq_son, sic_idx, 0)
	vq_reg, vq_sig = Linear_Regression_dim(vq_son, sic_idx, 0)

	#uq_reg_xr = xr.DataArray(uq_reg,coords=[("lat",lat),("lon",lon)])
	#uq_sig_xr = xr.DataArray(uq_sig,coords=[("lat",lat),("lon",lon)])

	#vq_reg_xr = xr.DataArray(vq_reg,coords=[("lat",lat),("lon",lon)])
	#vq_sig_xr = xr.DataArray(vq_sig,coords=[("lat",lat),("lon",lon)])

	u_sig = np.where(np.logical_or(uq_sig<=0.1, vq_sig<=0.1), uq_reg, np.nan)
	v_sig = np.where(np.logical_or(uq_sig<=0.1, vq_sig<=0.1), vq_reg, np.nan)

	u_not_sig = np.where(np.logical_and(uq_sig>0.1, vq_sig>0.1), uq_reg, np.nan)
	v_not_sig = np.where(np.logical_and(uq_sig>0.1, vq_sig>0.1), vq_reg, np.nan)

	u_sig_xr = xr.DataArray(u_sig,coords=[("lat",lat.values),("lon",lon.values)])
	v_sig_xr = xr.DataArray(v_sig,coords=[("lat",lat.values),("lon",lon.values)])

	u_not_sig_xr = xr.DataArray(u_not_sig,coords=[("lat",lat.values),("lon",lon.values)])
	v_not_sig_xr = xr.DataArray(v_not_sig,coords=[("lat",lat.values),("lon",lon.values)])

	tibet_shp = tibet_shp_load("../utils/tibet_shape")
	
	# plot var
	
	plt.close

	fig, ax = draw_PlateCarree(20,80,-50,120)

	levels = np.arange(-10,10+1,1)
   
	im = ax.contourf(lon, lat, prec_reg_xr, levels=levels, cmap='RdYlGn', extend='both', transform=projection)
	cb = plt.colorbar(im, orientation='horizontal', ticks=np.arange(-10,10+2,2), shrink=0.8)
	cb.ax.tick_params(labelsize=18)

   # plot significant regions
	sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1],hatches=['..'], colors="none", zorder=1, transform=projection)

	fontproperties = {"size":14}
	uvflux_sig = ax.quiver(lon[::2], lat[::2], u_sig_xr[::2,::2], v_sig_xr[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0028, scale=3.0, headwidth=4, color="k")
	uvflux_not_sig = ax.quiver(lon[::2], lat[::2], u_not_sig_xr[::2,::2], v_not_sig_xr[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0018, scale=2.0, headwidth=4, color="gray")
	
	uvflux_sig_key = ax.quiverkey(uvflux_sig, 0.95, -0.18, 0.20, "0.20", color="black", fontproperties=fontproperties)


	pgon = Polygon(tibet_shp)
	ax.add_geometries([pgon], crs=projection, facecolor="None", edgecolor='k', linewidth=1.0)

	fig.show()
	fig.savefig( "%s.png" % myseason, dpi=1000)
