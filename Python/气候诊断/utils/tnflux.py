import numpy as np
import xarray as xr
from conform_dim import conform_dim

def tnflux(u_c, v_c, hgt_a, lev, lat, lon, mask_threshold):
	"""
	u_c: clim of uwnd, m/s
	v_c: clim of vwnd, m/s
	hgt_a: perturbation of geopotential height, m
	lev: the level of WAF, hPa
	a: Earth radius
	omega: angular velocity of the Earth
	gc: gas constant
	ga: gravitational acceleration
	sclhgt: scale height
	f: coriolis parameter, f=2*omega*sin(lat)
	mask_threshold: mask small WAF vectors according to the magnitude of the vector
	"""
	a = 6378388.0
	omega = 2.0 * np.pi / (60.0*60.0*24.0)
	gc = 290.0
	ga = 9.80665
	sclhgt = 8000.

	dlon = np.gradient(lon) * np.pi / 180.0
	dlat = np.gradient(lat) * np.pi / 180.0

	f = np.array(list(map(lambda x : 2*omega*np.sin(x*np.pi/180.0),lat)))
	cos_lat = np.array(list(map(lambda x : np.cos(x*np.pi/180.0),lat))) 

	psi_a = ((hgt_a * ga).T / f).T

	dpsi_dlon = np.gradient(psi_a,axis=1) / conform_dim(dlon, psi_a, [0])
	dpsi_dlat = np.gradient(psi_a,axis=0) / conform_dim(dlat, psi_a, [1])
	d2psi_dlon2 = np.gradient(dpsi_dlon,axis=1) / conform_dim(dlon, psi_a, [0])
	d2psi_dlat2 = np.gradient(dpsi_dlat,axis=0) / conform_dim(dlat, psi_a, [1])
	d2psi_dlondlat = np.gradient(dpsi_dlat,axis=1) / conform_dim(dlon, psi_a, [0])

	xuterm = dpsi_dlon * dpsi_dlon - psi_a * d2psi_dlon2
	xvterm = dpsi_dlon * dpsi_dlat - psi_a * d2psi_dlondlat
	yvterm = dpsi_dlat * dpsi_dlat - psi_a * d2psi_dlat2

	p = lev / 1000.0
	U = np.sqrt(u_c**2 + v_c**2)
	coeff = ((p * cos_lat) / (2.0 * U.T)).T

	FX = (coeff.T/(a*a*cos_lat)).T * (((u_c.T)/cos_lat).T*xuterm+v_c*xvterm)
	FY = (coeff.T/(a*a)).T * (((u_c.T)/cos_lat).T*xvterm+v_c*yvterm)

	Fspd = np.sqrt(FX**2+FY**2)

	FX = np.where(Fspd<mask_threshold, np.nan, FX)
	FY = np.where(Fspd<mask_threshold, np.nan, FY)

	Fx = xr.DataArray(FX, coords=[("lat",lat.values),("lon",lon.values)])
	Fy = xr.DataArray(FY, coords=[("lat",lat.values),("lon",lon.values)])

	return Fx, Fy
