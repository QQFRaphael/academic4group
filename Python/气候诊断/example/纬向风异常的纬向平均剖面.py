import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
from sklearn.feature_selection import f_regression

import sys
sys.path.append("../utils/")

from conform_dim import conform_dim
from mon2season import Month_to_Season
from Linear_Regression_dim import Linear_Regression_dim
from epflux import epflux


uu = xr.open_dataset('../data/uwnd.mon.mean.nc')

lev = uu['level'] 

lat = uu['lat'].loc[88:20]

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

degree_symbol=u'\u00B0'



for season in ["SON", "OND", "NDJ"]:
	uwnd = Month_to_Season(uu['uwnd'].loc[:,:,88:20,:], season, "ave", 1979, 2020)
	
	hgt = np.mean(uwnd,axis=3)

	hgt, hgt_sig = Linear_Regression_dim(hgt, sic_idx, 0)
	hgt = xr.DataArray(hgt,coords=[("lev",lev.values),("lat",lat.values)])
	hgt_sig = xr.DataArray(hgt_sig,coords=[("lev",lev.values),("lat",lat.values)])

	uwnd = np.mean(uwnd, axis=3)
	uwnd = np.mean(uwnd, axis=0)
	uwnd = xr.DataArray(uwnd,coords=[("lev",lev.values),("lat",lat.values)])

	print(np.max(hgt),np.min(hgt))
	
	plt.close
	
	fig = plt.figure(figsize=(10,15)) 
	
	ax = fig.subplots(1, 1)
	
	levels = np.linspace(-1,1,21)

	im = ax.contourf(lat, lev, hgt, levels=levels, cmap="RdBu_r",extend="both")
	cb = plt.colorbar(im, orientation='horizontal', shrink=0.8)
	cb.ax.tick_params(labelsize=18)

	sig = ax.contourf(lat, lev, hgt_sig, [np.min(hgt_sig),0.1], hatches=['..'], colors="None", zorder=1)
	  
	ll = [10,15,20,25,30]
	im2 = ax.contour(lat, lev, uwnd,  levels=ll, colors="k", linewidths=2.0)
	ax.clabel(im2, im2.levels, inline=True, fmt="%d", fontsize=14)

	plt.yscale('symlog')
	
	ax.invert_yaxis()
	#ax.set_ylim(1000,30)

	ytk = [1000,850,700,600,500,400,300,250,200,150,100,70,50,30,10]
	xtk = [30,40,50,60,70,80]
	xtkstr = ['{0}'.format(str(int(x)))+degree_symbol+'N' for x in xtk] 
	plt.yticks(ytk, ytk)
	plt.xticks(xtk, xtkstr)
	plt.tick_params(labelsize = 25)
	
	fig.show()
	fig.savefig( "%s.png" % season, dpi=1000)

	print(season)
