# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap, shiftgrid
from netCDF4 import Dataset
import datetime 

surface_file=Dataset('/Users/QQF/Downloads/surface.nc')

u10=surface_file.variables['u10'][:]
v10=surface_file.variables['v10'][:]
sp=0.01*surface_file.variables['sp'][:]
t2m=surface_file.variables['t2m'][:]-273.15
longitude=surface_file.variables['longitude'][:]
latitude=surface_file.variables['latitude'][:]
dstart = datetime.datetime(1900, 1, 1)
del_t=surface_file.variables['time'][:]

nlats=len(latitude)
nlons=len(longitude)
ntimes=len(del_t)

m = Basemap(projection='mill',llcrnrlat=15,urcrnrlat=35,\
            llcrnrlon=100,urcrnrlon=130,lat_ts=25,resolution='l')
lons,lats = np.meshgrid(longitude,latitude)
x,y=m(lons,lats)


for ii in range(ntimes):
    cs = m.contour(x,y,sp[ii,:,:],colors='b',linewidths=1.5)
    cs1 = m.contour(x,y,t2m[ii,:,:],colors='r',linewidths=1.5)
    plt.clabel(cs, fontsize=10,fmt='%1d')
    plt.clabel(cs1, fontsize=10,fmt='%1d')
    ugrid,newlons = shiftgrid(180.,u10,longitude,start=False)
    vgrid,newlons = shiftgrid(180.,v10,longitude,start=False)
    uproj,vproj,xx,yy = \
    m.transform_vector(ugrid[ii,::-1,:],vgrid[ii,::-1,:],newlons,latitude[::-1],31,31,returnxy=True,masked=True)
    Q = m.quiver(xx,yy,uproj,vproj,units='inches')
    qk = plt.quiverkey(Q, 0, -0.1, 5, '5 m/s', labelpos='S')
    m.drawcoastlines(linewidth=0.5)
    m.drawparallels(np.arange(-90,90,5),labels=[1,0,0,0])
    m.drawmeridians(np.arange(0,360,5),labels=[0,0,0,1])
    dend = dstart + datetime.timedelta(hours=float(del_t[ii]))
    plt.title(np.str(dend))
    plt.savefig("/Users/QQF/Downloads/"+np.str(dend)+".png",dpi=600)
    plt.close('all')
