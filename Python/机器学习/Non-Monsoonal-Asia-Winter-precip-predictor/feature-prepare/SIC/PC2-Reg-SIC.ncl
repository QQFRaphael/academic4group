load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ts = asciiread("../EOF-1979-2010/ts2.txt", 32, "float")

ff = addfile("../../data/HadISST_ice.1870.2019.nc","r")

ssts = ff->sic
lat = ff->latitude
lon = ff->longitude
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


res@mpMinLatF = 60
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

wks=gsn_open_wks("eps","PC2-Reg-SIC")
gsn_define_colormap(wks,"BlueWhiteOrangeRed")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)



;lat_low = 86.   
;lat_high = 90. 
;lon_left = -90.  
;lon_right = 90.
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
;region_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(:,idx_region_lat,idx_region_lon),2),1)
;
;print("SIC: " +escorc_n(ts,region_ave, 0, 0))
;delete(idx_region_lon)
;delete(idx_region_lat)

lat_low = 70.   
lat_high = 75. 
lon_left = 160.  
lon_right = 180.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
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

;region_ave3 = (region_ave + region_ave2)/2.0
;print("SIC-ALL: " +escorc_n(ts,region_ave3, 0, 0))

asciiwrite("PC2-SIC.txt", dim_standardize_n_Wrap(region_ave2,0,0))

draw(wks)
frame(wks)
