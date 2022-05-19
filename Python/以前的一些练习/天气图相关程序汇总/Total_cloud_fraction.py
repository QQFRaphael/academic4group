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

surface_file=Dataset('/Users/QQF/Downloads/cloud_fraction.nc')

tcc=surface_file.variables['tcc'][:]*100.0

longitude=surface_file.variables['longitude'][:]
latitude=surface_file.variables['latitude'][:]
dstart = datetime.datetime(1900, 1, 1)
del_t=surface_file.variables['time'][:]

ntimes=len(del_t)

m = Basemap(projection='mill',llcrnrlat=15,urcrnrlat=30,\
            llcrnrlon=100,urcrnrlon=125,lat_ts=22.5,resolution='l')
lons,lats = np.meshgrid(longitude,latitude)
x,y=m(lons,lats)

for ii in range(ntimes):
    cs2=m.contourf(x,y,tcc[ii,:,:],cmap=plt.cm.GnBu)
    cb = m.colorbar(cs2,"right", size="3%", pad='1%')
    cb.set_label('Total cloud fraction: %')
    m.drawcoastlines(linewidth=0.5)
    m.drawparallels(np.arange(-90,90,5),labels=[1,0,0,0])
    m.drawmeridians(np.arange(0,360,5),labels=[0,0,0,1])
    dend = dstart + datetime.timedelta(hours=float(del_t[ii]))
    plt.title(np.str(dend))
    plt.savefig("/Users/QQF/Downloads/"+np.str(dend)+".png",dpi=600)
    plt.close('all')
