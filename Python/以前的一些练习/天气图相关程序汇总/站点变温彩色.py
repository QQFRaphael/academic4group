import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset

files01=np.loadtxt("/Users/QQF/Downloads/obs/05",dtype=np.str)
files02=np.loadtxt("/Users/QQF/Downloads/obs/06",dtype=np.str)

station01=[int(x) for x in files01[:,0] if x]
latitude01=np.array([float(x) for x in files01[:,1] if x])
longitude01=np.array([float(x) for x in files01[:,2] if x])
T01=np.array([float(x) for x in files01[:,16] if x])

station02=[int(x) for x in files02[:,0] if x]
latitude02=np.array([float(x) for x in files02[:,1] if x]) 
longitude02=np.array([float(x) for x in files02[:,2] if x]) 
T02=np.array([float(x) for x in files02[:,16] if x]) 

T=[]
lat=[]
lon=[]
color=[]
size=[]

for ii in range(len(station01)):
    for jj in range(len(station02)):
        if station01[ii]==station02[jj]:
           tmp=T02[jj]-T01[ii]
           T.append(abs(tmp))
           lat.append(latitude01[ii])
           lon.append(longitude01[ii]) 
           size.append(10)
           if tmp<=-4.0:
             color.append("blue")
           elif -4.0<tmp<=-3.0:
             color.append("cyan")
           elif -3.0<tmp<=-2.0:
             color.append("green")
           elif -2.0<tmp<=-1.0:
             color.append("yellow")
           elif -1.0<tmp<=0.0:
             color.append("red")
           else:
             color.append("magenta")

#m = Basemap(projection='lcc',llcrnrlat=21,urcrnrlat=25,\
#            llcrnrlon=111,urcrnrlon=115,lat_ts=23,resolution='h')
m = Basemap(llcrnrlon=111,llcrnrlat=21,urcrnrlon=115,urcrnrlat=25,\
            projection='lcc',lat_1=6.,lat_2=38.,lon_0=113,resolution='h')
x,y=m(lon,lat)



#
#print "ssssss"
#
m.drawcoastlines(linewidth=0.5)
m.drawparallels(np.arange(21,25,1),labels=[1,1,0,0])
m.drawmeridians(np.arange(111,115,1),labels=[0,1,0,1])

m.scatter(x,y,size,marker='o',c=color,edgecolors='none')#,s=size)
plt.title("0700UTC-0800UTC Temperature change")

plt.savefig("/Users/QQF/Downloads/tmp.png",dpi=600)


