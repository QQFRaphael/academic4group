# -*- coding: utf-8 -*-
"""
Created on Tue Mar 31 19:10:03 2015

@author: qqf
"""

import numpy as np
import Scientific.IO.NetCDF as S
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from scipy import stats

f=S.NetCDFFile('gpcp.precip.mon.mean.nc',mode='r') 
precip=f.variables['precip'].getValue()
time=f.variables['time'].getValue()
lon=f.variables['lon'].getValue()
lat=f.variables['lat'].getValue()
f.close()

f=np.loadtxt("ersst3b.nino.mth.81-10.ascii",dtype=np.str)
Nino=f[1:,8].astype(np.float)

precip_12=precip[11:431:12,:,:]*31.0
precip_01=precip[12::12,:,:]*31.0
precip_02=precip[13::12,:,:]*28.0

tmp=(precip_12+precip_01+precip_02)/3.0
precip_djf_ave=tmp.mean(axis=0)
precip_djf_anomaly=tmp-precip_djf_ave

Nino_12=Nino[361:781:12]
Nino_01=Nino[362:781:12]
Nino_02=Nino[363:781:12]

tmp=(Nino_12+Nino_01+Nino_02)/3.0
Nino_djf_ave=tmp.mean(axis=0)
Nino_djf_anomaly=tmp-Nino_djf_ave

slope=np.empty(precip_djf_anomaly[0,:,:].shape)
intercept=np.empty(precip_djf_anomaly[0,:,:].shape)
r_value=np.empty(precip_djf_anomaly[0,:,:].shape)
p_value=np.empty(precip_djf_anomaly[0,:,:].shape)
std=np.empty(precip_djf_anomaly[0,:,:].shape)

for yy in range(len(slope[:,0])):
    for xx in range(len(slope[0,:])):
        slope[yy,xx],intercept[yy,xx],r_value[yy,xx],p_value[yy,xx],std[yy,xx]=stats.linregress(Nino_djf_anomaly,precip_djf_anomaly[:,yy,xx])
            
pre_1997=slope*Nino_djf_anomaly[1997-1979]+intercept
pre_1998=slope*Nino_djf_anomaly[1998-1979]+intercept

m=Basemap(llcrnrlon=0,llcrnrlat=-90,urcrnrlon=360,urcrnrlat=90,projection='mill')
lons,lats=np.meshgrid(lon, lat)
x,y=m(lons,lats)

fig1 = plt.figure(figsize=(16,20))
ax = fig1.add_axes([0.1,0.1,0.8,0.8])
clevs = np.linspace(-240,240,21)
CS1 = m.contour(x,y,pre_1997,clevs,linewidths=0.5,colors='k')
CS2 = m.contourf(x,y,pre_1997,clevs,cmap=plt.cm.RdBu_r)
m.drawmapboundary(fill_color='#99ffff')
m.drawcoastlines(linewidth=1.5)
m.drawparallels(np.arange(-90,90,20),labels=[1,1,0,0])
m.drawmeridians(np.arange(0.,360.,20.),labels=[0,0,0,1])
cbar = m.colorbar(CS2,location='bottom',pad="5%")
cbar.set_label('mm')
plt.title('Regression Precipitation Anomaly in 1997')
plt.savefig("./1997.png",dpi=500)

fig2 = plt.figure(figsize=(16,20))
ax = fig2.add_axes([0.1,0.1,0.8,0.8])
clevs = np.linspace(-240,240,21)
CS1 = m.contour(x,y,pre_1998,clevs,linewidths=0.5,colors='k')
CS2 = m.contourf(x,y,pre_1998,clevs,cmap=plt.cm.RdBu_r)
m.drawmapboundary(fill_color='#99ffff')
m.drawcoastlines(linewidth=1.5)
m.drawparallels(np.arange(-90,90,20),labels=[1,1,0,0])
m.drawmeridians(np.arange(0.,360.,20.),labels=[0,0,0,1])
cbar = m.colorbar(CS2,location='bottom',pad="5%")
cbar.set_label('mm')
plt.title('Regression Precipitation Anomaly in 1998')
plt.savefig("./1998.png",dpi=500)

pre_1997_test=np.ma.array(np.empty(precip_djf_anomaly[0,:,:].shape),mask=False)
pre_1998_test=np.ma.array(np.empty(precip_djf_anomaly[0,:,:].shape),mask=False)
for yy in range(len(slope[:,0])):
    for xx in range(len(slope[0,:])):
        pre_1997_test[yy,xx]=pre_1997[yy,xx]
        pre_1998_test[yy,xx]=pre_1998[yy,xx]
        if (p_value[yy,xx]>0.05): pre_1997_test.mask[yy,xx] = True
        if (p_value[yy,xx]>0.05): pre_1998_test.mask[yy,xx] = True

fig3 = plt.figure(figsize=(16,20))
ax = fig3.add_axes([0.1,0.1,0.8,0.8])
clevs = np.linspace(-240,240,21)
CS1 = m.contour(x,y,pre_1997_test,clevs,linewidths=0.5,colors='k')
CS2 = m.contourf(x,y,pre_1997_test,clevs,cmap=plt.cm.RdBu_r)
m.drawmapboundary(fill_color='#99ffff')
m.drawcoastlines(linewidth=1.5)
m.drawparallels(np.arange(-90,90,20),labels=[1,1,0,0])
m.drawmeridians(np.arange(0.,360.,20.),labels=[0,0,0,1])
cbar = m.colorbar(CS2,location='bottom',pad="5%")
cbar.set_label('mm')
plt.title('Regression Precipitation Anomaly in 1997 with significance test')
plt.savefig("./mask1997.png",dpi=500)

fig4 = plt.figure(figsize=(16,20))
ax = fig4.add_axes([0.1,0.1,0.8,0.8])
clevs = np.linspace(-240,240,21)
CS1 = m.contour(x,y,pre_1998_test,clevs,linewidths=0.5,colors='k')
CS2 = m.contourf(x,y,pre_1998_test,clevs,cmap=plt.cm.RdBu_r)
m.drawmapboundary(fill_color='#99ffff')
m.drawcoastlines(linewidth=1.5)
m.drawparallels(np.arange(-90,90,20),labels=[1,1,0,0])
m.drawmeridians(np.arange(0.,360.,20.),labels=[0,0,0,1])
cbar = m.colorbar(CS2,location='bottom',pad="5%")
cbar.set_label('mm')
plt.title('Regression Precipitation Anomaly in 1998 with significance test')
plt.savefig("./mask1998.png",dpi=500)