import cmaps as cmps
import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeat
import pandas as pd

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
from composite import composite
from draw_PlateCarree import draw_PlateCarree
from tibet_shp_load import tibet_shp_load

ds_dswrf = xr.open_dataset('../data/dswrf.ntat.mon.mean.nc')
ds_prate = xr.open_dataset('../data/prate.sfc.mon.mean.nc')
ds_shtfl = xr.open_dataset('../data/shtfl.sfc.mon.mean.nc')
ds_ulwrf = xr.open_dataset('../data/ulwrf.ntat.mon.mean.nc')
ds_uswrf = xr.open_dataset('../data/uswrf.ntat.mon.mean.nc')
ds_nswrs = xr.open_dataset('../data/nswrs.sfc.mon.mean.nc')
ds_nlwrs = xr.open_dataset('../data/nlwrs.sfc.mon.mean.nc')

year_start = 1980
year_end = 2020

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

q1_jja = Month_to_Season(q1, "JJA", "ave", 1980, 2020)

years_low = [1980,1982,1985,1986,1987,1990,1992,1993,1994,2003]
years_high = [2006,2008,2010,2011,2012,2014,2015,2016,2017,2018,2019]
diff, tval = composite(q1_jja, years_low, years_high)

diff = xr.DataArray(diff,coords=[("lat",lat.values),("lon",lon.values)])
tval = xr.DataArray(tval,coords=[("lat",lat.values),("lon",lon.values)])



rgb = pd.read_csv('../BlueDarkRed18.rgb',sep='\s+',skiprows=2,names=['r','g','b']).values/255

colormap = ListedColormap(rgb)
print(colormap)

# plot var

tibet_shp = tibet_shp_load("../utils/tibet_shape")

plt.close

projection = ccrs.PlateCarree()

fig, ax = draw_PlateCarree(24,50,60,105)
levels = np.arange(-60,60+10,10)
  
im = ax.contourf(lon, lat, diff, levels=levels, cmap='RdBu_r', extend='both', transform=projection)
cb = plt.colorbar(im, orientation='horizontal', ticks=levels, shrink=0.8)
cb.ax.tick_params(labelsize=18)
  # plot significant regions
sig1 = ax.contourf(lon, lat, tval, [2.093,np.max(tval)],hatches=['..'], colors="none", zorder=1, transform=projection)
pgon = Polygon(tibet_shp)
ax.add_geometries([pgon], crs=projection, facecolor="None", edgecolor='k', linewidth=1.0)
fig.show()
fig.savefig( "com.png", dpi=1000)














