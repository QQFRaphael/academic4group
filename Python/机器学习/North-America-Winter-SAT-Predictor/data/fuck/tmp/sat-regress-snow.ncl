load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

year_start = 1979
year_end = 2018

tfile = addfile("CRU.nc","r")

tems = tfile->tmp
lat = tfile->lat
lon = tfile->lon
time = calendar_decode2(tfile->time,0)
year_idx=ind(time(:,0).ge.year_start.and.time(:,0).le.year_end)

ntime = year_end - year_start + 1

tem = tems(year_idx,:,:)
JAN = tem(0::12,:,:)
FEB = tem(1::12,:,:)
DEC= tem(11::12,:,:)

DJF = (DEC(0:ntime-2,:,:)+JAN(1:ntime-1,:,:)+FEB(1:ntime-1,:,:))/3.0
copy_VarMeta(DEC(0:ntime-2,:,:), DJF)

lat_idx = ind(lat.le.50.and.lat.ge.40)
lon_idx = ind(lon.ge.50.and.lon.le.90)

tmp_idx = dim_avg_n_Wrap(dim_avg_n_Wrap(DJF(:,lat_idx,lon_idx), 2),1)
tmp_idx = dim_standardize_n_Wrap(tmp_idx, 0, 0)
printVarSummary(tmp_idx)

f1 = addfile("autumn.nc", "r")
f2 = addfile("winter.nc", "r")

autumn = f1->snow
winter = f2->snow

rc1 = escorc_n(tmp_idx,autumn(0:38,:,:), 0, 0)
delete(rc1@_FillValue)
rc1 = where(rc1.eq.-32767, 0, rc1)
rc1 = where(rc1.gt.2, 0, rc1)
copy_VarMeta(autumn(0,:,:),rc1)

tval1 = abs(rc1*sqrt((39-2)/(1-rc1*rc1)))
copy_VarMeta(autumn(0,:,:),tval1)

rc2 = escorc_n(tmp_idx,winter, 0, 0)
delete(rc2@_FillValue)
rc2 = where(rc2.eq.-32767, 0, rc2)
rc2 = where(rc2.gt.2, 0, rc2)
copy_VarMeta(winter(0,:,:),rc2)

tval2 = abs(rc2*sqrt((39-2)/(1-rc2*rc2)))
copy_VarMeta(winter(0,:,:),tval2)


ttestval = 1.684  ;2.021

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=False

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-0.7,0.7,15) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)

res@mpLimitMode = "LatLon"
res@mpMinLatF = 10
res@mpMaxLatF=80
res@mpMinLonF=0
res@mpMaxLonF=180

;res@mpCenterLonF = 264.375

res@mpGridAndLimbOn        = True  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 10
res@mpGridLonSpacingF      = 10

res@mpGridLineDashPattern  = 5

res@cnLineThicknessF = 3


res@lbOrientation="Vertical"

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
resshade@cnFillDotSizeF=0.005
resshade@cnFillScaleF = 2.5

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""

wks=gsn_open_wks("eps","sat-regress-snow-autumn")
gsn_define_colormap(wks,"myblrd")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

f2s=asciiread("tibet_shape",(/2066,2/),"float")

poli=gsn_add_polyline(wks,map1,f2s(:,0),f2s(:,1),resp)

draw(plot1)
frame(wks)
delete(wks)

wks=gsn_open_wks("eps","sat-regress-snow-winter")
gsn_define_colormap(wks,"myblrd")

plot2 = gsn_csm_contour_map(wks,rc2,res)
map2 = gsn_csm_contour(wks, tval2, resshade)
overlay(plot2,map2)

poli2=gsn_add_polyline(wks,map2,f2s(:,0),f2s(:,1),resp)

draw(plot2)
frame(wks)