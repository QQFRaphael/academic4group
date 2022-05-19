# -*- coding: utf-8 -*-
"""
Created on Sun May 10 18:23:30 2015

@author: QQF
"""

import numpy as np
import Scientific.IO.NetCDF as S
import matplotlib.pyplot as plt

def unified_oscillator(T,h,tau1,tau2):
    a=0.41
    b1=0.68
    b2=2.1
    b3=0.68
    c=0.91
    d=1e-4
    e=3.3e-5
    epsilon=3.3e-3
    rh=3.1e-3
    rtau1=5.5e-3
    rtau2=5.5e-3
    eta=150
    delta=30
    miu=90
    Lambda=180
    dTdt=a*tau1[180]-b1*tau1[180-eta]+b2*tau2[180-delta]-b3*tau1[180-miu]-epsilon*T[180]**3
    dhdt=-c*tau1[180-Lambda]-rh*h[180]
    dtau1dt=d*T[180]-rtau1*tau1[180]
    dtau2dt=e*h[180]-rtau2*tau2[180]
    return dTdt, dhdt, dtau1dt, dtau2dt
    
def delayed_oscillator(T,tau1):
    a=0.41
    b1=0.68
    d=1e-4
    epsilon=3.3e-3
    rtau1=5.5e-3
    eta=150
    dTdt=a*tau1[180]-b1*tau1[180-eta]-epsilon*T[180]**3
    dtau1dt=d*T[180]-rtau1*tau1[180]
    return dTdt, dtau1dt

def recharge_oscillator(T,h):
    a=0.41
    b1=0.68
    b2=2.1
    c=0.91
    d=1e-4
    e=3.3e-5
    epsilon=3.3e-3
    rh=3.1e-3
    rtau1=5.5e-3
    rtau2=5.5e-3
    eta=150
    delta=30
    Lambda=180
    dTdt=a*d/rtau1*T[180]-b1*d/rtau1*T[180-eta]+b2*e/rtau2*h[180-delta]-epsilon*T[180]**3
    dhdt=-c*d/rtau1*T[180-Lambda]-rh*h[180]
    return dTdt, dhdt
    
def western_pacific_oscillator(T,h,tau1,tau2):
    a=0.41
    b2=2.1
    c=0.91
    d=1e-4
    e=3.3e-5
    epsilon=3.3e-3
    rh=3.1e-3
    rtau1=5.5e-3
    rtau2=5.5e-3
    delta=30
    Lambda=180
    dTdt=a*tau1[180]+b2*tau2[180-delta]-epsilon*T[180]**3
    dhdt=-c*tau1[180-Lambda]-rh*h[180]
    dtau1dt=d*T[180]-rtau1*tau1[180]
    dtau2dt=e*h[180]-rtau2*tau2[180]
    return dTdt, dhdt, dtau1dt, dtau2dt
    
def advective_oscillator(T,h,tau1,tau2):
    a=0.41
    b1=0.68
    b2=2.1
    c=0.91
    d=1e-4
    e=3.3e-5
    epsilon=3.3e-3
    rh=3.1e-3
    rtau1=5.5e-3
    rtau2=5.5e-3
    eta=150
    delta=30
    Lambda=180
    dTdt=a*tau1[180]-b1*tau1[180-eta]+b2*tau2[180-delta]-epsilon*T[180]**3
    dhdt=-c*tau1[180-Lambda]-rh*h[180]
    dtau1dt=d*T[180]-rtau1*tau1[180]
    dtau2dt=e*h[180]-rtau2*tau2[180]
    return dTdt, dhdt, dtau1dt, dtau2dt
        
f=S.NetCDFFile('initialize_oscillators_155508754.nc','r')
h=f.variables['h'].getValue()
tau1=f.variables['tau1'].getValue()
tau2=f.variables['tau2'].getValue()
sst=f.variables['SST'].getValue()
time=f.variables['time'].getValue()
tt=np.arange(0,4001,1)
dt=1.0

h_unified_oscillator=h
tau1_unified_oscillator=tau1
tau2_unified_oscillator=tau2
sst_unified_oscillator=sst
for ii in range(tt.shape[0]):
    dTdt,dhdt,dtau1dt,dtau2dt=unified_oscillator(sst_unified_oscillator[ii:ii+181],h_unified_oscillator[ii:ii+181],tau1_unified_oscillator[ii:ii+181],tau2_unified_oscillator[ii:ii+181])
    sst_unified_oscillator=np.append(sst_unified_oscillator,sst_unified_oscillator[ii+180]+dt*dTdt)
    h_unified_oscillator=np.append(h_unified_oscillator,h_unified_oscillator[ii+180]+dt*dhdt)
    tau1_unified_oscillator=np.append(tau1_unified_oscillator,tau1_unified_oscillator[ii+180]+dt*dtau1dt)
    tau2_unified_oscillator=np.append(tau2_unified_oscillator,tau2_unified_oscillator[ii+180]+dt*dtau2dt)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
sst_pic,=ax0.plot(sst_unified_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino3 sea surface temperature anomaly')
plt.savefig('sst_unified_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
h_pic,=ax0.plot(h_unified_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino6 thermocline depth anomaly')
plt.savefig('h_unified_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau1_pic,=ax0.plot(tau1_unified_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino4 region')
plt.savefig('tau1_unified_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau2_pic,=ax0.plot(tau2_unified_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino5 region')
plt.savefig('tau2_unified_oscillator.png',dpi=400)

tau1_delayed_oscillator=tau1
sst_delayed_oscillator=sst
for ii in range(tt.shape[0]):
    dTdt,dtau1dt=delayed_oscillator(sst_delayed_oscillator[ii:ii+181],tau1_delayed_oscillator[ii:ii+181])
    sst_delayed_oscillator=np.append(sst_delayed_oscillator,sst_delayed_oscillator[ii+180]+dt*dTdt)
    tau1_delayed_oscillator=np.append(tau1_delayed_oscillator,tau1_delayed_oscillator[ii+180]+dt*dtau1dt)
    
fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
sst_pic,=ax0.plot(sst_delayed_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino3 sea surface temperature anomaly')
plt.savefig('sst_delayed_oscillator.png',dpi=400)    
    
fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau1_pic,=ax0.plot(tau1_delayed_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino4 region')
plt.savefig('tau1_delayed_oscillator.png',dpi=400)

h_recharge_oscillator=h
sst_recharge_oscillator=sst
for ii in range(tt.shape[0]):
    dTdt,dhdt=recharge_oscillator(sst_recharge_oscillator[ii:ii+181],h_recharge_oscillator[ii:ii+181])
    sst_recharge_oscillator=np.append(sst_recharge_oscillator,sst_recharge_oscillator[ii+180]+dt*dTdt)
    h_recharge_oscillator=np.append(h_recharge_oscillator,h_recharge_oscillator[ii+180]+dt*dhdt)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
sst_pic,=ax0.plot(sst_recharge_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino3 sea surface temperature anomaly')
plt.savefig('sst_recharge_oscillator.png',dpi=400)  

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
h_pic,=ax0.plot(h_recharge_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino6 thermocline depth anomaly')
plt.savefig('h_recharge_oscillator.png',dpi=400) 

h_western_pacific_oscillator=h
tau1_western_pacific_oscillator=tau1
tau2_western_pacific_oscillator=tau2
sst_western_pacific_oscillator=sst
for ii in range(tt.shape[0]):
    dTdt,dhdt,dtau1dt,dtau2dt=western_pacific_oscillator(sst_western_pacific_oscillator[ii:ii+181],h_western_pacific_oscillator[ii:ii+181],tau1_western_pacific_oscillator[ii:ii+181],tau2_western_pacific_oscillator[ii:ii+181])
    sst_western_pacific_oscillator=np.append(sst_western_pacific_oscillator,sst_western_pacific_oscillator[ii+180]+dt*dTdt)
    h_western_pacific_oscillator=np.append(h_western_pacific_oscillator,h_western_pacific_oscillator[ii+180]+dt*dhdt)
    tau1_western_pacific_oscillator=np.append(tau1_western_pacific_oscillator,tau1_western_pacific_oscillator[ii+180]+dt*dtau1dt)
    tau2_western_pacific_oscillator=np.append(tau2_western_pacific_oscillator,tau2_western_pacific_oscillator[ii+180]+dt*dtau2dt)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
sst_pic,=ax0.plot(sst_western_pacific_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino3 sea surface temperature anomaly')
plt.savefig('sst_western_pacific_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
h_pic,=ax0.plot(h_western_pacific_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino6 thermocline depth anomaly')
plt.savefig('h_western_pacific_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau1_pic,=ax0.plot(tau1_western_pacific_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino4 region')
plt.savefig('tau1_western_pacific_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau2_pic,=ax0.plot(tau2_western_pacific_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino5 region')
plt.savefig('tau2_western_pacific_oscillator.png',dpi=400)

h_advective_oscillator=h
tau1_advective_oscillator=tau1
tau2_advective_oscillator=tau2
sst_advective_oscillator=sst
for ii in range(tt.shape[0]):
    dTdt,dhdt,dtau1dt,dtau2dt=advective_oscillator(sst_advective_oscillator[ii:ii+181],h_advective_oscillator[ii:ii+181],tau1_advective_oscillator[ii:ii+181],tau2_advective_oscillator[ii:ii+181])
    sst_advective_oscillator=np.append(sst_advective_oscillator,sst_advective_oscillator[ii+180]+dt*dTdt)
    h_advective_oscillator=np.append(h_advective_oscillator,h_advective_oscillator[ii+180]+dt*dhdt)
    tau1_advective_oscillator=np.append(tau1_advective_oscillator,tau1_advective_oscillator[ii+180]+dt*dtau1dt)
    tau2_advective_oscillator=np.append(tau2_advective_oscillator,tau2_advective_oscillator[ii+180]+dt*dtau2dt)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
sst_pic,=ax0.plot(sst_advective_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino3 sea surface temperature anomaly')
plt.savefig('sst_advective_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
h_pic,=ax0.plot(h_advective_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('Nino6 thermocline depth anomaly')
plt.savefig('h_advective_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau1_pic,=ax0.plot(tau1_advective_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino4 region')
plt.savefig('tau1_advective_oscillator.png',dpi=400)

fig = plt.figure(figsize=(14,8),dpi=400)
ax0 = fig.add_subplot(1,1,1)
tau2_pic,=ax0.plot(tau2_advective_oscillator,'r-',linewidth=1)
plt.xlim(0,4000)
plt.xlabel("time")
plt.title('zonal wind stress anomaly in the Nino5 region')
plt.savefig('tau2_advective_oscillator.png',dpi=400)
