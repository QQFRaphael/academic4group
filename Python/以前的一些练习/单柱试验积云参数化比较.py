# -*- coding: utf-8 -*-
"""
Created on Tue Nov 24 20:55:38 2015

@author: QQF
"""

import numpy as np
import os
from netCDF4 import Dataset
import matplotlib.pyplot as plt

result=os.popen('cat /Users/QQF/Desktop/test').read()
lists=result.split(",")
pre=[]
for x in lists:
    pre.append(float(x))
    
cu_1=Dataset('/Users/QQF/Downloads/CU/CU_1')
RAINC=cu_1.variables['RAINC'][0:578,:,:]
RAINNC=cu_1.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_1=RAIN[1:577]-RAIN[0:576]

cu_2=Dataset('/Users/QQF/Downloads/CU/CU_2')
RAINC=cu_2.variables['RAINC'][0:578,:,:]
RAINNC=cu_2.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_2=RAIN[1:577]-RAIN[0:576]

cu_3=Dataset('/Users/QQF/Downloads/CU/CU_3')
RAINC=cu_3.variables['RAINC'][0:578,:,:]
RAINNC=cu_3.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_3=RAIN[1:577]-RAIN[0:576]

cu_4=Dataset('/Users/QQF/Downloads/CU/CU_4')
RAINC=cu_4.variables['RAINC'][0:578,:,:]
RAINNC=cu_4.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_4=RAIN[1:577]-RAIN[0:576]

cu_5=Dataset('/Users/QQF/Downloads/CU/CU_5')
RAINC=cu_5.variables['RAINC'][0:578,:,:]
RAINNC=cu_5.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_5=RAIN[1:577]-RAIN[0:576]

cu_6=Dataset('/Users/QQF/Downloads/CU/CU_6')
RAINC=cu_6.variables['RAINC'][0:578,:,:]
RAINNC=cu_6.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_6=RAIN[1:577]-RAIN[0:576]

cu_7=Dataset('/Users/QQF/Downloads/CU/CU_7')
RAINC=cu_7.variables['RAINC'][0:578,:,:]
RAINNC=cu_7.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_7=RAIN[1:577]-RAIN[0:576]

cu_14=Dataset('/Users/QQF/Downloads/CU/CU_14')
RAINC=cu_14.variables['RAINC'][0:578,:,:]
RAINNC=cu_14.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_14=RAIN[1:577]-RAIN[0:576]

cu_84=Dataset('/Users/QQF/Downloads/CU/CU_84')
RAINC=cu_84.variables['RAINC'][0:578,:,:]
RAINNC=cu_84.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_84=RAIN[1:577]-RAIN[0:576]

cu_93=Dataset('/Users/QQF/Downloads/CU/CU_93')
RAINC=cu_93.variables['RAINC'][0:578,:,:]
RAINNC=cu_93.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_93=RAIN[1:577]-RAIN[0:576]

cu_99=Dataset('/Users/QQF/Downloads/CU/CU_99')
RAINC=cu_99.variables['RAINC'][0:578,:,:]
RAINNC=cu_99.variables['RAINNC'][0:578,:,:]
RAIN=(RAINC[:,0,0]+RAINNC[:,0,0]+RAINC[:,1,0]+RAINNC[:,1,0]+RAINC[:,0,1]+RAINNC[:,0,1]+RAINC[:,1,1]+RAINNC[:,1,1])/4.0
pre_cu_99=RAIN[1:577]-RAIN[0:576]

t=np.arange(0,576)
plt.figure(1)
plt.plot(t,pre,'c-',linewidth=2,label="OBS")
plt.plot(t,pre_cu_1,'r-',linewidth=1,label="KF")
plt.plot(t,pre_cu_2,'g-',linewidth=1,label="BMJ")
plt.plot(t,pre_cu_3,'y-',linewidth=1,label="GF")
plt.plot(t,pre_cu_4,'b-',linewidth=1,label="OSAS")
plt.plot(t,pre_cu_5,'c-',linewidth=1,label="G3")
plt.plot(t,pre_cu_6,'m-',linewidth=1,label="Tiedtke")
plt.plot(t,pre_cu_7,'k-',linewidth=1,label="ZhangMc")
plt.plot(t,pre_cu_14,'r-.',linewidth=1,label="NSAS")
plt.plot(t,pre_cu_84,'g-.',linewidth=1,label="NSAS (HWRF)")
plt.plot(t,pre_cu_84,'y-.',linewidth=1,label="GD")
plt.plot(t,pre_cu_84,'b-.',linewidth=1,label="old KF")
plt.xlabel("every minutes")
plt.ylabel("precipitation (mm)")
plt.xlim(0,566)
plt.ylim(0,0.8)
plt.legend(ncol=2,fontsize=10)
plt.savefig("/Users/QQF/Downloads/CU_performance.png",dpi=800)