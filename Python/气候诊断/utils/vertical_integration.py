import numpy as np
from conform_dim import conform_dim

def vertical_integration(var, level):
	nz = np.shape(level)[0]
	dp = level.values[0:nz-2] - level.values[1:nz-1]

	var_new = (var.values[:,0:nz-2,:,:] + var.values[:,1:nz-1,:,:]) / 2.0
	dpp = conform_dim(dp, var_new, (0,2,3))

	var_int = np.sum(var_new*dpp, axis=1)

	return var_int


def vertical_integration2(var, level):
	nz = np.shape(level)[0]
	dp = level.values[0:nz-2] - level.values[1:nz-1]

	var_new = (var.values[0:nz-2,:,:] + var.values[1:nz-1,:,:]) / 2.0
	dpp = conform_dim(dp, var_new, (1,2))

	var_int = np.sum(var_new*dpp, axis=0)

	return var_int