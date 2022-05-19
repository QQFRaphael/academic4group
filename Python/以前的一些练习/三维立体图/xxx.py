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
file2 = netCDF4.Dataset('test4.nc')

lat  = file.variables['lat'][:47]
lon  = file.variables['lon'][:]

hgt  = file.variables['hgt'][:]

pressfc = hgt[0,:47,:]
pressfc = 1013.25*(1-pressfc*0.0065/288.15)**5.25145

sss = file2.variables['hgt_anom'][:]
ss2 = sss[:36,:]
slat = file2.variables['lat'][:36]
slon = file2.variables['lon'][:]

nx = lon.size
ny = lat.size

xlon,ylat=np.meshgrid(lon,lat)
sxlon,sylat=np.meshgrid(slon,slat)


plt.close(fig='all')

print('got here')

nframe=30
iframe=0
while iframe<=nframe:
    plt.figure(iframe,figsize=plt.figaspect(0.5))

    pressfc_smooth=gaussian_filter(pressfc,sigma=1)
    ax=plt.gca(projection='3d')

    surf=ax.plot_surface(sxlon,sylat,ss2*2+200,cmap="coolwarm_r",alpha=1,
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)

    ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
                       rstride=1,cstride=1,
                       linewidth=0, antialiased=False)

    ax.set_zlim(1000,100)
    ax.set_xlim(0,360)
    ax.set_ylim(0,90)
    ax.view_init(elev=90 - iframe*90/nframe,azim=-90)

    #plt.title('2PVU Dynamic Tropopause over topography\n'+myhour+'Z '+fdate)
    plt.colorbar(surf)

    plt.savefig('aa/goo'+ '{:04d}'.format(iframe)+'.png', bbox_inches='tight',
                    dpi=300)

    iframe=iframe+1

#pressfc_smooth=gaussian_filter(pressfc,sigma=1)
#
#states = NaturalEarthFeature(category='cultural', 
#    scale='50m', facecolor='none', 
#    name='admin_1_states_provinces_shp')
#
#fig = plt.figure(0,figsize=plt.figaspect(0.3))
#
#ax=plt.gca(projection='3d')
#
##surf=ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
##                       rstride=1,cstride=1,
##                       linewidth=0, antialiased=False)
#
#surf=ax.plot_surface(sxlon,sylat,ss2*2+200,cmap="coolwarm",alpha=1,
#                       rstride=1,cstride=1,
#                       linewidth=0, antialiased=False)
#
#ax.plot_surface(xlon,ylat,pressfc_smooth,color="lightgray",
#                       rstride=1,cstride=1,
#                       linewidth=0, antialiased=False)
#
#ax.set_zlim(1000,100)
#ax.set_xlim(0,360)
#ax.set_ylim(0,90)
#ax.view_init(elev=90- 0.6*90,azim=-90)
#plt.colorbar(surf)
#plt.savefig('test.png', bbox_inches='tight',dpi=300)
