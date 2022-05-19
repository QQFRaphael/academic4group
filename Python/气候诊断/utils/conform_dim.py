import numpy as np

def conform_dim(x, y, dims):
	new_x = np.expand_dims(x, dims)
	for dim in dims: new_x = np.repeat(new_x, np.shape(y)[dim], axis=dim)

	return new_x