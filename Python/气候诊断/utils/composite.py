import numpy as np
import xarray as xr


def composite(var, years_low, years_high):
	var_low = var.sel(time=var.time.dt.year.isin(years_low)) 
	var_high = var.sel(time=var.time.dt.year.isin(years_high))
	nlow = len(years_low)
	nhigh = len(years_high)

	low_ave = var_low.mean(dim='time')
	high_ave = var_high.mean(dim='time')

	low_std = var_low.std(dim='time')
	high_std = var_high.std(dim='time')

	diff = high_ave - low_ave
	tval = np.abs(diff/np.sqrt( ( (nhigh-1.)*high_std**2+(nlow-1.)*low_std**2)/(nhigh+nlow-2.0))/np.sqrt(1.0/nhigh+1.0/nlow))

	return diff, tval 