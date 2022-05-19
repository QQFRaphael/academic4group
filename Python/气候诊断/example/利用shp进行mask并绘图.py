import cmaps as cmps
import numpy as np
import xarray as xr
import cartopy.crs as ccrs
import matplotlib.pyplot as plt
import cartopy.feature as cfeature
import cartopy.io.shapereader as shpreader
from shapely.geometry.polygon import Polygon
from sklearn.feature_selection import f_regression


import sys
sys.path.append("../utils/")

from mon2season import Month_to_Season
from Linear_Regression_dim import Linear_Regression_dim
from draw_PlateCarree import draw_PlateCarree
from lonFlip import lonFlip_EW, lonFlip_360
from maskclip import shp2clip

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

ds = xr.open_dataset('../data/cru_ts4.05.1901.2020.pre.dat.nc')

du = lonFlip_EW(xr.open_dataset('../data/uwnd.mon.mean.nc'))
dv = lonFlip_EW(xr.open_dataset('../data/vwnd.mon.mean.nc'))

year_start = 1979
year_end = 2020
year = range(year_start, year_end)

prec = ds['pre'].loc[:,10:,-90:160]
lat = ds['lat'].loc[10:]
lon = ds['lon'].loc[-90:160]

uwnd = du['uwnd'].loc[:,850,:10,-90:160]
vwnd = dv['vwnd'].loc[:,850,:10,-90:160]

ulat = du['lat'].loc[:10]
ulon = du['lon'].loc[-90:160]

projection = ccrs.PlateCarree()

shpfn = r'../utils/china_boundary/bou2_4p.shp'
reader = shpreader.Reader(shpfn)
statesFeat = cfeature.ShapelyFeature(reader.geometries(), projection, facecolor='none')

for myseason in ["SON"]:  #,"OND","NDJ"]:
	prec_son = Month_to_Season(prec, myseason, "add", year_start, year_end)
	
	prec_reg, reg_sig = Linear_Regression_dim(prec_son, sic_idx, 0)

	prec_reg_xr = xr.DataArray(prec_reg,coords=[("lat",lat.values),("lon",lon.values)])
	reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])

	u_son = Month_to_Season(uwnd, myseason, "ave", year_start, year_end)
	
	u_reg, u_sig = Linear_Regression_dim(u_son, sic_idx, 0)

	u_reg_xr = xr.DataArray(u_reg,coords=[("lat",ulat.values),("lon",ulon.values)])
	#u_sig_xr = xr.DataArray(u_sig,coords=[("lat",ulat.values),("lon",ulon.values)])

	v_son = Month_to_Season(vwnd, myseason, "ave", year_start, year_end)
	
	v_reg, v_sig = Linear_Regression_dim(v_son, sic_idx, 0)

	v_reg_xr = xr.DataArray(v_reg,coords=[("lat",ulat.values),("lon",ulon.values)])
	#v_sig_xr = xr.DataArray(v_sig,coords=[("lat",ulat.values),("lon",ulon.values)])
	
	# plot var
	
	plt.close

	fig, ax = draw_PlateCarree(10,70,70,140)

	levels = np.arange(-10,10+1,1)
   
	im = ax.contourf(lon, lat, prec_reg_xr, levels=levels, cmap='RdYlGn', extend='both', transform=projection)
	cb = plt.colorbar(im, orientation='horizontal', ticks=np.arange(-10,10+2,2), shrink=0.8)
	cb.ax.tick_params(labelsize=18)

	ax.add_feature(statesFeat, linewidth=1.0, edgecolor='k')

	shp2clip(im, ax, shpfn, [x for x in range(0,930)])

   # plot significant regions
	sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1],hatches=['..'], colors="none", zorder=1, transform=projection)

	u_sig = np.where(np.logical_or(u_sig<=0.1, v_sig<=0.1), u_reg, np.nan)
	v_sig = np.where(np.logical_or(u_sig<=0.1, v_sig<=0.1), v_reg, np.nan)

	u_not_sig = np.where(np.logical_and(u_sig>0.1, v_sig>0.1), u_reg, np.nan)
	v_not_sig = np.where(np.logical_and(u_sig>0.1, v_sig>0.1), v_reg, np.nan)

	u_sig_xr = xr.DataArray(u_sig,coords=[("lat",ulat.values),("lon",ulon.values)])
	v_sig_xr = xr.DataArray(v_sig,coords=[("lat",ulat.values),("lon",ulon.values)])

	u_not_sig_xr = xr.DataArray(u_not_sig,coords=[("lat",ulat.values),("lon",ulon.values)])
	v_not_sig_xr = xr.DataArray(v_not_sig,coords=[("lat",ulat.values),("lon",ulon.values)])

	fontproperties = {"size":14}
	uvflux_not_sig = ax.quiver(ulon[::2], ulat[::2], u_reg_xr[::2,::2], v_reg_xr[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0028, scale=5.0, headwidth=4, color="gray")
	uvflux_sig = ax.quiver(ulon[::2], ulat[::2], u_sig_xr[::2,::2], v_sig_xr[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0028, scale=5.0, headwidth=4, color="k")
	
	uvflux_sig_key = ax.quiverkey(uvflux_sig, 0.95, -0.18, 0.5, "0.5", color="black", fontproperties=fontproperties)

	fig.show()
	fig.savefig( "%s.png" % myseason, dpi=1000)
