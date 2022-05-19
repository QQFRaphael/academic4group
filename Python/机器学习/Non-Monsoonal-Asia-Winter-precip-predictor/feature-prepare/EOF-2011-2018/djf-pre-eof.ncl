load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

season="DJF"
idx_A = 11 
idx_B = 12
idx_C = 13

yearstart = 2011
yearend = 2019
nyear = yearend - yearstart + 1

varfile = addfile("../../data/cru_ts4.04.1901.2019.pre.dat.nc","r")

vars = varfile->pre

lat=varfile->lat
lon=varfile->lon

lat_idx=ind(lat.ge.30.and.lat.le.60)
lon_idx=ind(lon.ge.30.and.lon.le.105)

year=calendar_decode2(varfile->time,0)
year_idx=ind(year(:,0).ge.yearstart.and.year(:,0).le.yearend)

varss = vars(year_idx,:,:)

varA = varss(idx_A::12,:,:)
varB = varss(idx_B::12,:,:)
varC = varss(idx_C::12,:,:)

printVarSummary(varA)
printVarSummary(varB)

var = varA(0:nyear-2,:,:)+varB+varC
copy_VarMeta(varB,var)

neof   = 3

optEOF = True       
optEOF@jopt = 0

optETS = False

eof=eofunc_n_Wrap(NewCosWeight(var(:,lat_idx,lon_idx)),neof,optEOF,0)
eof_ts=eofunc_ts_n_Wrap(var(:,lat_idx,lon_idx),eof,optETS,0)

sig_ev  = eofunc_north(eof@eval, nyear, True)

system("rm -rf eof-pre-djf.nc")
out = addfile("eof-pre-djf.nc", "c")

system("rm -rf base-eof-result.nc")
cc = addfile("base-eof-result.nc", "c")

;system("rm -rf obs.nc")
;dd = addfile("obs.nc", "c")
;dd->obs = var(:,lat_idx,lon_idx)

printVarSummary(eof)

itheof = 0
ts = dim_standardize_n_Wrap(eof_ts(itheof,:), 0, 0)
rc = regCoef_n(ts,var, 0, 0)
copy_VarMeta(var(0,:,:),rc)
tval = reshape(rc@tval,(/dimsizes(var(0,:,0)),dimsizes(var(0,0,:))/))
copy_VarMeta(var(0,:,:),tval)
delete(rc@tval)
delete(rc@nptxy)
delete(rc@rstd)
delete(rc@yintercept)
out->eof1 = rc
out->tval1 = tval
out->ts1 = ts
out->var1 = eof@pcvar(itheof)
delete(ts)
delete(rc)
delete(tval)

eof1 = eof(itheof,:,:)
copy_VarMeta(var(0,lat_idx,lon_idx), eof1)
cc->eof1 = eof1
cc->ts1 = eof_ts(itheof,:)


itheof = 1
ts = dim_standardize_n_Wrap(eof_ts(itheof,:), 0, 0)
rc = regCoef_n(ts,var, 0, 0)
copy_VarMeta(var(0,:,:),rc)
tval = reshape(rc@tval,(/dimsizes(var(0,:,0)),dimsizes(var(0,0,:))/))
copy_VarMeta(var(0,:,:),tval)
delete(rc@tval)
delete(rc@nptxy)
delete(rc@rstd)
delete(rc@yintercept)
out->eof2 = rc
out->tval2 = tval
out->ts2 = ts
out->var2 = eof@pcvar(itheof)
delete(ts)
delete(rc)
delete(tval)

eof2 = eof(itheof,:,:)
copy_VarMeta(var(0,lat_idx,lon_idx), eof2)
cc->eof2 = eof2
cc->ts2 = eof_ts(itheof,:)

itheof = 2
ts = dim_standardize_n_Wrap(eof_ts(itheof,:), 0, 0)
rc = regCoef_n(ts,var, 0, 0)
copy_VarMeta(var(0,:,:),rc)
tval = reshape(rc@tval,(/dimsizes(var(0,:,0)),dimsizes(var(0,0,:))/))
copy_VarMeta(var(0,:,:),tval)
delete(rc@tval)
delete(rc@nptxy)
delete(rc@rstd)
delete(rc@yintercept)
out->eof3 = rc
out->tval3 = tval
out->ts3 = ts
out->var3 = eof@pcvar(itheof)
delete(ts)
delete(rc)
delete(tval)

eof3 = eof(itheof,:,:)
copy_VarMeta(var(0,lat_idx,lon_idx), eof3)
cc->eof3 = eof3
cc->ts3 = eof_ts(itheof,:)


;itheof = 3
;ts = dim_standardize_n_Wrap(eof_ts(itheof,:), 0, 0)
;rc = regCoef_n(ts,var, 0, 0)
;copy_VarMeta(var(0,:,:),rc)
;tval = reshape(rc@tval,(/dimsizes(var(0,:,0)),dimsizes(var(0,0,:))/))
;copy_VarMeta(var(0,:,:),tval)
;delete(rc@tval)
;delete(rc@nptxy)
;delete(rc@rstd)
;delete(rc@yintercept)
;out->eof4 = rc
;out->tval4 = tval
;out->ts4 = ts
;out->var4 = eof@pcvar(itheof)
;delete(ts)
;delete(rc)
;delete(tval)
;
;eof4 = eof(itheof,:,:)
;copy_VarMeta(var(0,lat_idx,lon_idx), eof4)
;cc->eof4 = eof4
;cc->ts4 = eof_ts(itheof,:)
