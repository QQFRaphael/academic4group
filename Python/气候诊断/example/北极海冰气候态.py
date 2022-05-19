import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeat
import matplotlib.path as mpath
from cartopy.util import add_cyclic_point
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER

ds = xr.open_dataset('../data/HadISST_ice.nc')

year_start = 1979
year_end = 2019
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
SON = np.where(SON<0.05, np.nan, SON)
var_son = xr.DataArray(SON, coords=[("time",var_sep['time'].values),("lat",lat.values),("lon",lon.values)])

var_son_ave = var_son.mean(dim='time')
var_son_std = var_son.std(dim='time')

var_son_ave, lon1 = add_cyclic_point(var_son_ave, coord=lon)
var_son_std, lon2 = add_cyclic_point(var_son_std, coord=lon)

# plot var

projection = ccrs.NorthPolarStereo()

plt.close

fig = plt.figure(figsize=(8,8))

ax = plt.axes([0.05,0.05,0.9,0.9], projection=projection) 

# draw a circle as the bourder of the picture
theta = np.linspace(0, 2*np.pi, 100)
center, radius = [0.5, 0.5], 0.5
verts = np.vstack([np.sin(theta), np.cos(theta)]).T
circle = mpath.Path(verts * radius + center)

ax.coastlines()
ax.gridlines(crs=ccrs.PlateCarree(), xlocs=np.linspace(-180,180,13), ylocs=np.linspace(60,90,5), draw_labels=False, linewidth=1.2, color='gray', alpha=0.5, linestyle='--')
ax.set_extent([-180,180,60,90], crs=ccrs.PlateCarree())
ax.set_boundary(circle, transform=ax.transAxes) 
cbar_kwargs = {'shrink':0.8}

lond = np.linspace(-180, 180, 13)
latd = np.zeros(len(lond))+59

va = 'center' # also bottom, top
ha = 'center' # right, left
degree_symbol=u'\u00B0'

for (alon, alat) in zip(lond, latd):
    projx1, projy1 = ax.projection.transform_point(alon, alat, ccrs.Geodetic())
    if alon>0 and alon<180:
        ha = 'left'
        va = 'center'
        txt =  ' {0} '.format(str(int(alon)))+degree_symbol+'E'
    if alon>-180 and alon<0:
        ha = 'right'
        va = 'center'
        alon = np.abs(alon)
        txt =  ' {0} '.format(str(int(alon)))+degree_symbol+'W'
    if np.abs(alon+180)<0.01:
        ha = 'center'
        va = 'bottom'
        txt =  ' {0} '.format(str(int(np.abs(alon))))+degree_symbol
    if alon==0.:
        ha = 'center'
        va = 'top'
        txt =  ' {0} '.format(str(int(alon)))+degree_symbol
    if (alon<180.):
        ax.text(projx1, projy1, txt, va=va, ha=ha, color='k', fontsize=18)


levels = np.linspace(0,1,21)

#im = var_son_ave.loc[90:59,:].plot.contourf(ax=ax, levels=levels, cmap='RdBu_r', add_colorbar=False, transform=ccrs.PlateCarree())
im = ax.contourf(lon1, lat, var_son_ave, levels=levels, cmap='RdBu_r', transform=ccrs.PlateCarree(), extend="both")
cb = plt.colorbar(im, orientation='horizontal', ticks=levels[::4], shrink=0.8)
cb.ax.tick_params(labelsize=18)

#ct = var_son_std.loc[90:59,:].plot.contour(ax=ax, levels=[0.1,0.2,0.4,0.6],colors='k',transform=ccrs.PlateCarree())
ct = ax.contour(lon2, lat, var_son_std, levels=[0.1,0.2,0.4,0.6],colors='k',transform=ccrs.PlateCarree())
ax.clabel(ct, ct.levels, inline=True, fmt="%.2f", fontsize=10)

#x, y = np.arange(120,180), np.array([71]*60)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())
#
#x, y = np.linspace(-180,-135,60), np.array([71]*60)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())
#
#x, y = np.linspace(-180,-135,60), np.array([80]*60)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())
#
#x, y = np.arange(120,180), np.array([80]*60)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())
#
#x, y = np.array([120]*9), np.linspace(71,80,9)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())
#
#x, y = np.array([-135]*9), np.linspace(71,80,9)
#ax.plot(x, y, marker=',', c='b', transform=ccrs.PlateCarree())

fig.show()
fig.savefig("SIC-clim.png",dpi=1000)
