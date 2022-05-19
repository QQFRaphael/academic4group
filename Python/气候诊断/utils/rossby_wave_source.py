import xarray as xr
from windspharm.xarray import VectorWind
from obtain_coords_dict import obtain_coords_dict

def RWS(uwnd, vwnd):
	w = VectorWind(uwnd, vwnd)

	eta = w.absolutevorticity()
	div = w.divergence()
	uchi, vchi = w.irrotationalcomponent()
	etax, etay = w.gradient(eta)

	s = -eta * div - (uchi * etax + vchi * etay)

	coords = obtain_coords_dict(uwnd)

	rws = xr.DataArray(s, coords=coords)

	return rws