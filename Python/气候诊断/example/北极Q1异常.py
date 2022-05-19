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
from matplotlib.colors import ListedColormap

import sys
sys.path.append("../utils/")

from mon2season import Month_to_Season
from lonFlip import lonFlip_EW, lonFlip_360
from tibet_shp_load import tibet_shp_load
from Q1 import Q1
from draw_polar_steoro import draw_north_polar_steoro
from tibet_shp_load import tibet_shp_load
from Linear_Regression_dim import Linear_Regression_dim
from load_ncl_colormap import load_ncl_colormap


ds_dswrf = xr.open_dataset('../data/ncep1/dswrf.ntat.mon.mean.nc')
ds_prate = xr.open_dataset('../data/ncep1/prate.sfc.mon.mean.nc')
ds_shtfl = xr.open_dataset('../data/ncep1/shtfl.sfc.mon.mean.nc')
ds_ulwrf = xr.open_dataset('../data/ncep1/ulwrf.ntat.mon.mean.nc')
ds_uswrf = xr.open_dataset('../data/ncep1/uswrf.ntat.mon.mean.nc')
ds_nswrs = xr.open_dataset('../data/ncep1/nswrs.sfc.mon.mean.nc')
ds_nlwrs = xr.open_dataset('../data/ncep1/nlwrs.sfc.mon.mean.nc')

year_start = 1970
year_end = 2021

dswrf = ds_dswrf['dswrf'].sel(time=ds_dswrf['dswrf'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
prate = ds_prate['prate'].sel(time=ds_prate['prate'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
shtfl = ds_shtfl['shtfl'].sel(time=ds_shtfl['shtfl'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
ulwrf = ds_ulwrf['ulwrf'].sel(time=ds_ulwrf['ulwrf'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
uswrf = ds_uswrf['uswrf'].sel(time=ds_uswrf['uswrf'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
nswrs = ds_nswrs['nswrs'].sel(time=ds_nswrs['nswrs'].time.dt.year.isin([x for x in range(year_start,year_end)])) 
nlwrs = ds_nlwrs['nlwrs'].sel(time=ds_nlwrs['nlwrs'].time.dt.year.isin([x for x in range(year_start,year_end)])) 

lat = ds_dswrf['lat']
lon = ds_dswrf['lon']

q1, AA, BB, CC = Q1(dswrf, prate, shtfl, ulwrf, uswrf, nswrs, nlwrs)

sic_idx = np.array(np.loadtxt('../sic-idx/idx-filter.txt'))

varss = [q1, AA, BB, CC]
name = ["q1", "AA", "BB", "CC"]

projection = ccrs.NorthPolarStereo()

colormap = load_ncl_colormap("BlueDarkRed18.rgb")

for season in ["SON", "OND", "NDJ"]:
#  for var in [0, 1, 3]: 
#
#    var_son = Month_to_Season(varss[var], season, "ave", 1979, 2020)
#  
#    var_reg, reg_sig = Linear_Regression_dim(var_son, sic_idx, 0)
#    var_reg_xr = xr.DataArray(var_reg,coords=[("lat",lat.values),("lon",lon.values)])
#    reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])
#  
#  # plot var
#  
#    plt.close
#  
#    var_reg_xr, lon1 = add_cyclic_point(var_reg_xr, coord=lon)
#  #reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)
#  
#    fig, ax = draw_north_polar_steoro(60)
#  
#    levels = np.linspace(-5,5,11) #[-4,-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5] #np.linspace(-5,1,13)
#  
#    im = ax.contourf(lon1, lat, var_reg_xr, levels=levels, cmap='RdBu_r', transform=ccrs.PlateCarree(), extend="both")
#  
#    cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::2], shrink=0.8)
#    cb.ax.tick_params(labelsize=18)
#  
#  # plot significant regions
#    sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
#  
#    fig.show()
#    fig.savefig("%s-%s.png" % (name[var],season), dpi=1000)
#  
#    print("%s-%s" % (name[var], season))
  

  for var in [2]: 

    var_son = Month_to_Season(varss[var], season, "ave", 1979, 2020)
  
    var_reg, reg_sig = Linear_Regression_dim(var_son, sic_idx, 0)
    var_reg_xr = xr.DataArray(var_reg,coords=[("lat",lat.values),("lon",lon.values)])
    reg_sig_xr = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])
  
  # plot var
  
    plt.close
  
    var_reg_xr, lon1 = add_cyclic_point(var_reg_xr, coord=lon)
  #reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)
  
    fig, ax = draw_north_polar_steoro(60)
  
    levels = np.linspace(-3,3,11) #[0,0.5,1,1.5,2,2.5,3,3.5,4,4.5] #np.linspace(-5,1,13)
  
    im = ax.contourf(lon1, lat, var_reg_xr, levels=levels, cmap='RdBu_r', transform=ccrs.PlateCarree(), extend="both")
  
    cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::2], shrink=0.8)
    cb.ax.tick_params(labelsize=18)
  
  # plot significant regions
    sig1 = ax.contourf(lon, lat, reg_sig_xr, [np.min(reg_sig_xr),0.1], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
  
    fig.show()
    fig.savefig("%s-%s.png" % (name[var],season), dpi=1000)
  
    print("%s-%s" % (name[var], season))

