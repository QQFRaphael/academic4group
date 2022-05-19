load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("JJA-filter.nc", "r")
f2 = addfile("MAM-filter.nc", "r")

nsvd = 1
ntime = 48

latU = 55.
latL = 10
lonL = 100
lonR = 140.

nn = 6

nxxx = 1000


lat = f1->lat(::nn)
lon = f1->lon(::nn)

lat_idx=ind(lat.ge.latL.and.lat.le.latU)
lon_idx=ind(lon.ge.lonL.and.lon.le.lonR)

ja = f1->JJA(:,::nn,::nn)
ma = f2->MAM(:,::nn,::nn) 

JJA = ja(:,lat_idx,lon_idx)
MAM = ma(:,lat_idx,lon_idx)

nt = dimsizes(JJA(:,0,0))
ny = dimsizes(JJA(0,:,0))
nx = dimsizes(JJA(0,0,:))

JJA_in = reshape(JJA, (/nt,ny*nx/))
MAM_in = reshape(MAM, (/nt,ny*nx/))

JJA_in!0   = "time"                       ; name dimensions for reordering
JJA_in!1   = "col"
MAM_in!0   = "time"
MAM_in!1   = "col"

homlft = new((/nsvd,ny*nx/),float)
hetlft = new((/nsvd,ny*nx/),float)
homrgt = new((/nsvd,ny*nx/),float)
hetrgt = new((/nsvd,ny*nx/),float)

out = new((/nxxx/),"double") 

do i=0,nxxx-1

rand_idx = generate_unique_indices( ntime )
;spring_rand_idx = generate_unique_indices( ntime )

summer_rand = JJA_in(rand_idx,:)
;spring_rand = MAM_in(rand_idx,:)

var = svdstd(summer_rand(col|:,time|:),MAM_in(col|:,time|:),nsvd,homlft,hetlft,homrgt,hetrgt)
print("this is the "+i+"th test and the variance of 1st mode is "+var(0))

out(i) = var

end do

asciiwrite("sig.txt", out)
