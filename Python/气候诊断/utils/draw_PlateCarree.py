import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeat
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER

def draw_PlateCarree(lat_l, lat_u, lon_l, lon_r):
	proj = ccrs.PlateCarree()

	img_extent = [lon_l, lon_r, lat_l, lat_u]

	fig = plt.figure(figsize=(12,7)) 

	ax = fig.subplots(1, 1, subplot_kw={'projection':proj})

	ax.add_feature(cfeat.COASTLINE.with_scale('50m'), linewidth=0.6, zorder=1) 

	ax.set_extent(img_extent, crs=proj) 

	gl = ax.gridlines(crs=proj, draw_labels=True, linewidth=1.2, color='gray', alpha=0.5, linestyle='--')
	gl.top_labels = False  
	gl.right_labels = False  
	gl.xformatter = LONGITUDE_FORMATTER 
	gl.yformatter = LATITUDE_FORMATTER
	gl.xlabel_style={'size':18}
	gl.ylabel_style={'size':18}

	return fig, ax


	