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


ds = xr.open_dataset('../data/HadISST_ice.nc')

year_start = 1979
year_end = 2020

neof = 3

var = ds['sic']
lat = ds['latitude']
lon = ds['longitude']

var_son = Month_to_Season(var, "SON", "ave", year_start, year_end)


#var_son = np.where(var_son<0.05, np.nan, var_son)

var_son_filter = rfftn(var_son, [np.shape(var_son)[0]], axes=[0])
var_son_filter[0:12] = 0

var_son_filter = irfftn(var_son_filter,[np.shape(var_son)[0]], axes=[0])

mu = np.mean(var_son_filter, axis=0)
sigma = np.std(var_son_filter, axis=0)

var_son_filter = (var_son_filter - conform_dim(mu,var_son_filter,[0])) / conform_dim(sigma,var_son_filter,[0])
var_son_filter = xr.DataArray(var_son_filter,coords=[("time",var_son['time'].values),("lat",lat.values),("lon",lon.values)])

var_son_target = var_son_filter.loc[:,90:60,:]

coslat = np.cos(np.deg2rad(lat.loc[90:60].values)).clip(0., 1.)
wgts = np.sqrt(coslat)[..., np.newaxis] 

solver = Eof(var_son_target, weights = wgts, center = True)
EOFs   = solver.eofsAsCovariance()
PCs    = solver.pcs(npcs = neof, pcscaling = 1)


eigenvalues = solver.eigenvalues(neigs=neof)
print("=============print eigenvalues=============")
for num, eigenvalue in enumerate(eigenvalues):
   print("The eigenvalue of PC%s is %.2f" % (num+1, eigenvalue))

variance_fractions = solver.varianceFraction(neigs=neof)
print("=============print variance fraction=============")
for num, variance_fraction in enumerate(variance_fractions):
   print("The variance_fraction of PC%s is %.2f %%" % (num+1, variance_fraction*100.0))

errors = solver.northTest(neigs=neof, vfscaled=False)
print("=============print North Sig Test=============")
for num, error in enumerate(errors):
   print("The delta lambda of PC%s is %.2f" % (num+1, error))

PC = np.array(PCs[:,0])

var_reg, reg_sig = Linear_Regression_dim(var_son, PC, 0)
var_reg = xr.DataArray(var_reg,coords=[("lat",lat.values),("lon",lon.values)])
reg_sig = xr.DataArray(reg_sig,coords=[("lat",lat.values),("lon",lon.values)])


# plot var

plt.close

var_reg, lon1 = add_cyclic_point(var_reg, coord=lon)
#reg_sig_xr, lon2 = add_cyclic_point(reg_sig_xr, coord=lon)

fig, ax = draw_north_polar_steoro(60)

levels = np.linspace(-0.14,0.14,29)

im = ax.contourf(lon1, lat, var_reg, levels=levels, cmap='bwr', transform=ccrs.PlateCarree(), extend="both")

cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::4], shrink=0.8)
cb.ax.tick_params(labelsize=18)

# plot significant regions
sig1 = ax.contourf(lon, lat, reg_sig, [np.min(reg_sig),0.1], hatches=['..'], colors="None", zorder=1, transform=ccrs.PlateCarree())

fig.show()
fig.savefig("SON.png", dpi=1000)
