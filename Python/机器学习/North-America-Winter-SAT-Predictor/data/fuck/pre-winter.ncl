load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

n = 39

ts1 = asciiread("winter2.txt", n, "float")
ts2 = asciiread("winter3.txt", n, "float")
ts = dim_standardize_n_Wrap((ts1 + ts2) / 2.0, 0, 0) 

ff = addfile("pre-winter.nc","r")

snow = ff->tmp
lat = ff->lat
lon = ff->lon

rc1 = escorc_n(ts,snow, 0, 0)
;delete(rc1@_FillValue)
;rc1 = where(rc1.eq.-32767, 0, rc1)
copy_VarMeta(snow(0,:,:),rc1)

tval1 = abs(rc1*sqrt((n-2)/(1-rc1*rc1)))
copy_VarMeta(snow(0,:,:),tval1)

ttestval = 2.021

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=False

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-1,1,11) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)

res@mpLimitMode = "LatLon"
res@mpMinLatF = 10
res@mpMaxLatF=80
res@mpMinLonF=0
res@mpMaxLonF=180

;res@mpCenterLonF = 264.375

res@mpGridAndLimbOn        = True  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5

res@cnLineThicknessF = 3


res@lbOrientation="vertical"

;res@gsnMaximize=True

res@gsnRightString=""
res@tiMainString=""



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.008
resshade@cnFillScaleF = 3.5

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""

wks=gsn_open_wks("eps","pre-winter")
gsn_define_colormap(wks,"myblrd")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

f2=asciiread("tibet_shape",(/2066,2/),"float")

poli=gsn_add_polyline(wks,map1,f2(:,0),f2(:,1),resp)

draw(plot1)
frame(wks)
