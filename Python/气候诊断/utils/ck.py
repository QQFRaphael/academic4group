import numpy as np
from vertical_integration import vertical_integration

def ck(ua, va, u_ave, v_ave, dx, dy):
	dudx = np.gradient(u_ave, axis=2) / dx
	dvdx = np.gradient(v_ave, axis=2) / dx
	dudy = np.gradient(u_ave, axis=1) / dy
	dvdy = np.gradient(v_ave, axis=1) / dy

	ck = (va*va - ua*ua) / 2.0 * (dudx - dvdy) - ua * va * (dudy + dvdx)
	return ck


def ke(ua, va):
	ke = (ua*ua + va*va) / 2.0
	return ke