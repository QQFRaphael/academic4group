load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ts = asciiread("../../feature-prepare/EOF-1979-2010/ts1.txt", 32, "float")

ff = addfile("hgt.mon.mean.nc","r")

ssts = ff->hgt
lat = ff->lat
lon = ff->lon
lev = ff->level

year_start = 1979
year_end = 2010

time = calendar_decode2(ff->time,0)
year_idx=ind(time(:,0).ge.year_start.and.time(:,0).le.year_end)
year_idx2=ind(time(:,0).ge.1979.and.time(:,0).le.2021)

lev_idx = ind(lev.eq.70)

sst_y = ssts(year_idx,lev_idx,:,:)
sst = (sst_y(8::12,:,:)+sst_y(9::12,:,:)+sst_y(10::12,:,:))/3.0
copy_VarMeta(sst_y(8::12,:,:), sst)

sst_y2 = ssts(year_idx2,lev_idx,:,:)
sst2 = (sst_y2(8::12,:,:)+sst_y2(9::12,:,:)+sst_y2(10::12,:,:))/3.0
copy_VarMeta(sst_y2(8::12,:,:), sst2)

rc1 = escorc_n(ts,sst, 0, 0)
delete(rc1@_FillValue)
rc1 = where(rc1.le.-100.or.rc1.ge.100, 0, rc1)
copy_VarMeta(sst(0,:,:),rc1)

tval1 = abs(rc1*sqrt(30/(1-rc1*rc1)))
copy_VarMeta(sst(0,:,:),tval1)

tval1(ind(lat.le.70),ind(lon.gt.270.and.lon.lt.330))=0

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


res@mpMinLatF = 30
;res@mpMaxLatF=75
;res@mpMinLonF=70
;res@mpMaxLonF=105

;res@mpCenterLonF = 180

;res@mpGridAndLimbOn        = True  
;res@pmTickMarkDisplayMode  = "Never"
;res@mpGridLatSpacingF      = 15
;res@mpGridLonSpacingF      = 15

;res@mpGridLineDashPattern  = 5

res@cnLineThicknessF = 3


res@lbOrientation="horizontal"

;res@gsnMaximize=True

res@gsnRightString=""
res@tiMainString=""

res@gsnPolar   = "NH"  

res@gsnPolarLabelFontHeightF =0.02

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

wks=gsn_open_wks("eps","PC1-Reg-ST")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)



lat_low = 45.   
lat_high = 60. 
lon_left = 31.  
lon_right = 60.
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

;print("SIC: " +escorc_n(ts,region_ave, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)


lat_low = 30.   
lat_high = 45. 
lon_left = 140.  
lon_right = 170.
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

;print("SIC: " +escorc_n(ts,region_ave2, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)


lat_low = 40.   
lat_high = 65. 
lon_left = 210.  
lon_right = 240.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 2.0                       ; thickness of lines
dum3 = new(4,graphic)
do i = 0 , 3
    dum3(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon = ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave3 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst2(:,idx_region_lat,idx_region_lon),2),1)

;print("SIC: " +escorc_n(ts,region_ave3, 0, 0))
delete(idx_region_lon)
delete(idx_region_lat)

rr = (region_ave+region_ave2+region_ave3)/3.0
;print("SIC-ALL: " +escorc_n(ts,rr, 0, 0))

asciiwrite("PC1-ST.txt", dim_standardize_n_Wrap(rr, 0, 0))



draw(wks)
frame(wks)
