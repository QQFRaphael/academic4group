# -*- coding: utf-8 -*-
"""
Created on Wed Apr 29 18:42:53 2015

@author: qqf
"""

import numpy as np
from scipy import constants as const
import Scientific.IO.NetCDF as S
import matplotlib.pyplot as plt

def mass_flux_streamfunc(wind,p,lat,lon,opt):
    if(opt==0):
        psi_m=psi_m_func(wind,lat,p)
        return psi_m
    else:
        psi_z=psi_z_func(wind,lon,p)
        return psi_z

def psi_m_func(wind,lat,p):
    a=6.37122e6
    g=9.8
    cc=2.0*const.pi*a/g
    Wind=np.array(wind)
    wind_ave_time=Wind.mean(axis=0)
    wind_ave_time_zonal=wind_ave_time.mean(axis=2)
    psi_m=np.empty(wind_ave_time_zonal.shape)
    for ii in range(psi_m.shape[0]):
        if ii==0:
            psi_m[ii,:] = psi_m[ii,:]+0.5*wind_ave_time_zonal[ii,:]*p[0]*cc*np.cos(lat[:])
        elif ii>0:
            psi_m[ii,:] = psi_m[ii-1,:]+0.5*(p[ii]-p[ii-1])*(wind_ave_time_zonal[ii,:]+wind_ave_time_zonal[ii-1,:])*cc*np.cos(lat[:])
    return psi_m/1e10
    
def psi_z_func(wind,lon,p):
    a=6.37122e6
    g=9.8
    cc=a/g
    Wind=np.array(wind)
    wind_ave_time=Wind.mean(axis=0)
    wind_ave_time_zonal=wind_ave_time.mean(axis=2)
    wind_star=np.empty(wind_ave_time.shape)
    psi_z=np.empty(wind_ave_time.shape)
    for ii in range(psi_z.shape[2]):
        wind_star[:,:,ii]=wind_ave_time[:,:,ii]-wind_ave_time_zonal
    for ii in range(psi_z.shape[0]):
        if ii==0:
            psi_z[ii,:,:]=psi_z[ii,:,:]+0.5*wind_star[0,:,:]*p[0]*cc
        elif ii>0:
            psi_z[ii,:,:]=psi_z[ii-1,:,:]+0.5*(p[ii]-p[ii-1])*(wind_star[ii,:,:]+wind_star[ii-1,:,:])*cc
    for ii in range(psi_z.shape[1]):
        psi_z[:,ii,:]=2.5*np.pi/180*psi_z[:,ii,:]
    return np.sum(psi_z[:,34:38,:],axis=1)/1e10      
    

   
f=S.NetCDFFile('./problem61.nc','r')
u=f.variables['UGRD_P8_L100_GLL0'].getValue()
v=f.variables['VGRD_P8_L100_GLL0'].getValue()
p=f.variables['lv_ISBL0'].getValue()
lat=f.variables['lat_0'].getValue()
lat=lat
lon=f.variables['lon_0'].getValue()
psi_m=mass_flux_streamfunc(v,p,lat*np.pi/180.0,lon,0)   
psi_z=mass_flux_streamfunc(u,p,lat,lon,1)   


fig = plt.figure(figsize=(14,8),dpi=200)
ax0 = fig.add_subplot(1,1,1)
clev = np.linspace(-7,7,15)
CS = plt.contourf(lat, p/100.0, psi_m, clev,cmap=plt.cm.RdYlBu_r,extend='both')
ax0.set_ylim(ax0.get_ylim()[::-1])
plt.xlabel("Latitude")
plt.ylabel("Pressure Level")
plt.title('Meridional Mass Streamfunction')
cbar = plt.colorbar(CS, orientation='horizontal',extend='both',aspect=50,shrink=0.7)
cbar.ax.set_xlabel('unit:$10^{10}$ kg/s')
plt.savefig('meridional.png',dpi=500)
plt.show()

fig = plt.figure(figsize=(14,8),dpi=200)
ax0 = fig.add_subplot(1,1,1)
clev = np.linspace(-2,2,15)
CS = plt.contourf(lon, p/100.0, psi_z, clev,cmap=plt.cm.RdYlBu_r,extend='both')
ax0.set_ylim(ax0.get_ylim()[::-1])
plt.xlabel("Longitude")
plt.ylabel("Pressure Level")
plt.title('zonal Mass Streamfunction')
cbar = plt.colorbar(CS, orientation='horizontal',extend='both',aspect=50,shrink=0.7)
cbar.ax.set_xlabel('unit:$10^{10}$ kg/s')
plt.savefig('zonal.png',dpi=500)
plt.show()