import os
import numpy as np

mylat = [75, 72.5, 70, 67.5,75, 72.5, 70, 67.5, 75,72.5,70,77.5, 75,72.5,70,67.5,75,72.5,70,67.5,75,72.5,70,67.5,75,72.5,70,67.5,75,72.5,70,67.5]
mylon = [197.5,197.5,197.5,197.5,200,200,200,200,202.5,202.5,202.5,202.5,205,205,205,205,207.5,207.5,207.5,207.5,210,210,210,210,212.5,212.5,212.5,212.5,215,215,215,215]
mywavenumber = [1,2,3,4,5,6,7]

lat = np.linspace(90,-90,73)
lon = np.linspace(0,357.5,144)

os.system("./clean.sh")

for k in mywavenumber:
	for loc in zip(mylat, mylon):
		frcLat = loc[0]
		frcLon = loc[1]

		frcx = np.where(lon==frcLon)[0][0]
		frcy = np.where(lat==frcLat)[0][0]

		os.system("sed -i \"70s/^.*.*$/frcx=[%d];/g\" calc_2d_raytrace.m" % frcx)
		os.system("sed -i \"71s/^.*.*$/frcy=[%d];/g\" calc_2d_raytrace.m" % frcy)
		os.system("sed -i \"83s/^.*.*$/k_wavenumbers=[%d];/g\" calc_2d_raytrace.m" % k)

		os.system("matlab -nodesktop -nosplash -nodisplay -r \"run('calc_2d_raytrace.m');exit;\"")
