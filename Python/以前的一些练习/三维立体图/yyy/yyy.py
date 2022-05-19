import numpy as np
import netCDF4
import matplotlib.pyplot as plt
import matplotlib.ticker as tick
from mpl_toolkits.mplot3d import axes3d
import cartopy.crs as ccrs
from scipy.ndimage import gaussian_filter
from cartopy.feature import NaturalEarthFeature
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER
from cartopy.mpl.ticker import LatitudeFormatter, LongitudeFormatter

from datetime import datetime

file = netCDF4.Dataset('hgt.sfc.gauss.nc')
file2 = netCDF4.Dataset('SON.nc')
file3 = netCDF4.Dataset('OND.nc')
file4 = netCDF4.Dataset('NDJ.nc')
file5 = netCDF4.Dataset('DJF.nc')

lat  = file.variables['lat'][:47]
lon  = file.variables['lon'][:]

hgt  = file.variables['hgt'][:]

pressfc = hgt[0,:47,:]
pressfc = 1013.25*(1-pressfc*0.0065/288.15)**5.25145

slat = file2.variables['lat'][:36]
slon = file2.variables['lon'][:]

htmp = file2.variables['hgt_anom'][:]
h1 = htmp[:36,:]

htmp = file3.variables['hgt_anom'][:]
h2 = htmp[:36,:]

htmp = file4.variables['hgt_anom'][:]
h3 = htmp[:36,:]

htmp = file5.variables['hgt_anom'][:]
h4 = htmp[:36,:]

nx = lon.size
ny = lat.size

xlon,ylat=np.meshgrid(lon,lat)
sxlon,sylat=np.meshgrid(slon,slat)


pressfc_smooth=gaussian_filter(pressfc,sigma=1)

states = NaturalEarthFeature(category='cultural', 
    scale='50m', facecolor='none', 
    name='admin_1_states_provinces_shp')

idx = 0
scale = 5
colormap = "coolwarm_r"

fig = plt.figure(idx,figsize=plt.figaspect(0.3))
ax=plt.gca(projection='3d')
surf=ax.plot_surface(sxlon,sylat,h1*scale+200,cmap=colormap,alpha=1,
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
plt.title('SON')
ax.set_zlim(1000,100)
ax.set_xlim(0,360)
ax.set_ylim(0,90)
ax.view_init(elev=90- 0.6*90,azim=-90)
plt.colorbar(surf)
plt.savefig('test%s.png' % str(idx), bbox_inches='tight',dpi=300)

idx = 1

fig = plt.figure(idx,figsize=plt.figaspect(0.3))
ax=plt.gca(projection='3d')
surf=ax.plot_surface(sxlon,sylat,h2*scale+200,cmap=colormap,alpha=1,
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
plt.title('OND')
ax.set_zlim(1000,100)
ax.set_xlim(0,360)
ax.set_ylim(0,90)
ax.view_init(elev=90- 0.6*90,azim=-90)
plt.colorbar(surf)
plt.savefig('test%s.png' % str(idx), bbox_inches='tight',dpi=300)

idx = 2

fig = plt.figure(idx,figsize=plt.figaspect(0.3))
ax=plt.gca(projection='3d')
surf=ax.plot_surface(sxlon,sylat,h3*scale+200,cmap=colormap,alpha=1,
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
plt.title('NDJ')
ax.set_zlim(1000,100)
ax.set_xlim(0,360)
ax.set_ylim(0,90)
ax.view_init(elev=90- 0.6*90,azim=-90)
plt.colorbar(surf)
plt.savefig('test%s.png' % str(idx), bbox_inches='tight',dpi=300)

idx = 3

fig = plt.figure(idx,figsize=plt.figaspect(0.3))
ax=plt.gca(projection='3d')
surf=ax.plot_surface(sxlon,sylat,h4*scale+200,cmap=colormap,alpha=1,
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)
plt.title('DJF')
ax.set_zlim(1000,100)
ax.set_xlim(0,360)
ax.set_ylim(0,90)
ax.view_init(elev=90- 0.6*90,azim=-90)
plt.colorbar(surf)
plt.savefig('test%s.png' % str(idx), bbox_inches='tight',dpi=300)