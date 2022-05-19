def tibet_shp_load(filepath):
	tibet_shp = []
	with open(filepath, 'r') as f:
		for line in f:
			line.strip('\n')
			lon_str, lat_str = line.split()[0].split(',')
			tibet_shp.append(tuple([float(lon_str), float(lat_str)]))
	return tibet_shp