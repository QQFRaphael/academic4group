load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

qfile = addfile("q.mon.mean.nc","r")  ;addfile("shum.mon.mean.nc","r")
ufile = addfile("uwnd.mon.mean.nc","r")
vfile = addfile("vwnd.mon.mean.nc","r")

lat = ufile->lat
lon = ufile->lon
level = ufile->level
time = ufile->time

shum = qfile->q
uwnd = ufile->uwnd
vwnd = vfile->vwnd

uq = shum * uwnd 
vq = shum * vwnd 

copy_VarMeta(uwnd, uq)
copy_VarMeta(vwnd, vq)

qVdiv = uv2dv_cfd(uq,vq,lat,lon,3)
copy_VarMeta(uwnd,qVdiv)

dpp = new(dimsizes(level)-1, "float")
dpp = level(0:dimsizes(level)-2) - level(1:dimsizes(level)-1)

uq_new = new((/dimsizes(time),dimsizes(level)-1,dimsizes(lat),dimsizes(lon)/), "float")
uq_new = (uq(:,0:dimsizes(level)-2,:,:)+uq(:,1:dimsizes(level)-1,:,:))/2.0

dp = conform(uq_new,dpp,1)

uq_int = dim_sum_n_Wrap(uq_new*dp,1) / 9.8
copy_VarMeta(uwnd(:,0,:,:),uq_int)

vq_new = new((/dimsizes(time),dimsizes(level)-1,dimsizes(lat),dimsizes(lon)/), "float")
vq_new = (vq(:,0:dimsizes(level)-2,:,:)+vq(:,1:dimsizes(level)-1,:,:))/2.0

vq_int = dim_sum_n_Wrap(vq_new*dp,1) / 9.8
copy_VarMeta(uwnd(:,0,:,:),vq_int)


;qVdiv_new = new((/dimsizes(time),dimsizes(level)-1,dimsizes(lat),dimsizes(lon)/), "float")
;qVdiv_new = (qVdiv(:,0:dimsizes(level)-2,:,:)+qVdiv(:,1:dimsizes(level)-1,:,:))/2.0
;qVdiv_int = dim_sum_n_Wrap(qVdiv_new*dp,1) / 9.8

qVdiv_int = uv2dv_cfd(uq_int,vq_int,lat,lon,3)
copy_VarMeta(uwnd(:,0,:,:),qVdiv_int)


system("rm -rf watflux.mon.mean.nc")
out = addfile("watflux.mon.mean.nc","c")
out->uq = uq
out->vq = vq
out->uq_int = uq_int
out->vq_int = vq_int
out->qVdiv_int = qVdiv_int
;out->qVdiv = qVdiv
