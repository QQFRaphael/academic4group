load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ts = asciiread("../EOF-1979-2010/ts3.txt", 32, "float")

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

tval1(:,ind(lon.gt.120.and.lon.lt.180))=0

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

wks=gsn_open_wks("eps","PC3-Reg-SST")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)




; Pacific Ocean

lat_low = -45.   
lat_high = -36.0 
lon_left = 205.  
lon_right = 225.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum6 = new(4,graphic)
do i = 0 , 3
    dum6(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave7 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("PACIFIC: " + escorc_n(ts,region_ave7, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

asciiwrite("PC3-Pacific.txt", dim_standardize_n_Wrap(region_ave7, 0, 0))



; Atlantic Ocean
lat_low = 60.   
lat_high = 70.0 
lon_left = 315.  
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
region_ave9 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("Atlantic: " + escorc_n(ts,region_ave9, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)



lat_low = 20.   
lat_high = 35.0 
lon_left = 315.  
lon_right = 345.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum10 = new(4,graphic)
do i = 0 , 3
    dum10(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave10 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;asciiwrite("PC1-Pacific.txt", dim_standardize_n_Wrap(region_ave2, 0, 0))
;print("Atlantic: " + escorc_n(ts,region_ave10, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

region_ave11 = (region_ave10 + region_ave9)/2.0
;print("Atlantic-All: " +escorc_n(ts,region_ave11, 0, 0))
asciiwrite("PC3-Atlantic.txt", dim_standardize_n_Wrap(region_ave11, 0, 0))



draw(wks)
frame(wks)
