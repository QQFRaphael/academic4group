load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


yearstart = 1995
yearend = 2014
nyear = yearend - yearstart + 1 

mylev = 200 

indicesfile = addfile("./data/indices.nc","r")

start_year = indicesfile->start_year
end_year = indicesfile->end_year

aodata = indicesfile->ao(yearstart-start_year:yearend-start_year,:)
naodata = indicesfile->nao(yearstart-start_year:yearend-start_year,:)

n1 = nyear
n2 = nyear-1

ttestval = 2.093

ao_jan = aodata(:,0)
ao_feb = aodata(:,1)
ao_mar = aodata(:,2)
ao_apr = aodata(:,3)
ao_may = aodata(:,4)
ao_jun = aodata(:,5)
ao_jul = aodata(:,6)
ao_aug = aodata(:,7)
ao_sep = aodata(:,8)
ao_oct = aodata(:,9)
ao_nov = aodata(:,10)
ao_dec = aodata(:,11)

nao_jan = naodata(:,0)
nao_feb = naodata(:,1)
nao_mar = naodata(:,2)
nao_apr = naodata(:,3)
nao_may = naodata(:,4)
nao_jun = naodata(:,5)
nao_jul = naodata(:,6)
nao_aug = naodata(:,7)
nao_sep = naodata(:,8)
nao_oct = naodata(:,9)
nao_nov = naodata(:,10)
nao_dec = naodata(:,11)

ao = (ao_oct + ao_nov + ao_dec) / 3.0 

snow = asciiread("../cal_interannual/after.txt",(/nyear/),"float")


season = "OND"
idx_A = 9
idx_B = 10
idx_C = 11

hgtfile = addfile("../ncfile/ncep2nc/hgt.mon.mean.nc","r")

hgts = short2flt(hgtfile->hgt)


lat_wind = hgtfile->lat
lon_wind = hgtfile->lon
year=calendar_decode2(hgtfile->time,0)
year_idx=ind(year(:,0).ge.(yearstart).and.year(:,0).le.(yearend))
level_wind = hgtfile->level
lev_wind = ind(level_wind.eq.mylev)

hgt = hgts(year_idx,lev_wind,:,:)

hgt_season = (hgt(idx_A::12,:,:) + hgt(idx_B::12,:,:) + hgt(idx_C::12,:,:)) / 3.0

printVarSummary(ao)
printVarSummary(snow)
printVarSummary(hgt_season)
;rc_hgt = regCoef_n(ao, hgt_season, 0, 0)

;tval_hgt = reshape(abs(rc_hgt@tval),(/dimsizes(rc_hgt(:,0)),dimsizes(rc_hgt(0,:))/))

;copy_VarMeta(hgt(0,:,:),rc_hgt)

;copy_VarMeta(hgt(0,:,:),tval_hgt)


X  = new ( (/20,2/), "float" )   
X(:,0) = dim_standardize_n_Wrap(ao,1,0)
X(:,1) = snow

beta_ao = hgt_season(0,:,:)
beta_snow = hgt_season(0,:,:)
tval_ao = hgt_season(0,:,:)
tval_snow = hgt_season(0,:,:)

opt=True
opt@print_data  = False
opt@print_anova = False

do ii = 0,72
do jj = 0,143
beta = reg_multlin_stats(hgt_season(:,ii,jj),X,opt)
beta_ao(ii,jj)=beta(1)
beta_snow(ii,jj)=beta(2)
val = beta@tval
tval_ao(ii,jj) = val(1)
tval_snow(ii,jj) = val(2)
end do
end do


copy_VarMeta(hgt(0,:,:),beta_snow)
copy_VarMeta(hgt(0,:,:),beta_ao)
copy_VarMeta(hgt(0,:,:),tval_ao)
copy_VarMeta(hgt(0,:,:),tval_snow)





res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=True
res@gsnMaximize=True


res@mpLimitMode = "LatLon"
res@mpMinLatF = 0

res@mpCenterLonF=180

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=(/-50,-40,-30,-20,-10,0,10,20,30,40,50/)
res@cnFillColors=(/2,5,6,7,8,0,0,13,14,15,16,17/)

res@lbOrientation="Vertical"

res@gsnLeftString=""
res@gsnRightString=""

wks = gsn_open_wks("pdf", "PReg-AO")
gsn_define_colormap(wks,"BlueDarkRed18")


map = gsn_csm_contour_map(wks, beta_ao, res)


resp = True
resp@gsLineColor      = "gray" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

f=asciiread("../tibet_shape",(/2066,2/),"float")
poli=gsn_add_polyline(wks,map,f(:,0),f(:,1),resp)



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.005
resshade@cnFillColor="green"

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=True

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""


map2 = gsn_csm_contour(wks, tval_ao, resshade)


overlay(map,map2)

tibet_lat_low = 29.0
tibet_lat_high = 34.0
tibet_lon_left = 90.0
tibet_lon_right = 100.0
ypts = (/tibet_lat_low,  tibet_lat_low, tibet_lat_high ,  tibet_lat_high, tibet_lat_low/)
xpts = (/tibet_lon_left, tibet_lon_right, tibet_lon_right, tibet_lon_left, tibet_lon_left/)
resc=True
resc@gsLineColor      = "red4"                     ; color of lines
resc@gsLineThicknessF = 3.0                       ; thickness of lines
dum5 = new(4,graphic)
dum6 = new(4,graphic)
dum7 = new(4,graphic)
dum8 = new(4,graphic)
do i = 0 , 3
  dum5(i)=gsn_add_polyline(wks,map,xpts(i:i+1),ypts(i:i+1),resc)
  dum6(i)=gsn_add_polyline(wks,map,xpts(i:i+1),ypts(i:i+1),resc)
  dum7(i)=gsn_add_polyline(wks,map,xpts(i:i+1),ypts(i:i+1),resc)
  dum8(i)=gsn_add_polyline(wks,map,xpts(i:i+1),ypts(i:i+1),resc)
end do

draw(map)
frame(wks)








