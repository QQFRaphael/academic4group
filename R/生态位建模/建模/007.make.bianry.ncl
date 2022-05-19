load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

system("rm -rf binary/binary06")
system("mkdir -p binary/binary06")

path = "ncOutput/"
scenes = (/"ens-ssp126-2021-2040",  "ens-ssp245-2021-2040",  "ens-ssp370-2021-2040",  "ens-ssp585-2021-2040",  "ens-ssp126-2041-2060",  "ens-ssp245-2041-2060",  "ens-ssp370-2041-2060",  "ens-ssp585-2041-2060",  "ens-ssp126-2061-2080",  "ens-ssp245-2061-2080",  "ens-ssp370-2061-2080",  "ens-ssp585-2061-2080",  "ens-ssp126-2081-2100",  "ens-ssp245-2081-2100",  "ens-ssp370-2081-2100",  "ens-ssp585-2081-2100",  "current"/)

do ii=0,dimsizes(scenes)-1
scene = scenes(ii)

f = addfile(path+scene+"-ROC.nc", "r")

data = f->Band1
data = where(isnan_ieee(data),data@_FillValue,data)
data = where(data.lt.600, 0, 1)

system("rm -rf "+scene+".nc")
out = addfile(scene+".nc", "c")
out->Band1 = data

system("mv "+scene+".nc binary/binary06/")
end do
