load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./shapefile_utils.ncl"

tfile = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")

lat = tfile->lat
lon = tfile->lon

latidx = ind(lat.le.55.0.and.lat.ge.17.0)
lonidx = ind(lon.le.136.0.and.lon.ge.72.0)

tems = tfile->pre(:,latidx,lonidx)
outdata = tems
nt = dimsizes(tems(:,0,0))

shpfile  = "/var/opt/geodiag/data/map/bou1_4p.shp"

opt             = True
opt@return_mask = True
shp_mask = shapefile_mask_data(tems(0,:,:),shpfile,opt)

do tt = 0, nt-1
outdata(tt,:,:) = where(shp_mask.eq.1,tems(tt,:,:),tems@_FillValue)
print("this is the: "+tt)
end do

copy_VarMeta(tems, outdata)

system("rm -rf CRU_China.nc")
out = addfile("CRU_China.nc", "c")
out->pre = outdata

