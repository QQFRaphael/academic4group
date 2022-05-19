# -*- coding: utf-8 -*-
"""
Editor de Spyder

Este es un archivo temporal
"""
import numpy as np
from scipy import constants as const
import matplotlib.pyplot as plt

def B(wavelength,Temperature):
    '''
    we use Planck's law to compute the radiation emitted by a black body
    h: Planck constant J/s
    c:speed of light m/s
    kb:Boltzmann constant J/K
    '''
    const1=2.0*const.h*const.c**2
    const2=const.h*const.c/const.k
    B=const1/wavelength**5/(np.exp(const2/wavelength/Temperature)-1.0)
    return B

Temperature=[6000.0,255]

Xaxis1=range(2500)
wavelength1=np.array(Xaxis1)*1E-9
plt.figure(1)
plt.plot(Xaxis1,B(wavelength1,Temperature[0]),'b-',linewidth=2)
plt.xlabel('Wave Length ($nm$)')
plt.ylabel("Radiation ($J\cdot{s^{-1}}\cdot{K}$)")
plt.title("6000K Radiation Curve")
plt.savefig("/Users/QQF/Desktop/6000K.png",dpi=500)

Xaxis2=range(100000)
wavelength2=np.array(Xaxis2)*1E-9
plt.figure(2)
plt.plot(Xaxis2,B(wavelength2,Temperature[1]),'r-',linewidth=2)
plt.xlabel('Wave Length ($nm$)')
plt.ylabel("Radiation ($J\cdot{s^{-1}}\cdot{K}$)")
plt.title("250K Radiation Curve")
plt.savefig("/Users/QQF/Desktop/250K.png",dpi=500)

Xaxis=range(2500)
wavelength=np.array(Xaxis)*1E-9
plt.figure(3)
plt.plot(Xaxis,B(wavelength,Temperature[0]),'b-',linewidth=2,label="6000K")
plt.plot(Xaxis,B(wavelength,Temperature[1]),'r-',linewidth=2,label="255K")
plt.legend()
plt.xlabel('Wave Length ($nm$)')
plt.ylabel("Radiation ($J\cdot{s^{-1}}\cdot{K}$)")
plt.title("Radiation Curve")
plt.savefig("/Users/QQF/Desktop/Both.png",dpi=500)


fig, ax1 = plt.subplots()
Xaxis=range(2500)
wavelength=np.array(Xaxis)*1E-9
ax1.plot(Xaxis,B(wavelength,Temperature[0]),'b-',linewidth=2,label="6000K")
ax1.set_xlabel('Wave Length ($nm$)')
# Make the y-axis label and tick labels match the line color.
ax1.set_ylabel('6000K Radiation ($J\cdot{s^{-1}}\cdot{K}$)', color='b')
for tl in ax1.get_yticklabels():
    tl.set_color('b')


ax2 = ax1.twinx()
ax2.plot(Xaxis,B(wavelength,Temperature[1]),'r-',linewidth=2,label="255K")
ax2.set_ylabel('255K Radiation ($J\cdot{s^{-1}}\cdot{K}$)', color='r')
for tl in ax2.get_yticklabels():
    tl.set_color('r')
plt.savefig("/Users/QQF/Desktop/TwoAxis.png",dpi=500)