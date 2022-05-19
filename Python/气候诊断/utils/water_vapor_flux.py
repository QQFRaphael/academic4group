import numpy as np
import xarray as xr
import metpy.calc as mp
from obtain_coords_dict import obtain_coords_dict
from uv2div_cfd import uv2div_cfd
from vertical_integration import vertical_integration

def specific_humidity_from_relative_humidity(rh, p, tk):
	mixing_ratio = mp.mixing_ratio_from_relative_humidity(p, tk, rh)
	sp = mp.specific_humidity_from_mixing_ratio(mixing_ratio)
	if "time" in sp.coords and np.shape(sp['time'])!=(): sp = sp.transpose("time",...)

	return  sp


def water_vapor_flux_div_column(sp, uwnd, vwnd, lat, lon, level):
	uq = sp * uwnd
	vq = sp * vwnd

	uq_int = vertical_integration(uq, level) / 9.8
	vq_int = vertical_integration(vq, level) / 9.8

	div = uv2div_cfd(uq_int, vq_int, lat, lon)

	coords = obtain_coords_dict(sp[:,0,:,:])

	uq_int = xr.DataArray(uq_int, coords=coords)
	vq_int = xr.DataArray(vq_int, coords=coords)
	div = xr.DataArray(div, coords=coords)

	return uq_int, vq_int, div