import numpy as np
import xarray as xr

import sys
sys.path.append("../utils/")

from conform_dim import conform_dim
from fourier_filter_high_pass import fourier_filter_high_pass

ds = xr.open_dataset('../data/HadISST_ice.nc')

year_start = 1979
year_end = 2020
year = range(year_start, year_end)
nyears = year_end - year_start + 1

var = ds['sic']
lat = ds['latitude']
lon = ds['longitude']

var_sep = var.sel(time=var.time.dt.month.isin(9)&var.time.dt.year.isin([x for x in range(year_start,year_end)])) 
var_oct = var.sel(time=var.time.dt.month.isin(10)&var.time.dt.year.isin([x for x in range(year_start,year_end)])) 
var_nov = var.sel(time=var.time.dt.month.isin(11)&var.time.dt.year.isin([x for x in range(year_start,year_end)])) 

# SON
SON = (var_sep.values+var_oct.values+var_nov.values) / 3.0
var_son = xr.DataArray(SON, coords=[("time",var_sep['time'].values),("lat",lat.values),("lon",lon.values)])

var_son.coords['lon'] = (var_son.coords['lon'] + 360) % 360 
var_son = var_son.sortby(var_son.lon)

var_son = var_son * conform_dim(np.cos(lat.values*np.pi/180.0),var_son,(0,2))

target = var_son.loc[:,80:71,120:225].mean(dim="lon").mean(dim="lat")

ts = target.values

ts = fourier_filter_high_pass(ts, 11)

np.savetxt("idx-filter.txt",ts)
