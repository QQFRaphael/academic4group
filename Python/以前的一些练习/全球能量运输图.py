# -*- coding: utf-8 -*-
"""
Created on Mon May  4 08:34:42 2015

@author: qqf
"""

import numpy as np
import Scientific.IO.NetCDF as S
import matplotlib.pyplot as plt

def eps_func(var,lat,lon):
    var_ave_time=var.mean(axis=0)
    a=6.37122e6
    A=np.empty(var_ave_time.shape)
    cc=np.pi/180.0
    for ii in range(lon.shape[0]):
        for jj in range(lat.shape[0]):
            if jj==lat.shape[0]-1:
                A[jj,ii]=a*a*np.cos(lat[jj]*cc)*1.875*(lat[jj-1]-lat[jj])*cc*cc/1e15
            else:
                A[jj,ii]=a*a*np.cos(lat[jj]*cc)*1.875*(lat[jj]-lat[jj+1])*cc*cc/1e15
    var_area=A*var_ave_time
    var_area_ave=np.empty(var_area.shape[0])
    for jj in range((lat.shape[0])):
        var_area_ave[jj]=np.sum(var_area[jj,:])
    var_out=np.empty(var_area_ave.shape)
    for jj in range(lat.shape[0]):
        var_out[jj]=-np.sum(var_area_ave[:jj])
    return var_out
        
    
f=S.NetCDFFile('flxl06.clim.ann.nc','r')
lat=f.variables['lat_0'].getValue()
lon=f.variables['lon_0'].getValue()
short_down_top=f.variables['DSWRF_P8_L8_GGA0'].getValue()
short_up_top=f.variables['USWRF_P8_L8_GGA0'].getValue()
long_up_top=f.variables['ULWRF_P8_L8_GGA0'].getValue()
short_down_sf=f.variables['DSWRF_P8_L1_GGA0'].getValue()
short_up_sf=f.variables['USWRF_P8_L1_GGA0'].getValue()
long_down_sf=f.variables['DLWRF_P8_L1_GGA0'].getValue()
long_up_sf=f.variables['ULWRF_P8_L1_GGA0'].getValue()
LE=f.variables['LHTFL_P8_L1_GGA0'].getValue()
SH=f.variables['SHTFL_P8_L1_GGA0'].getValue()

R_TOA=short_down_top-short_up_top-long_up_top
R_SFC=long_down_sf-long_up_sf+short_down_sf-short_up_sf

DIV_FA=R_TOA-R_SFC+LE+SH
DIV_FO=R_SFC-LE-SH

EPSILON_TOA=eps_func(R_TOA,lat,lon)
EPSILON_FA=eps_func(DIV_FA,lat,lon)
EPSILON_FO=eps_func(DIV_FO,lat,lon)

fig=plt.figure(figsize=(14,8),dpi=500)
ax0=fig.add_subplot(1,1,1)

atm,=ax0.plot(lat,EPSILON_FA,'k--',linewidth=2)
ocn,=ax0.plot(lat,EPSILON_FO,'b--',linewidth=2)
eps,=ax0.plot(lat,EPSILON_TOA,'r-',linewidth=2)
plt.xlabel("Latitude")
plt.ylabel("Energy[$10^{15}W$]")
plt.xlim(90,-90)
plt.title('')
plt.grid()
plt.xticks([-90,-60,-30,0,30,60,90],["$90^{\circ}S$","$60^{\circ}S$","$30^{\circ}S$","$0^{\circ}$","$30^{\circ}N$","$60^{\circ}N$","$90^{\circ}N$"])
plt.legend([tot,atm,ocn], ['Total', 'Atmosphere','Ocean'],loc=4)
plt.title('Energy Transport')
plt.savefig('1.png',dpi=500)
