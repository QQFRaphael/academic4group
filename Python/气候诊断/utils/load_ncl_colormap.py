import pandas as pd
from matplotlib.colors import ListedColormap

# The file of color map should be the following format
# r g b
# 255 255 255
# ....
# 234 234 234

def load_ncl_colormap(mapname):
	rgb = pd.read_csv(mapname,sep='\s+',skiprows=2,names=['r','g','b']).values/255
	colormap = ListedColormap(rgb)

	return colormap
