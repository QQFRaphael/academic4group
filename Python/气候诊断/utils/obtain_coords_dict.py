import numpy as np

def obtain_coords_dict(var):
	tmp = [x for x in var.coords]

	dim_name = []

	if "time" in tmp and np.shape(var['time'])!=(): dim_name.append("time")

	if "level" in tmp and np.shape(var['level'])!=(): dim_name.append("level")

	if "lev" in tmp and np.shape(var['lev'])!=(): dim_name.append("lev")

	if "lat" in tmp and np.shape(var['lat'])!=(): dim_name.append("lat")

	if 	"latitude" in tmp and np.shape(var['latitude'])!=(): dim_name.append("latitude")

	if "lon" in tmp and np.shape(var['lon'])!=(): dim_name.append("lon")

	if "longitude" in tmp and np.shape(var['longitude'])!=(): dim_name.append("longitude")

	coords = []

	for name in dim_name: coords.append((name, var[name].values))

	return coords
