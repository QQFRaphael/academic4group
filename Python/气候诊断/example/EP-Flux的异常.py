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
vv = xr.open_dataset('../data/vwnd.mon.mean.nc')
tt = xr.open_dataset('../data/air.mon.mean.nc')
hh = xr.open_dataset('../data/hgt.mon.mean.nc')

lev = uu['level'] #.loc[1000:10]

lat = uu['lat'].loc[88:20]

scale = 1

sic_idx = np.loadtxt("../sic-idx/idx-filter.txt")

degree_symbol=u'\u00B0'



for season in ["SON", "OND", "NDJ"]:
	uwnd = Month_to_Season(uu['uwnd'].loc[:,:,88:20,:], season, "ave", 1979, 2020)
	vwnd = Month_to_Season(vv['vwnd'].loc[:,:,88:20,:], season, "ave", 1979, 2020)
	tk = Month_to_Season(tt['air'].loc[:,:,88:20,:], season, "ave", 1979, 2020)
	hgt = Month_to_Season(hh['hgt'].loc[:,:,88:20,:], season, "ave", 1979, 2020)
	
	hgt, hgt_sig = Linear_Regression_dim(hgt, sic_idx, 0)
	hgt = np.mean(hgt, axis=2)
	hgt = xr.DataArray(hgt,coords=[("lev",lev.values),("lat",lat.values)])

	F_phi, F_p, EP_div, dudt = epflux(uwnd, vwnd, tk, lev, lat, scale)
	
	F_phi, F_phi_sig = Linear_Regression_dim(F_phi, sic_idx, 0)
	F_phi = xr.DataArray(F_phi,coords=[("lev",lev.values),("lat",lat.values)])
	
	F_p, F_p_sig = Linear_Regression_dim(F_p, sic_idx, 0)
	F_p = xr.DataArray(F_p,coords=[("lev",lev.values),("lat",lat.values)])

	F_phi.loc[10,:] = np.nan
	F_p.loc[10,:] = np.nan

	Fphi_sig = np.where(np.logical_or(F_phi_sig<=0.2, F_p_sig<=0.2), F_phi, np.nan)
	Fp_sig = np.where(np.logical_or(F_phi_sig<=0.2, F_p_sig<=0.2), F_p, np.nan)

	Fphi_not_sig = np.where(np.logical_and(F_phi_sig>0.2, F_p_sig>0.2), F_phi, np.nan)
	Fp_not_sig = np.where(np.logical_and(F_phi_sig>0.2, F_p_sig>0.2), F_p, np.nan)

	Fphi_sig_xr = xr.DataArray(Fphi_sig,coords=[("lev",lev.values),("lat",lat.values)])
	Fp_sig_xr = xr.DataArray(Fp_sig,coords=[("lev",lev.values),("lat",lat.values)])

	Fphi_not_sig_xr = xr.DataArray(Fphi_not_sig,coords=[("lev",lev.values),("lat",lat.values)])
	Fp_not_sig_xr = xr.DataArray(Fp_not_sig,coords=[("lev",lev.values),("lat",lat.values)])
	
	EP_div, EP_div_sig = Linear_Regression_dim(EP_div, sic_idx, 0)
	EP_div = xr.DataArray(EP_div,coords=[("lev",lev.values),("lat",lat.values)])
	
	dudt, dudt_sig = Linear_Regression_dim(dudt, sic_idx, 0)
	dudt = xr.DataArray(dudt,coords=[("lev",lev.values),("lat",lat.values)])

	print(np.max(hgt),np.min(hgt))
	
	
	plt.close
	
	fig = plt.figure(figsize=(10,15)) 
	
	ax = fig.subplots(1, 1)
	
	levels = np.linspace(-16,16,33)

	im = ax.contourf(lat, lev, EP_div, levels=levels, cmap="RdBu_r",extend="both")
	cb = plt.colorbar(im, orientation='horizontal', shrink=0.8)
	cb.ax.tick_params(labelsize=18)

	sig = ax.contourf(lat, lev, EP_div_sig, [np.min(EP_div_sig),0.1], hatches=['..'], colors="None", zorder=1)
	  
	fontproperties = {"size":14}
	#uvflux_sig = ax.quiver(lat, lev, F_phi, -F_p, color="k",scale=50)
	uvflux_not_sig = ax.quiver(lat, lev, Fphi_not_sig_xr, -Fp_not_sig_xr, color="gray",scale=50)
	uvflux_sig = ax.quiver(lat, lev, Fphi_sig_xr, -Fp_sig_xr, color="k",scale=50)

	uvflux_sig_key = ax.quiverkey(uvflux_sig, 0.95, 1.03, 2, "2", color="black", fontproperties=fontproperties)
	
	ll = [-10,10,30,50,70]
	im2 = ax.contour(lat, lev, hgt,  levels=ll, colors="k", linewidths=2.0)
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
