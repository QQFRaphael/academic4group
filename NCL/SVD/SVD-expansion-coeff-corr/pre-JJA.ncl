load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./interannual.ncl"

season="JJA"
idx_A = 5
idx_B = 6
idx_C = 7

ttestval = 1.995

latU = 50.
latL = 1
lonL = 97.5
lonR = 145.

yy = 1971

year_start = 1971
year_end = 2018
nyears = year_end - year_start + 1
nmonths = nyears*12

varfile = addfile("./pre.nc","r")

lat = varfile->lat
lon = varfile->lon

lat_idx=ind(lat.ge.latL.and.lat.le.latU)
lon_idx=ind(lon.ge.lonL.and.lon.le.lonR)

vars = varfile->pre(0:575,:,:)

vA = vars(idx_A::12,:,:)
vB = vars(idx_B::12,:,:)
vC = vars(idx_C::12,:,:)

vClim = (vA + vB + vC)
copy_VarMeta(vA, vClim)

interan = vClim

do i = 0, dimsizes(lat)-1
    do j = 0, dimsizes(lon)-1
        interan(:,i,j) = 0
        interannual(vClim(:,i,j),interan(:,i,j),dimsizes(vClim(:,i,j)))   
    end do
end do

copy_VarMeta(vA, interan)

out = addfile("JJA-filter.nc", "c")
out->JJA = interan
out->lat = lat
out->lon = lon
