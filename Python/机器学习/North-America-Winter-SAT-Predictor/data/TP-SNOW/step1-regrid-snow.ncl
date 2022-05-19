; This script regrid the snow data
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

filein = addfile("nhsce_v01r01_19661004_20190304.nc","r")
scin = filein->snow_cover_extent
latitude = filein->latitude
longitude = filein->longitude

fileout = addfile("snow.rutger.2x2.nc","r")
lat = fileout->lat
lon = fileout->lon

tmp = scin*100
copy_VarMeta(scin, tmp)


srcGridName = "src_SCRIP.nc"
dstGridName = "dst_SCRIP.nc"
wgtFileName = "wgt.nc"

opt                = True
opt@LargeFile      = True

rectilinear_to_SCRIP(dstGridName,lat,lon,opt)
curvilinear_to_SCRIP(srcGridName,latitude,longitude,opt)


Opt                = True
Opt@InterpMethod   = "neareststod" 
Opt@SrcRegional=True

ESMF_regrid_gen_weights(srcGridName,dstGridName,wgtFileName,Opt)

OPT                = True
temp_regrid = ESMF_regrid_with_weights(scin,wgtFileName,OPT)

out=addfile("out.nc","c")
out->snowcover=temp_regrid
out->lat=lat
out->lon=lon




