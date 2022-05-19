load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$GEODIAG_ROOT/geodiag.ncl"

wrff1=addfile("/home/yongluo/WORK/wrfoutput/wrfout/2007-07-31/wrfout_d01_2007-07-31_00:00:00","r")
wrff2=addfile("/home/yongluo/WORK/wrfoutput/wrfout/2007-07-31/wrfout_d01_2007-08-01_00:00:00","r")
wrff3=addfile("/home/yongluo/WORK/wrfoutput/wrfout/2007-07-31/wrfout_d02_2007-07-31_00:00:00","r")
wrff4=addfile("/home/yongluo/WORK/wrfoutput/wrfout/2007-07-31/wrfout_d02_2007-08-01_00:00:00","r")

rainc1=wrff1->RAINC
rainnc1=wrff1->RAINNC
rainc2=wrff2->RAINC
rainnc2=wrff2->RAINNC
rainc3=wrff3->RAINC
rainnc3=wrff3->RAINNC
rainc4=wrff4->RAINC
rainnc4=wrff4->RAINNC

lat_d01=wrf_user_getvar(wrff1,"XLAT",0)
lon_d01=wrf_user_getvar(wrff1,"XLONG",0)
lat_d02=wrf_user_getvar(wrff3,"XLAT",0)
lon_d02=wrf_user_getvar(wrff3,"XLONG",0)

pre1=rainc1+rainnc1
pre2=rainc2+rainnc2
pre3=rainc3+rainnc3
pre4=rainc4+rainnc4

pre_d01=pre2-pre1
pre_d02=pre4-pre3
copy_VarMeta(rainc1,pre_d01)
copy_VarMeta(rainc2,pre_d02)

printVarSummary(lat_d01)
printVarSummary(lon_d01)
printVarSummary(lat_d02)
printVarSummary(lon_d02)
printVarSummary(pre_d01)
printVarSummary(pre_d02)

out=addfile("2007-07-31_d01.nc","c")
out->pre_d01=pre_d01
out->lat_d01=lat_d01
out->lon_d01=lon_d01

out=addfile("2007-07-31_d02.nc","c")
out->pre_d02=pre_d02
out->lat_d02=lat_d02
out->lon_d02=lon_d02



