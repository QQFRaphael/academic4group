load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ts = asciiread("../EOF-1979-2010/ts1.txt", 32, "float")

ff = addfile("../../data/RUTGERS.snow.1967.2019.nc","r")

lat = ff->lat
lon = ff->lon

year_start = 1979
year_end = 2010

time = calendar_decode2(ff->time,0)
year_idx=ind(time(:,0).ge.year_start.and.time(:,0).le.year_end)

sc = ff->snowcover(year_idx,:,:)

snow = (sc(8::12,:,:)+sc(9::12,:,:)+sc(10::12,:,:))/3.0
copy_VarMeta(sc(0:31,:,:), snow)

rc1 = escorc_n(ts,snow(0:31,:,:), 0, 0)
delete(rc1@_FillValue)
rc1 = where(rc1.eq.-32767, 0, rc1)
copy_VarMeta(snow(0,:,:),rc1)
rc1 = where(rc1.gt.1.or.rc1.lt.-1, 0, rc1)
copy_VarMeta(snow(0,:,:),rc1)

tval1 = abs(rc1*sqrt(30/(1-rc1*rc1)))
copy_VarMeta(snow(0,:,:),tval1)

ttestval = 2.023

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=False

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-0.6,0.6,21) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)

res@mpLimitMode = "LatLon"
res@mpMinLatF = 25
res@mpMaxLatF=45
res@mpMinLonF=70
res@mpMaxLonF=105

;res@mpCenterLonF = 264.375

res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5

res@cnLineThicknessF = 3


res@lbOrientation="vertical"

;res@gsnMaximize=True

res@gsnRightString=""
res@tiMainString=""

res@tmXBLabelFontHeightF =0.017
res@tmYLLabelFontHeightF =0.017



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.003
resshade@cnFillScaleF = 1.0

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""

wks=gsn_open_wks("eps","PC1-Reg-SC")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

f2=asciiread("../../data/tibet_shape",(/2066,2/),"float")

poli=gsn_add_polyline(wks,map1,f2(:,0),f2(:,1),resp)



;lat_low = 32.   
;lat_high = 37. 
;lon_left = 75.  
;lon_right = 80.
;ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
;xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
;resc=True
;resc@gsLineColor      = "red"                     ; color of lines
;resc@gsLineThicknessF = 6.0                       ; thickness of lines
;dum1 = new(4,graphic)
;do i = 0 , 3
;    dum1(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
;end do
;idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
;idx_region_lon = ind(lon.ge.lon_left.and.lon.le.lon_right)
;region_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(snow(:,idx_region_lat,idx_region_lon),2),1)
;
;print("TP: " +escorc_n(ts,region_ave, 0, 0))
;delete(idx_region_lon)
;delete(idx_region_lat)
;
;asciiwrite("PC1-TP-SC.txt", dim_standardize_n_Wrap(region_ave, 0, 0))




draw(plot1)
frame(wks)
