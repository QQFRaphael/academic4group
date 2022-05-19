import numpy as np
import xarray as xr
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import f_regression

def Linear_Regression_dim(var, index, axis):
	shape = np.shape(var)
	axis_length = shape[axis]

	rest_dims = np.delete(shape, axis)
	rest_to_1d = np.prod(rest_dims)

	var_2d = np.array(var).reshape(axis_length, rest_to_1d)

	reg_out = var_2d[0,:].copy()
	reg_sig = var_2d[0,:].copy()

	for idx in range(rest_to_1d):
		if not (np.isnan(np.min(var_2d[:,idx])) or np.any(np.isinf(var_2d[:,idx]))):
			model = LinearRegression().fit(index.reshape(-1, 1), var_2d[:,idx].reshape(-1, 1))
			reg_out[idx] = model.coef_[0][0]
			reg_sig[idx] = f_regression(var_2d[:,idx].reshape(-1, 1), index)[1]

	reg_sig = np.reshape(reg_sig, rest_dims)
	reg_out = np.reshape(reg_out, rest_dims)

	return reg_out, reg_sig

# another way to perform linear regression is np.linalg.lstsq
#hgt_son = Month_to_Season(hgt, myseason, "ave", year_start, year_end).loc[:,mylev,:,:]
#uwnd_son = Month_to_Season(uwnd, myseason, "ave", year_start, year_end).loc[:,mylev,:,:]
#vwnd_son = Month_to_Season(vwnd, myseason, "ave", year_start, year_end).loc[:,mylev,:,:]

#sic_idx_reg = np.vstack([sic_idx, np.ones(len(sic_idx))]).T

#hgt_2d = np.array(hgt_son).reshape(hgt_son.shape[0],hgt_son.shape[1]*hgt_son.shape[2])


#hgt_reg = np.linalg.lstsq(sic_idx_reg, hgt_2d, rcond=None)[0][0].reshape(len(lat),len(lon))
#hgt_reg_xr = xr.DataArray(hgt_reg,coords=[("level",lev),("lat",lat),("lon",lon)]).loc[200,:,:]
