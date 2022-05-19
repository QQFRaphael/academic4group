load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ts = asciiread("../EOF-1979-2010/ts1.txt", 32, "float")

ff = addfile("../../data/HadISST_sst.1870.2019.nc","r")

ssts = ff->sst
lat = ff->latitude
lon = lonFlip(ff->longitude)
lon(180:) = lon(180:)+360
year_start = 1979
year_end = 2010

time = calendar_decode2(ff->time,0)
year_idx=ind(time(:,0).ge.year_start.and.time(:,0).le.year_end)

year_idx2=ind(time(:,0).ge.1979.and.time(:,0).le.2018)

sst_y = lonFlip(ssts(year_idx,:,:))
sst = (sst_y(8::12,:,:)+sst_y(9::12,:,:)+sst_y(10::12,:,:))/3.0
copy_VarMeta(sst_y(8::12,:,:), sst)

sst_y2 = lonFlip(ssts(year_idx2,:,:))
sst2 = (sst_y2(8::12,:,:)+sst_y2(9::12,:,:)+sst_y2(10::12,:,:))/3.0
copy_VarMeta(sst_y2(8::12,:,:), sst2)

rc1 = escorc_n(ts,sst, 0, 0)
delete(rc1@_FillValue)
rc1 = where(rc1.le.-100.or.rc1.ge.100, 0, rc1)
copy_VarMeta(sst(0,:,:),rc1)

tval1 = abs(rc1*sqrt(30/(1-rc1*rc1)))
copy_VarMeta(sst(0,:,:),tval1)

tval1(ind(lat.gt.45),:)=0.0

tval1(ind(lat.gt.10.and.lat.lt.30),ind(lon.gt.300.and.lon.lt.330))=0

tval1(ind(lat.gt.-40.and.lat.lt.-20),ind(lon.gt.210.and.lon.lt.240))=0

ttestval = 2.023

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=True

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-0.6,0.6,21) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)


res@mpMinLatF = -45
res@mpMaxLatF=75
;res@mpMinLonF=70
;res@mpMaxLonF=105

res@mpCenterLonF = 180

res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Never"
res@mpGridLatSpacingF      = 15
res@mpGridLonSpacingF      = 15

res@mpGridLineDashPattern  = 5

res@cnLineThicknessF = 3


res@lbOrientation="vertical"

;res@gsnMaximize=True

res@gsnRightString=""
res@tiMainString=""

res@tmXBLabelFontHeightF =0.015
res@tmYLLabelFontHeightF =0.015

resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.003
resshade@cnFillScaleF = 1.

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""

wks=gsn_open_wks("eps","PC1-Reg-SST")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)


;Indian Ocean
lat_low = -35.   
lat_high = -15. 
lon_left = 50.  
lon_right = 80.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum1 = new(4,graphic)
do i = 0 , 3
    dum1(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon = ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Indian.txt", dim_standardize_n_Wrap(region_ave, 0, 0))
;print("INDIAN: " +escorc_n(ts,region_ave, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

lat_low = 10.   
lat_high = 20. 
lon_left = 60.  
lon_right = 90.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum2 = new(4,graphic)
do i = 0 , 3
    dum2(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon = ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave2 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Indian.txt", dim_standardize_n_Wrap(region_ave, 0, 0))
;print("INDIAN: " +escorc_n(ts,region_ave2, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

lat_low = -40.   
lat_high = -10. 
lon_left = 95.  
lon_right = 120.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum3 = new(4,graphic)
do i = 0 , 3
    dum3(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon = ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave3 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Indian.txt", dim_standardize_n_Wrap(region_ave, 0, 0))
;print("INDIAN: " +escorc_n(ts,region_ave3, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

region_ave4 = (region_ave3 - region_ave - region_ave2)/3.0
;print("INDIAN-All: " +escorc_n(ts,region_ave4, 0, 0))
asciiwrite("PC1-Indian.txt", dim_standardize_n_Wrap(region_ave4,0,0))

test_ave = region_ave3 / 2.0 - region_ave/4.0 - region_ave/4.0
print("INDIAN-TESTTTTTTT: " +escorc_n(ts,test_ave(0:31), 0, 0))


; Pacific Ocean
lat_low = -10.  ;0.   
lat_high = 15.0 
lon_left = 120.  
lon_right = 160. ;150
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum4 = new(4,graphic)
do i = 0 , 3
    dum4(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave5 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("PACIFIC: " + escorc_n(ts,region_ave5, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

lat_low = -10.   
lat_high = 10.0 
lon_left = 165.  
lon_right = 250.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum5 = new(4,graphic)
do i = 0 , 3
    dum5(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave6 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("PACIFIC: " + escorc_n(ts,region_ave6, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)


lat_low = 30.   
lat_high = 45.0 
lon_left = 180.  
lon_right = 210.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum7 = new(4,graphic)
do i = 0 , 3
    dum7(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave8 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("PACIFIC: " + escorc_n(ts,region_ave8, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

region_ave9 = (region_ave5 + region_ave8 - region_ave6)/3.0
;print("PACIFIC-All: " +escorc_n(ts,region_ave9, 0, 0))
asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave9,0,0))

test_ave = region_ave5/4.0 + region_ave8/4.0 - region_ave6/2.0
print("PACIFIC-TESTTTTTTT: " +escorc_n(ts,test_ave(0:31), 0, 0))




; Atlantic Ocean

lat_low = -32.   
lat_high = -20.0 
lon_left = 310.  
lon_right = 345.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum9 = new(4,graphic)
do i = 0 , 3
    dum9(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave11 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("Atlantic: " + escorc_n(ts,region_ave11, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

asciiwrite("PC1-Atlantic.txt", dim_standardize_n_Wrap(region_ave11,0,0))



draw(wks)
frame(wks)
