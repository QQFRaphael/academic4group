load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../../feature-prepare/EOF-1979-2010/base-eof-result.nc", "r")

fobs = addfile("../../feature-prepare/EOF-1979-2010/obs.nc", "r")
obs = fobs->obs(32:,:,:)

eof1 = conform(obs,f->eof1,(/1,2/))
eof2 = conform(obs,f->eof2,(/1,2/))
eof3 = conform(obs,f->eof3,(/1,2/))

ts1 = conform(obs, asciiread("PC1.txt", 8, "float"), (/0/))
ts2 = conform(obs, asciiread("PC2.txt", 8, "float"), (/0/))
ts3 = conform(obs, asciiread("PC3.txt", 8, "float"), (/0/))

lr1 = eof1 * ts1
copy_VarMeta(obs, lr1)

lr2 = eof2 * ts2
copy_VarMeta(obs, lr2)

lr3 = eof3 * ts3
copy_VarMeta(obs, lr3)

lr = lr1 + lr2 + lr3
copy_VarMeta(obs, lr)

system("rm -rf CatBoost.nc")
out = addfile("CatBoost.nc", "c")
out->model = lr
out->model1 = lr1
out->model2 = lr2
out->model3 = lr3
out->obs = obs
