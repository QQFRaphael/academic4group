import os
import numpy as np
import xarray as xr
import cartopy.crs as ccrs
import matplotlib.path as mpath
import matplotlib.pyplot as plt

season = "ndj"
path = "../%s/" % season

def draw_north_polar_steoro(lat_l):
	fig = plt.figure(figsize=(8,8))
	
	ax = plt.axes([0.05,0.05,0.9,0.9], projection=ccrs.NorthPolarStereo()) 
	
	# draw a circle as the bourder of the picture
	theta = np.linspace(0, 2*np.pi, 100)
	center, radius = [0.5, 0.5], 0.5
	verts = np.vstack([np.sin(theta), np.cos(theta)]).T
	circle = mpath.Path(verts * radius + center)
	
	ax.coastlines()
	ax.gridlines(crs=ccrs.PlateCarree(), xlocs=np.linspace(-180,180,13), ylocs=np.linspace(lat_l,80,4), draw_labels=False, linewidth=1.2, color='gray', alpha=0.5, linestyle='--')
	ax.set_extent([-180,180,lat_l,90], crs=ccrs.PlateCarree())
	ax.set_boundary(circle, transform=ax.transAxes) 
	cbar_kwargs = {'shrink':0.8}
	
	lond = np.linspace(-180, 180, 13)
	latd = np.zeros(len(lond))+lat_l-1.3
	
	va = 'center' # also bottom, top
	ha = 'center' # right, left
	degree_symbol=u'\u00B0'
	
	for (alon, alat) in zip(lond, latd):
	    projx1, projy1 = ax.projection.transform_point(alon, alat, ccrs.Geodetic())
	    if alon>0 and alon<180:
	        ha = 'left'
	        va = 'center'
	        txt =  ' {0} '.format(str(int(alon)))+degree_symbol+'E'
	    if alon>-180 and alon<0:
	        ha = 'right'
	        va = 'center'
	        alon = np.abs(alon)
	        txt =  ' {0} '.format(str(int(alon)))+degree_symbol+'W'
	    if np.abs(alon+180)<0.01:
	        ha = 'center'
	        va = 'bottom'
	        txt =  ' {0} '.format(str(int(np.abs(alon))))+degree_symbol
	    if alon==0.:
	        ha = 'center'
	        va = 'top'
	        txt =  ' {0} '.format(str(int(alon)))+degree_symbol
	    if (alon<180.):
	        ax.text(projx1, projy1, txt, va=va, ha=ha, color='k', fontsize=18)	

	return fig, ax


for k in ['k1','k2','k3','k4','k5','k6','k7']:
	plt.cla()
	fig, ax = draw_north_polar_steoro(10)
	files = os.popen("ls %s*%s*" % (path, k)).read().split()
	for filename in files:
		lats = []
		lons = []
		with open("%s%s" % (path, filename), 'r') as f:
			for line in f:
				line.strip('\n')
				lat_str, lon_str = line.split()
				lat = float(lat_str)
				lon = float(lon_str)
				lats.append(lat)
				lons.append(lon)

		im = ax.scatter(lons, lats, marker='.', s=0.1, transform=ccrs.PlateCarree())
	cb = plt.colorbar(im, orientation='horizontal', shrink=0.8)
		
	fig.show()
	fig.savefig("%s-%s.png" % (season, k), dpi=1000)

	print("--------------------------------%s--------------------------------" % k)

	
