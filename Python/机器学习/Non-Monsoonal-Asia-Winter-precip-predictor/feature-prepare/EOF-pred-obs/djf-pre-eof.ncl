load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

season="DJF"
idx_A = 11 
idx_B = 12
idx_C = 13

yearstart = 1979
yearend = 2011
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

var = varA(0:nyear-2,:,:)+varB+varC
copy_VarMeta(varB,var)

delete(year)
delete(year_idx)


yearstart = 2011
yearend = 2019
nyear = yearend - yearstart + 1

year=calendar_decode2(varfile->time,0)
year_idx=ind(year(:,0).ge.yearstart.and.year(:,0).le.yearend)

varss2 = vars(year_idx,:,:)

varA2 = varss2(idx_A::12,:,:)
varB2 = varss2(idx_B::12,:,:)
varC2 = varss2(idx_C::12,:,:)

var2 = varA2(0:nyear-2,:,:)+varB2+varC2
copy_VarMeta(varB2,var2)



neof   = 3

optEOF = True       
optEOF@jopt = 0

optETS = False

eof=eofunc_n_Wrap(NewCosWeight(var(:,lat_idx,lon_idx)),neof,optEOF,0)
eof_ts=eofunc_ts_n_Wrap(var(:,lat_idx,lon_idx),eof,optETS,0)

eof_ts2 = eofunc_ts_n_Wrap(var2(:,lat_idx,lon_idx),eof,optETS,0)

asciiwrite("PC1-pred-obs.txt", eof_ts2(0,:))
asciiwrite("PC2-pred-obs.txt", eof_ts2(1,:))
asciiwrite("PC3-pred-obs.txt", eof_ts2(2,:))
