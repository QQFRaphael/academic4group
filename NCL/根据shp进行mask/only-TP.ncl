load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/RUTGERS.snow.1967.2019.nc", "r")

sc = f->snowcover

lat = f->lat
lon = f->lon

lon_idx = ind(lon.ge.60.and.lon.le.110)
lat_idx = ind(lat.ge.20.and.lat.le.50)

nlat = dimsizes(lat)
nlon = dimsizes(lon)

f2=asciiread("../tibet_shape",(/2066,2/),"float")
tp_lon = f2(:,0)
tp_lat = f2(:,1)


do ilt=0,nlat-1
    do iln=0,nlon-1
        if(.not.gc_inout(lat(ilt),lon(iln),tp_lat,tp_lon)) then
          sc(:,ilt,iln) = sc@_FillValue
        end if
    end do
end do

system("rm -rf test.nc")
out = addfile("test.nc", "c")
out->sc = sc(:,lat_idx,lon_idx)
