load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ff = addfile("example.nc","r")

hgt = ff->HGT(0,:,:)
lat = ff->XLAT(0,:,:)
lon = ff->XLONG(0,:,:)

f2=asciiread("tibet_shape",(/2066,2/),"float")

lontibet = f2(:,0)
lattibet = f2(:,1)

do ii = 0, dimsizes(hgt(:,0))-1
    do jj = 0, dimsizes(hgt(0,:))-1
        if(.not.gc_inout(lat(ii,jj),lon(ii,jj),lattibet,lontibet)) then
            hgt(ii,jj) = 9e99
        end if
    end do
end do

copy_VarMeta(ff->HGT(0,:,:), hgt)
hgt@_FillValue = 9e99
system("rm -rf mask.nc")
out = addfile("mask.nc", "c")
out->mask = hgt
