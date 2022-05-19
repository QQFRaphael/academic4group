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

pressure_file=Dataset('/Users/QQF/Downloads/pressurelevel.nc')
total_column_file=Dataset('/Users/QQF/Downloads/total_column_water.nc')

level=pressure_file.variables['level'][:]
lev_ind=np.where(level==500)[0]

dstart = datetime.datetime(1900, 1, 1)

hgt=pressure_file.variables['z'][:,lev_ind,:,:]/9.8/10.0
t=pressure_file.variables['t'][:,lev_ind,:,:]-273.15
u=pressure_file.variables['u'][:,lev_ind,:,:]
v=pressure_file.variables['v'][:,lev_ind,:,:]

longitude=pressure_file.variables['longitude'][:]
latitude=pressure_file.variables['latitude'][:]
del_t=pressure_file.variables['time'][:]
tcw=total_column_file.variables['tcw'][:]

ntimes=len(del_t)

m = Basemap(projection='mill',llcrnrlat=15,urcrnrlat=35,\
            llcrnrlon=100,urcrnrlon=130,lat_ts=25,resolution='l')
lons,lats = np.meshgrid(longitude,latitude)
x,y=m(lons,lats)


for ii in range(ntimes):
    cs = m.contour(x,y,hgt[ii,0,:,:],colors='b',linewidths=1.5)
    cs1 = m.contour(x,y,t[ii,0,:,:],colors='r',linestyle='dash',linewidths=1.5)
    cs2=m.contourf(x,y,tcw[ii,:,:],cmap=plt.cm.GnBu)
    cb = m.colorbar(cs2,"right", size="5%", pad='2%')
    cb.set_label('Total column water: $kg/m^2$')
    plt.clabel(cs, fontsize=10,fmt='%1d')
    plt.clabel(cs1, fontsize=10,fmt='%1d')
    ugrid,newlons = shiftgrid(180.,u,longitude,start=False)
    vgrid,newlons = shiftgrid(180.,v,longitude,start=False)
    uproj,vproj,xx,yy = \
    m.transform_vector(ugrid[ii,0,::-1,:],vgrid[ii,0,::-1,:],newlons,latitude[::-1],31,31,returnxy=True,masked=True)
    Q = m.quiver(xx,yy,uproj,vproj,units='inches')
    qk = plt.quiverkey(Q, 0, -0.1, 5, '5 m/s', labelpos='S')
    m.drawcoastlines(linewidth=0.5)
    m.drawparallels(np.arange(-90,90,5),labels=[1,0,0,0])
    m.drawmeridians(np.arange(0,360,5),labels=[0,0,0,1])
    dend = dstart + datetime.timedelta(hours=float(del_t[ii]))
    plt.title(np.str(dend))
    plt.savefig("/Users/QQF/Downloads/"+np.str(dend)+".png",dpi=600)
    plt.close('all')
