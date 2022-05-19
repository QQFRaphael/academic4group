# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 19:18:52 2015

@author: qqf
"""

import numpy as np
from Energy_balance_b import energy_balance
from scipy.integrate import odeint
import matplotlib.pyplot as plt

Tm0=((1.0-0.3)*342-203.0)/2.09
To0=Tm0
alpha=0.2

t=np.arange(0,200)
T=odeint(energy_balance,(Tm0,To0),t,args=(alpha,))
Tm=T[:,0]
To=T[:,1]
TT=np.exp(-t/(1025.0*3850.0*50.0/2.09))*((1.0-alpha)*342-(203.3+2.09*Tm0))

plt.figure(1)
plt.plot(t,Tm,'b-',linewidth=2,label="Mixed layer")
plt.plot(t,TT,'r-',linewidth=2,label="Linear Approximation")
plt.xlabel("years")
plt.ylabel("Temperature")
plt.ylim(16,35)
plt.legend()
#plt.show()
plt.savefig("./1b.png",dpi=500)