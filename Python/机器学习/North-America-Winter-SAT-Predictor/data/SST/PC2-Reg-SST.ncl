load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../NA-SAT-EOF/EOF.nc","r")

ts = f->PC2_norm

ff = addfile("HadISST_sst.nc","r")

ssts = ff->sst
lat = ff->latitude
lon = lonFlip(ff->longitude)
lon(180:) = lon(180:)+360
year_start = 1979
year_end = 2018

time = calendar_decode2(ff->time,0)
year_idx=ind(time(:,0).ge.year_start.and.time(:,0).le.year_end)

sst_y = lonFlip(ssts(year_idx,:,:))
sst = (sst_y(8::12,:,:)+sst_y(9::12,:,:)+sst_y(10::12,:,:))/3.0
copy_VarMeta(sst_y(8::12,:,:), sst)

rc1 = escorc_n(ts,sst, 0, 0)
delete(rc1@_FillValue)
rc1 = where(rc1.le.-100.or.rc1.ge.100, 0, rc1)
copy_VarMeta(sst(0,:,:),rc1)

tval1 = abs(rc1*sqrt(38/(1-rc1*rc1)))
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
res@cnLevels=fspan(-1,1,11) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)


res@mpMinLatF = -15
res@mpMaxLatF=75
;res@mpMinLonF=70
;res@mpMaxLonF=105

res@mpCenterLonF = 180

res@mpGridAndLimbOn        = True  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 15
res@mpGridLonSpacingF      = 15

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
resshade@cnFillScaleF = 2.0

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""

wks=gsn_open_wks("eps","PC2-Reg-SST")
gsn_define_colormap(wks,"myblrd")

res@gsnRightString=""
res@gsnLeftString=""

plot1 = gsn_csm_contour_map(wks,rc1,res)
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)

;Indian Ocean
lat_low = -12.   
lat_high = 10.0 
lon_left = 45.  
lon_right = 75.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 6.0                       ; thickness of lines
dum1 = new(4,graphic)
do i = 0 , 3
    dum1(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(0:39,idx_region_lat,idx_region_lon),2),1)

asciiwrite("PC2-Indian.txt", dim_standardize_n_Wrap(region_ave, 0, 0))
print("INDIAN: " + escorc_n(ts,region_ave, 0, 0))

;Pacific Ocean 01
lat_low = -10.   
lat_high = 23.0 
lon_left = 140.  
lon_right = 165.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 6.0                       ; thickness of lines
dum2 = new(4,graphic)
do i = 0 , 3
    dum2(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat2 = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon2=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave2 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(0:39,idx_region_lat2,idx_region_lon2),2),1)

;Pacific Ocean 02
lat_low = -10.   
lat_high = 10.0 
lon_left = 195.  
lon_right = 280.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "blue"                     ; color of lines
resc@gsLineThicknessF = 6.0                       ; thickness of lines
dum3 = new(4,graphic)
do i = 0 , 3
    dum3(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat3 = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon3=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave3 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(0:39,idx_region_lat3,idx_region_lon3),2),1)

sst_idx = (region_ave2-region_ave3)/2.0
asciiwrite("PC2-Pacific.txt", dim_standardize_n_Wrap(sst_idx, 0, 0))

print("PACIFIC: "+escorc_n(ts,sst_idx, 0, 0))


;Atlantic Ocean 01
lat_low = -10.   
lat_high = 5.0 
lon_left = 330.  
lon_right = 360.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 6.0                       ; thickness of lines
dum4 = new(4,graphic)
do i = 0 , 3
    dum4(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat4 = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon4=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave4 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(0:39,idx_region_lat4,idx_region_lon4),2),1)


;Atlantic Ocean 02
lat_low = -10.   
lat_high = 5.0 
lon_left = 0.  
lon_right = 15.
ypts = (/ lat_low,  lat_low, lat_high ,  lat_high, lat_low/)
xpts = (/lon_left, lon_right, lon_right, lon_left, lon_left/)
resc=True
resc@gsLineColor      = "red"                     ; color of lines
resc@gsLineThicknessF = 6.0                       ; thickness of lines
dum5 = new(4,graphic)
do i = 0 , 3
    dum5(i)=gsn_add_polyline(wks,plot1,xpts(i:i+1),ypts(i:i+1),resc)
end do
idx_region_lat5 = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon5=ind(lon.ge.lon_left.and.lon.le.lon_right)
region_ave5 = dim_avg_n_Wrap(dim_avg_n_Wrap(sst(0:39,idx_region_lat5,idx_region_lon5),2),1)

sst_idx = (region_ave4+region_ave5)/2.0
;asciiwrite("tpave-PC1.txt", region_ave)
asciiwrite("PC2-Atlantic.txt", dim_standardize_n_Wrap(sst_idx, 0, 0))

print("ATLANTIC: "+escorc_n(ts,sst_idx, 0, 0))

sst_idx = (region_ave-region_ave2+region_ave3-region_ave4-region_ave5)/5.0
asciiwrite("PC2-ALL.txt", dim_standardize_n_Wrap(sst_idx, 0, 0))

print("ALL: " + escorc_n(ts,sst_idx, 0, 0))

draw(wks)
frame(wks)
