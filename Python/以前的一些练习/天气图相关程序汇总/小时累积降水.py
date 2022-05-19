# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset

files01=np.loadtxt("/Users/QQF/Downloads/pre_strong/r1_huanan_2014052204_new.txt",dtype=np.str)
files02=np.loadtxt("/Users/QQF/Downloads/pre_strong/r1_huanan_2014052205_new.txt",dtype=np.str)
files03=np.loadtxt("/Users/QQF/Downloads/pre_strong/r1_huanan_2014052206_new.txt",dtype=np.str)
files04=np.loadtxt("/Users/QQF/Downloads/pre_strong/r1_huanan_2014052207_new.txt",dtype=np.str)

station01=[int(x) for x in files01[:,0] if x]
latitude01=np.array([float(x) for x in files01[:,1] if x])
longitude01=np.array([float(x) for x in files01[:,2] if x])
height01=[float(x) for x in files01[:,3] if x]
pre01=np.array([float(x) for x in files01[:,4] if x])
ind_pre01_missing=np.where(pre01==999999.0)
pre01[ind_pre01_missing]=0.0
print "01"

station02=[int(x) for x in files02[:,0] if x]
latitude02=[float(x) for x in files02[:,1] if x]
longitude02=[float(x) for x in files02[:,2] if x]
height02=[float(x) for x in files02[:,3] if x]
pre02=np.array([float(x) for x in files02[:,4] if x])
ind_pre02_missing=np.where(pre02==999999.0)
pre02[ind_pre02_missing]=0.0
print "02"

station03=[int(x) for x in files01[:,0] if x]
latitude03=[float(x) for x in files01[:,1] if x]
longitude03=[float(x) for x in files01[:,2] if x]
height03=[float(x) for x in files01[:,3] if x]
pre03=np.array([float(x) for x in files01[:,4] if x])
ind_pre03_missing=np.where(pre03==999999.0)
pre03[ind_pre03_missing]=0.0
print "03"

station04=[int(x) for x in files04[:,0] if x]
latitude04=[float(x) for x in files04[:,1] if x]
longitude04=[float(x) for x in files04[:,2] if x]
height04=[float(x) for x in files04[:,3] if x]
pre04=np.array([float(x) for x in files04[:,4] if x])
ind_pre04_missing=np.where(pre04==999999.0)
pre04[ind_pre04_missing]=0.0
print "04"

for ii in range(len(station01)):
    for jj in range(len(station02)):
        if station01[ii]==station02[jj]:
            pre01[ii]=pre01[ii]+pre02[jj]
    for jj in range(len(station03)):
        if station01[ii]==station03[jj]:
            pre01[ii]=pre01[ii]+pre03[jj]
    for jj in range(len(station04)):
        if station01[ii]==station04[jj]:
            pre01[ii]=pre01[ii]+pre04[jj]

ind_pre=np.where(10.0<=pre01)
pre=pre01[ind_pre] 
lat=latitude01[ind_pre] 
lon=longitude01[ind_pre] 
            
print "aaaaaa"
        
topofile=Dataset('/Users/QQF/Downloads/topo.nc')
topo=topofile.variables['z'][:]/9.8
longitude=topofile.variables['longitude'][:]
latitude=topofile.variables['latitude'][:]
lons,lats = np.meshgrid(longitude,latitude)


m = Basemap(projection='mill',llcrnrlat=22,urcrnrlat=25,\
            llcrnrlon=111,urcrnrlon=116,lat_ts=23.5,resolution='h')
xx,yy=m(lons,lats)
x,y=m(lon,lat)

print "ssssss"

m.drawcoastlines(linewidth=0.5)
m.drawparallels(np.arange(22,25,1),labels=[1,0,0,0])
m.drawmeridians(np.arange(111,116,1),labels=[0,0,0,1])

cs = m.contourf(xx,yy,topo[0,:,:],cmap='binary')
cb = m.colorbar(cs,"right", size="5%", pad='2%')
cb.set_label('Topography: m')
m.scatter(x,y,pre,marker='o',c='green')
plt.title("0400UTC-1600UTC 22 May 2014 precipitation (>10mm plotted)")

plt.savefig("/Users/QQF/Downloads/tmp.png",dpi=600)


