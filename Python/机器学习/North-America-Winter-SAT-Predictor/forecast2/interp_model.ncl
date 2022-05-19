load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/OBS/obs.nc","r")

obs = f->tmp
lat_obs = f->lat
lon_obs = f->lon

system("rm -rf obs.nc")
out = addfile("obs.nc","c")
out->obs = obs(31:38,:,:)


f11 = addfile("./cansips/CanCM4i.nc","r")
cancm4i = f11->tmp
lat_cancm4i = f11->lat_0
lon_cancm4i = f11->lon_0

cancm4i_int = linint2_Wrap(lon_cancm4i,lat_cancm4i,cancm4i,True,lon_obs,lat_obs,0)
copy_VarMeta(obs(31:38,:,:),cancm4i_int)

system("rm -rf cancm4i.nc")
out = addfile("cancm4i.nc","c")
out->cancm4i = cancm4i_int

f111 = addfile("./cansips/GEM_NEMO.nc","r")
gemnemo = f111->tmp
lat_gemnemo = f111->lat_0
lon_gemnemo = f111->lon_0

gemnemo_int = linint2_Wrap(lon_gemnemo,lat_gemnemo,gemnemo,True,lon_obs,lat_obs,0)
copy_VarMeta(obs(31:38,:,:),gemnemo_int)

system("rm -rf gemnemo.nc")
out = addfile("gemnemo.nc","c")
out->gemnemo = gemnemo_int

