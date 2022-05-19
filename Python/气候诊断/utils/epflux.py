import numpy as np
import xarray as xr
from conform_dim import conform_dim
from obtain_coords_dict import obtain_coords_dict


def epflux(uwnd, vwnd, tk, lev, lat, scale):
	R = 287.0
	Cp = 1.005*(10**3)
	a = 6.37122e06

	phi = lat * np.pi / 180.0
	a_cos_phi = a * np.cos(phi)
	a_sin_phi = a * np.sin(phi)

	omega = 7.2921e-5
	f = 2.0 * omega * np.sin(phi)

	latfac = a_cos_phi * np.cos(phi)

	theta = tk*np.power(conform_dim(lev,tk,(0,2,3))/1000.0,-(R/Cp))

	theta_zonal_mean = np.mean(theta, axis=3)

	dp = np.gradient(lev*100.0)

	dtheta_dp = np.gradient(theta_zonal_mean, axis=1) / conform_dim(dp, theta_zonal_mean, (0,2))

	u_anom = uwnd - conform_dim(np.mean(uwnd, axis=3),uwnd,[3])
	v_anom = vwnd - conform_dim(np.mean(vwnd, axis=3),vwnd,[3])
	theta_anom = theta - conform_dim(np.mean(theta, axis=3),theta,[3])

	uv = u_anom * v_anom
	uv_mean = np.mean(uv, axis=3)

	vtheta = v_anom * theta_anom
	vtheta_mean = np.mean(vtheta, axis=3)

	F_phi = -uv_mean * conform_dim(latfac, uv_mean, [0,1])

	F_p = conform_dim(f*a_cos_phi, vtheta_mean, [0,1]) * vtheta_mean / dtheta_dp
	
	EP_div_phi = np.gradient(F_phi, axis=2) / conform_dim(np.gradient(a_sin_phi), F_phi, [0,1])

	EP_div_p = np.gradient(F_p, axis=1) / conform_dim(dp, F_p, [0,2])

	EP_div = EP_div_phi + EP_div_p

	dudt = 86400.0 * EP_div / conform_dim(a*np.cos(phi), EP_div, [0,1]) 

	# scale F_p, F_phi
	F_p = F_p * conform_dim(np.cos(phi),F_p,[0,1]) / 1.0e5
	F_phi = F_phi / a / np.pi

	rhofac = np.sqrt(1000.0/lev)

	F_p = F_p * conform_dim(rhofac, F_p, [0,2])
	F_phi = F_phi * conform_dim(rhofac, F_phi, [0,2])

	# scale lev < 100, stratosphere
	strat = np.ones(np.shape(lev))
	strat[np.where(lev<100.0)] = scale
	strat = conform_dim(strat, F_p, [0,2])

	F_p = F_p * strat
	F_phi = F_phi * strat

	coords = obtain_coords_dict(F_p)

	EP_div = xr.DataArray(EP_div, coords=coords)
	dudt = xr.DataArray(dudt, coords=coords)

	return F_phi, F_p, EP_div, dudt