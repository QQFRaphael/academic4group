import Ngl
import numpy as np
import xarray as xr

case = "ctl"
nyears = 52

vlevs = [1000, 925, 850, 700, 600, 500, 400, 300, 250, 200, 150, 100, 70, 50, 30, 20, 10]

nx = 144
ny = 96
nz = len(vlevs)
nt = nyears * 12

uwnd = np.zeros([nt, nz, ny, nx])
vwnd = np.zeros([nt, nz, ny, nx])
omega = np.zeros([nt, nz, ny, nx])
tk = np.zeros([nt, nz, ny, nx])
hgt = np.zeros([nt, nz, ny, nx])

idx = 0

for year in range(1, nyears+1):
	for mon in range(1,13):
		file = "%s/%s.cam.h0.%s-%s.nc" % (case, case, str(year).zfill(4), str(mon).zfill(2))
		ds = xr.open_dataset(file)

		hyam = ds['hyam']
		hybm = ds['hybm']

		P0 = ds['P0']

		T = ds['T']
		U = ds['U']
		V = ds['V']
		OMG = ds['OMEGA']
		Z3 = ds['Z3']
		PS = ds['PS']

		Tnew = Ngl.vinth2p(T,hyam,hybm,vlevs,PS,1,P0,1,True)
		print(Tnew)
