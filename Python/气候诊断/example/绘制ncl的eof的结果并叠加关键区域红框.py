import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
from numpy.fft import rfftn, irfftn
from cartopy.util import add_cyclic_point
from eofs.xarray import Eof

import sys
sys.path.append("../utils/")

from mon2season import Month_to_Season
from conform_dim import conform_dim
from draw_polar_steoro import draw_north_polar_steoro
from Linear_Regression_dim import Linear_Regression_dim


ds = xr.open_dataset('eof-pre-djf.nc')

year_start = 1979
year_end = 2020

var = ds['eof1']
lat = ds['lat']
lon = ds['lon']

reg_sig = ds['tval1']


# plot var

plt.close

var_reg, lon1 = add_cyclic_point(var, coord=lon)
#reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)

fig, ax = draw_north_polar_steoro(60)

levels = np.linspace(-0.14,0.14,29)

im = ax.contourf(lon1, lat, -var_reg, levels=levels, cmap='bwr', transform=ccrs.PlateCarree(), extend="both")

cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::4], shrink=0.8)
cb.ax.tick_params(labelsize=18)

# plot significant regions
sig1 = ax.contourf(lon, lat, np.abs(reg_sig),[2.043,np.max(reg_sig)], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())

x, y = np.arange(120,180), np.array([71]*60)
ax.plot(x, y, marker='.', c='r', markersize=5, transform=ccrs.PlateCarree())

x, y = np.linspace(-180,-135,60), np.array([71]*60)
ax.plot(x, y, marker='.', c='r', markersize=5,transform=ccrs.PlateCarree())

x, y = np.linspace(-180,-135,60), np.array([80]*60)
ax.plot(x, y, marker='.', c='r', markersize=5,transform=ccrs.PlateCarree())

x, y = np.arange(120,180), np.array([80]*60)
ax.plot(x, y, marker='.', c='r', markersize=5,transform=ccrs.PlateCarree())

x, y = np.array([120]*50), np.linspace(71,80,50)
ax.plot(x, y, marker='.', c='r', markersize=5,transform=ccrs.PlateCarree())

x, y = np.array([-135]*50), np.linspace(71,80,50)
ax.plot(x, y, marker='.', c='r', markersize=5,transform=ccrs.PlateCarree())

fig.show()
fig.savefig("SON.png", dpi=1000)
