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
sys.path.append("./utils/")

from mon2season import Month_to_Season
from lonFlip import lonFlip_EW, lonFlip_360
from composite import composite
from draw_PlateCarree import draw_PlateCarree
from tnflux import tnflux

year_start = 1967
year_end = 2019

dsu = xr.open_dataset('uwnd.mon.mean.nc')
dsv = xr.open_dataset('vwnd.mon.mean.nc')
dsz = xr.open_dataset('hgt.mon.mean.nc')

#dsu = lonFlip_EW(dsu)
#dsv = lonFlip_EW(dsv)

lat = dsu['lat']
lon = dsu['lon']

uwnd = dsu['uwnd'].loc[:,200,:,:]
vwnd = dsv['vwnd'].loc[:,200,:,:]
hgt = dsz['hgt'].loc[:,200,:,:]

uwnd_son = Month_to_Season(uwnd, "SON", "ave", year_start, year_end)
vwnd_son = Month_to_Season(vwnd, "SON", "ave", year_start, year_end)

u_c = uwnd_son.mean(dim="time")
v_c = vwnd_son.mean(dim="time")

years_low = [1967,1968,1970,1972,1973,1976,1977,1979,1986,1990,1996,2006,2009,2010,2014]
years_high = [1971,1998,1999,2005,2008,2011,2017]

for myseason in ["SON","OND","NDJ","DJF"]:
  hgt_son = Month_to_Season(hgt, myseason, "ave", year_start, year_end)
  uwnd_son = Month_to_Season(uwnd, myseason, "ave", year_start, year_end)
  vwnd_son = Month_to_Season(vwnd, myseason, "ave", year_start, year_end)

  diff, tval = composite(hgt_son, years_low, years_high)

  diff = xr.DataArray(diff,coords=[("lat",lat.values),("lon",lon.values)])
  tval = xr.DataArray(tval,coords=[("lat",lat.values),("lon",lon.values)])

  Fx, Fy = tnflux(u_c, v_c, diff, 200.0, lat, lon, 0.1)
  
  Fx.loc[11:,:] = np.nan
  Fy.loc[11:,:] = np.nan

  diff, lon1 = add_cyclic_point(diff, coord=lon)
  tval, lon2 = add_cyclic_point(tval, coord=lon)
  
  Fx, lonFx = add_cyclic_point(Fx, coord=lon)
  Fy, lonFy = add_cyclic_point(Fy, coord=lon)

  plt.close

  fig = plt.figure(figsize=(12,7)) 

  proj = ccrs.PlateCarree(central_longitude = 180)

  ax = fig.subplots(1, 1, subplot_kw={'projection':proj})

  ax.add_feature(cfeat.COASTLINE.with_scale('50m'), linewidth=0.6, zorder=1) 

  ax.set_extent([60, 340, 0, 90], crs=ccrs.PlateCarree()) 

  gl = ax.gridlines(crs=ccrs.PlateCarree(), draw_labels=True, linewidth=1.2, color='gray', alpha=0.5, linestyle='--')
  gl.top_labels = False  
  gl.right_labels = False  
  gl.xlabel_style={'size':18}
  gl.ylabel_style={'size':18}

  levels = np.arange(-100,100+10,10)
   
  im = ax.contourf(lon1, lat, diff, levels=levels, cmap=cmps.BlueWhiteOrangeRed, transform=ccrs.PlateCarree(), extend="both")
  
  cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::4], shrink=0.8)
  cb.ax.tick_params(labelsize=18)
  
  # plot significant regions
  sig1 = ax.contourf(lon2, lat, tval, [2.086,np.max(tval)], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())
  
  fontproperties = {"size":14}
  waf = ax.quiver(lonFx[::2], lat[::2], Fx[::2,::2], Fy[::2,::2], transform=ccrs.PlateCarree(), pivot='mid', width=0.0018, scale=70.0, headwidth=4)
  waf_key = ax.quiverkey(waf, 0.85, -0.18, 2.0, "2.0", color="black", fontproperties=fontproperties)

  fig.show()
  fig.savefig("%s.png" % myseason, dpi=1000)
  
  print("%s" % myseason)









