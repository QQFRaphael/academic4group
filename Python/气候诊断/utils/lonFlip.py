import xarray as xr

def lonFlip_EW(ds):
	"""
	convert 0~365 to -180~180
	NCEP-DOE reanaylsis is 0~365, not compatible with Cartopy
	"""
	ds.coords['lon'] = (ds.coords['lon'] + 180) % 360 - 180 
	ds = ds.sortby(ds.lon)

	return ds

def lonFlip_360(ds):
	"""
	convert -180~180 to 0~360
	"""
	ds.coords['lon'] = (ds.coords['lon'] + 360) % 360 
	ds = ds.sortby(ds.lon)

	return ds