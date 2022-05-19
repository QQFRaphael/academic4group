# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 17:16:31 2015

@author: qqf
"""

import numpy as np
from Energy_balance_a import energy_balance
from scipy.integrate import odeint
import matplotlib.pyplot as plt

Tm0=((1.0-0.3)*342-203.3)/2.09
To0=Tm0
alpha=0.2

t=np.arange(0,4000)
T=odeint(energy_balance,(Tm0,To0),t,args=(alpha,))
Tm=T[:,0]
To=T[:,1]

plt.figure(1)
plt.plot(t,Tm,'b-',linewidth=2,label="Mixed layer")
plt.plot(t,To,'r-',linewidth=2,label="Deep ocean")
plt.xlabel("years")
plt.ylabel("Temperature ($K$)")
plt.legend()
#plt.show()
plt.savefig("./1a.png",dpi=500)