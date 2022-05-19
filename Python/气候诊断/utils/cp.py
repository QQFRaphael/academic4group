import numpy as np
from conform_dim import conform_dim
from vertical_integration import vertical_integration2

def cp(ua, va, ta, u_ave, v_ave, t_ave, lev, lat):
	R_cp = 0.286

	lev = lev * 100.0

	dp = np.gradient(lev)

	dtdp = np.gradient(t_ave, axis=0) / conform_dim(dp, t_ave, [1,2])
	dudp = np.gradient(u_ave, axis=0) / conform_dim(dp, t_ave, [1,2])
	dvdp = np.gradient(v_ave, axis=0) / conform_dim(dp, t_ave, [1,2])

	sigma = (R_cp*t_ave/conform_dim(lev,t_ave,[1,2])) - dtdp

	f =  conform_dim(2.*2.*np.pi/(60.*60.*24.)*np.sin(np.pi/180. * lat), sigma,[0,2])

	dcp = f/sigma*va*ta*dudp - f/sigma*ua*ta*dvdp

	cp = -vertical_integration2(dcp, lev)

	return cp