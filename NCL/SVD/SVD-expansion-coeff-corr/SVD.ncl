load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("JJA-filter.nc", "r")
f2 = addfile("MAM-filter.nc", "r")

nsvd    = 2

ttestval = 1.995

latU = 55.
latL = 10
lonL = 100
lonR = 140.

;nn = 2


lat = f1->lat  ;(::nn)
lon = f1->lon  ;(::nn)

lat_idx=ind(lat.ge.latL.and.lat.le.latU)
lon_idx=ind(lon.ge.lonL.and.lon.le.lonR)

ja = f1->JJA  ;(:,::nn,::nn)
ma = f2->MAM  ;(:,::nn,::nn) 

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

printVarSummary(JJA_in)

homlft = new((/nsvd,ny*nx/),float)
hetlft = new((/nsvd,ny*nx/),float)
homrgt = new((/nsvd,ny*nx/),float)
hetrgt = new((/nsvd,ny*nx/),float)


x = svdstd(JJA_in(col|:,time|:), MAM_in(col|:,time|:), nsvd, homlft, hetlft, homrgt, hetrgt)
print("svdcov: percent variance= " + x)

ak   = onedtond(x@ak,(/nsvd,nt/))
bk   = onedtond(x@bk,(/nsvd,nt/))

system("rm -rf mysvd.nc")
out = addfile("mysvd.nc", "c")


jja_time0 = dim_standardize_n_Wrap(ak(0,:), 1, 0)

jja0 = escorc_n(jja_time0, ja, 0, 0) 
tval_jja0 = jja0*sqrt(46/1-jja0*jja0)    ;reshape(jja0@tval,(/dimsizes(jja0(:,0)),dimsizes(jja0(0,:))/))
copy_VarMeta(ja(0,:,:), jja0)
copy_VarMeta(ja(0,:,:), tval_jja0)

mam_time0 = dim_standardize_n_Wrap(bk(0,:), 1, 0)

mam0 = escorc_n(mam_time0, ma, 0, 0) 
tval_mam0 = mam0*sqrt(46/1-mam0*mam0)   ;reshape(mam0@tval,(/dimsizes(mam0(:,0)),dimsizes(mam0(0,:))/))
copy_VarMeta(ma(0,:,:), mam0)
copy_VarMeta(ma(0,:,:), tval_mam0)


;jja_time1 = dim_standardize_n_Wrap(ak(1,:), 1, 0)
;
;jja1 = regCoef_n(jja_time1, ja, 0, 0) 
;tval_jja1 = reshape(jja1@tval,(/dimsizes(jja1(:,0)),dimsizes(jja1(0,:))/))
;copy_VarMeta(ja(0,:,:), jja1)
;copy_VarMeta(ja(0,:,:), tval_jja1)
;
;
;mam_time1 = dim_standardize_n_Wrap(bk(1,:), 1, 0)
;
;mam1 = regCoef_n(mam_time1, ma, 0, 0) 
;tval_mam1 = reshape(mam1@tval,(/dimsizes(mam1(:,0)),dimsizes(mam1(0,:))/))
;copy_VarMeta(ma(0,:,:), mam1)
;copy_VarMeta(ma(0,:,:), tval_mam1)
;

out->jja_time0 = jja_time0
;out->jja_time1 = jja_time1

out->mam_time0 = mam_time0
;out->mam_time1 = mam_time1

out->jja0 = jja0
;out->jja1 = jja1

out->mam0 = mam0
;out->mam1 = mam1

out->tval_jja0 = tval_jja0
;out->tval_jja1 = tval_jja1

out->tval_mam0 = tval_mam0
;out->tval_mam1 = tval_mam1
out->var = x
