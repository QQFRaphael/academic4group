load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

flr = addfile("../LR/LR.nc", "r")
fxg = addfile("../XGBoost/XGBoost.nc", "r")
flg = addfile("../LightGBM/LightGBM.nc", "r")
fct = addfile("../CatBoost/CatBoost.nc", "r")
fgb = addfile("../GBDT/GBDT.nc", "r")
f = addfile("../data/CanSIPSv2/cansips.nc", "r")
ff = addfile("../data/CFSv2/cfs.nc", "r")

cancm = f->cancm_prec(30:,:,:)
gem   = f->gem_prec(30:,:,:)

cfs = ff->cfs

obs = flr->obs

lr = flr->model
xg = fxg->model
lg = flg->model
ct = fct->model
gb = fgb->model

ens_ml = (xg + lg + ct + gb) / 4.0
ens_dy = (cancm + gem + cfs) / 3.0
ens_all = (xg + lg + ct + gb + cancm + gem + cfs) / 7.0
ens_dy22 = (cancm  + cfs) / 2.0
ens_all22 = (xg + lg + ct + gb + cancm + cfs) / 6.0


ens_cancm = (xg + lg + ct + gb + cancm)/5.0

system("rm -rf ens_*.nc CanCM.nc GEM.nc ens_cancm.nc")

out = addfile("ens_ml.nc", "c")
out->model = ens_ml
out->obs = obs

out = addfile("ens_dy.nc", "c")
out->model = ens_dy
out->obs = obs

out = addfile("ens_all.nc", "c")
out->model = ens_all
out->obs = obs

out = addfile("CanCM.nc", "c")
out->model = cancm
out->obs = obs

out = addfile("GEM.nc", "c")
out->model = gem
out->obs = obs

out = addfile("ens_cancm.nc", "c")
out->model = ens_cancm
out->obs = obs


out = addfile("ens_dy22.nc", "c")
out->model = ens_dy22
out->obs = obs


out = addfile("ens_all22.nc", "c")
out->model = ens_all22
out->obs = obs
