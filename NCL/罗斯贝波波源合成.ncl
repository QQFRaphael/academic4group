load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; SON
season = "DJF"
idx_A = 11
idx_B = 12
idx_C = 13

yearstart = 1967
yearend = 2020
nyear = yearend - yearstart + 1

ttestval = 2.086

mylev = 200


ufile = addfile("uwnd.mon.mean.nc","r")
vfile = addfile("vwnd.mon.mean.nc","r")

us = ufile->uwnd
vs = vfile->vwnd

lat = ufile->lat
lon = ufile->lon
time = ufile->time
level = ufile->level
year=calendar_decode2(ufile->time,0)
year_idx=ind(year(:,0).ge.(yearstart).and.year(:,0).le.(yearend))
level_wind = ufile->level
lev_wind = ind(level_wind.eq.mylev)

u = us(year_idx,lev_wind,:,:)
v = vs(year_idx,lev_wind,:,:)

uA = u(idx_A::12,:,:)
uB = u(idx_B::12,:,:)
uC = u(idx_C::12,:,:)
u_season = (uA(0:nyear-2,:,:) + uB + uC) / 3.0 
copy_VarMeta(uC, u_season)

vA = v(idx_A::12,:,:)
vB = v(idx_B::12,:,:)
vC = v(idx_C::12,:,:)
v_season = (vA(0:nyear-2,:,:) + vB + vC) / 3.0 

pi = atan(1.0)*4.
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat)

rv = uv2vr_cfd(u_season,v_season,lat,lon,3)
av = rv + conform_dims(dimsizes(rv), f, 1)

div = uv2dv_cfd(u_season,v_season,lat,lon,3)

dv = dv2uvF_Wrap(div)
dv_u = dv(0,:,:,:)
dv_v = dv(1,:,:,:)

ss = -uv2dv_cfd(dv_u*av, dv_v*av, lat, lon, 3)
copy_VarMeta(vB,ss)

printVarSummary(ss)

idxL = (/1967,1968,1970,1972,1973,1976,1977,1979,1986,1990,1996,2006,2009,2010,2014/)-1967
idxH = (/1971,1998,1999,2005,2008,2011,2017/)-1967

ave1 = dim_avg_n_Wrap(ss(idxH,:,:), 0)
var1 = dim_stddev_n_Wrap(ss(idxH,:,:), 0)
s1 = dimsizes(idxH)

ave2 = dim_avg_n_Wrap(ss(idxL,:,:), 0)
var2 = dim_stddev_n_Wrap(ss(idxL,:,:), 0)
s2 =  dimsizes(idxL)


hgt_high_ave = ave1
hgt_high_var = var1
hgt_low_ave = ave2
hgt_low_var = var2

n_high = s1
n_low = s2

diff = ave1-ave2
tval = diff/sqrt( ( (n_high-1.)*hgt_high_var^2+(n_low-1.)*hgt_low_var^2)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
tval = abs(tval)
copy_VarMeta(ave1,diff)
copy_VarMeta(ave1,tval)

printVarSummary(diff)
printVarSummary(tval)


ab = shaeC(diff)
ssq = exp_tapershC(ab, 19.4, 2)
sss = shseC(ssq, dimsizes(lon))*1e11
printVarSummary(sss)
copy_VarMeta(diff, sss)

copy_VarMeta(diff, tval)

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=True
res@gsnMaximize=True


res@mpLimitMode = "LatLon"
res@mpMinLatF = 10
res@mpMaxLatF = 70
res@mpMaxLonF = 320
res@mpMinLonF = 60

res@mpCenterLonF=180

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-8,8,17)  ;(/-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3,3.5/)
;res@cnLevels=(/-2.25,-1.75,-1.25,-0.75,-0.25,0,0.25,0.75,1.25,1.75,2.25/)
;res@cnLevels=(/-4.5,-3.5,-2.5,-1.5,-0.5,0,0.5,1.5,2.5,3.5,4.5/)
;res@cnFillColors=(/2,4,5,6,7,9,0,0,11,12,13,14,15,16/)
;res@cnFillColors=(/2,18,34,50,66,82,88,0,0,143,145,147,149,150,160,170,180,190/)

res@lbOrientation="Vertical"

res@gsnLeftString=""
res@gsnRightString=""

wks = gsn_open_wks("eps", "djf")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")


map = gsn_csm_contour_map(wks, sss, res)



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.004
resshade@cnFillColor = "black"

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""



;tval_air=smth9_Wrap(tval_air, 0.5, -0.25, False)
map2 = gsn_csm_contour(wks, tval, resshade)

overlay(map,map2)



draw(map)
frame(wks)

