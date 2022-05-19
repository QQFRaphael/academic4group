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

varfile = addfile("../XGBoost/XGBoost.nc","r")

var = varfile->model


f1 = addfile("../../data/cru_ts4.04.1901.2019.pre.dat.nc","r")

year=calendar_decode2(f1->time,0)
year_idx=ind(year(:,0).ge.yearstart.and.year(:,0).le.yearend)

vars = f1->pre

lat=f1->lat
lon=f1->lon

lat_idx=ind(lat.ge.30.and.lat.le.60)
lon_idx=ind(lon.ge.30.and.lon.le.105)


varss = vars(year_idx,lat_idx,lon_idx)

varA = varss(idx_A::12,:,:)
varB = varss(idx_B::12,:,:)
varC = varss(idx_C::12,:,:)

clim = varA(0:nyear-2,:,:)+varB+varC
copy_VarMeta(varB,clim)

var2 = var
var = var+conform(var,dim_avg_n_Wrap(clim,0),(/1,2/))
var = linmsg(var,-1)
copy_VarMeta(var2,var)



res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnMaximize=True
res@gsnAddCyclic = False

;res@mpCenterLonF = 265


res@gsnLeftString=""
res@gsnRightString=""

res@cnFillDrawOrder="PreDraw"
res@cnLineDrawOrder="PreDraw"


res@mpMinLatF              =  30
  res@mpMaxLatF              =  60
  res@mpMinLonF              = 30
  res@mpMaxLonF              = 105

  res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Always"
res@tmXBLabelFontHeightF =0.025
res@tmYLLabelFontHeightF =0.025

res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5

res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpOceanFillColor = 0
res@mpOutlineOn = True
res@mpMaskAreaSpecifiers = (/"Land"/)

res@mpInlandWaterFillColor = 0

res@lbOrientation="vertical"



res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(10,250,10)
res@cnLineThicknessF=2.0
res@cnLineLabelsOn=False


colors = "MPL_RdYlGn"

resp = True
resp@gsLineColor      = "green2" ; polylines color
resp@gsLineThicknessF = 4    ; polylines thickness

f2=asciiread("tibet_shape",(/2066,2/),"float")



do ii = 2011,2020

wks = gsn_open_wks("eps", "xg-"+ii)
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, var(ii-2011,:,:), res)

poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
frame(wks)
delete(wks)

end do





