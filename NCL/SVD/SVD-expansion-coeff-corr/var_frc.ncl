load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ff= addfile("mysvd_reg.nc", "r")

jja_time0 = ff->jja_time0
mam_time0 = ff->mam_time0

jja0 = ff->jja0
mam0 = ff->mam0

f1 = addfile("JJA-filter.nc", "r")
f2 = addfile("MAM-filter.nc", "r")

ja = f1->JJA  ;(:,::nn,::nn)
ma = f2->MAM  ;(:,::nn,::nn) 

jja_svd = conform(ja,jja0,(/1,2/)) * conform(ja,jja_time0,0)
mam_svd = conform(ma,mam0,(/1,2/)) * conform(ma,mam_time0,0)

jja_svd_var_frac = dim_variance_n_Wrap(jja_svd, 0) / (dim_variance_n_Wrap(ja, 0)+0.00000001)
mam_svd_var_frac = dim_variance_n_Wrap(mam_svd, 0) / (dim_variance_n_Wrap(ma, 0)+0.00000001)

copy_VarMeta(ja(0,:,:), jja_svd_var_frac)
copy_VarMeta(ja(0,:,:), mam_svd_var_frac)

system("rm -rf frac.nc")
out = addfile("frac.nc", "c")
out->jja_svd_var_frac = jja_svd_var_frac
out->mam_svd_var_frac = mam_svd_var_frac