load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

flist1 = systemfunc("ls *12.avrg.grib.grb2")
flist2 = systemfunc("ls *01.avrg.grib.grb2")
flist3 = systemfunc("ls *02.avrg.grib.grb2")

f1 = addfiles(flist1, "r")
f2 = addfiles(flist2, "r")
f3 = addfiles(flist3, "r")

ListSetType (f1, "join")
ListSetType (f2, "join")
ListSetType (f3, "join")


pre1 = f1[:]->PRATE_P8_L1_GGA0_avg
pre2 = f2[:]->PRATE_P8_L1_GGA0_avg1m
pre3 = f3[:]->PRATE_P8_L1_GGA0_avg1m

pre = pre1*31*24*3600 + pre2*31*24*3600 + pre3*28*24*3600
copy_VarMeta(pre1, pre)

pre!1="lat"
pre!2="lon"

lat_in = f1[0]->lat_0(::-1)
lon_in = f1[0]->lon_0


fca = addfile("/home/qqf/non-monsoonal-asia/feature-prepare/EOF-1979-2010/base-eof-result.nc", "r")
lat_out = fca->lat
lon_out = fca->lon

cfs = linint2_Wrap(lon_in, lat_in, pre(:,::-1,:), True, lon_out, lat_out, 0)

system("rm -rf cfs.nc")
out = addfile("cfs.nc", "c")
out->cfs = cfs

