load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


year_start = 1981
year_end = 2010

tfile = addfile("obs.nc","r")

tems = tfile->tmp(2:31,:,:)
lat = tfile->lat
lon = tfile->lon

ntime = year_end - year_start + 1

lat_idx = ind(lat.le.70.and.lat.ge.10)
lon_idx = ind(lon.ge.210.and.lon.le.320)

DJF = tems(:,lat_idx,lon_idx)

DJF_clim = dim_avg_n_Wrap(DJF,0)

DJF_stand = DJF - conform(DJF,DJF_clim,(/1,2/))
copy_VarMeta(DJF,DJF_stand)
DJF_stand = SqrtCosWeight(DJF_stand)
;DJF_stand = dim_standardize_n_Wrap(DJF_stand, 0, 0)
copy_VarMeta(DJF,DJF_stand)

neof = 3

optEOF = True
optEOF@jopt = 0
optETS = True
optETS@jopt = 0


eof = eofunc_n_Wrap(DJF_stand,neof,optEOF,0)
eof_ts = eofunc_ts_n_Wrap(DJF_stand,eof,optETS,0)

EOF1 = eof(0,:,:)
EOF2 = eof(1,:,:)
EOF3 = eof(2,:,:)
copy_VarMeta(DJF_stand(0,:,:),EOF1)
copy_VarMeta(DJF_stand(0,:,:),EOF2)
copy_VarMeta(DJF_stand(0,:,:),EOF3)

sig = eofunc_north(eof@eval, ntime, False)
print(sig)
print(eof@pcvar)

PC1_ori = eof_ts(0,:)
PC2_ori = eof_ts(1,:)
PC3_ori = eof_ts(2,:)

PC1_norm = dim_standardize_n_Wrap(PC1_ori,0,0)
PC2_norm = dim_standardize_n_Wrap(PC2_ori,0,0)
PC3_norm = dim_standardize_n_Wrap(PC3_ori,0,0)

rc1 = regCoef_n(PC1_norm,DJF, 0, 0)
copy_VarMeta(DJF(0,:,:),rc1)

tval1 = reshape(abs(rc1@tval),(/dimsizes(DJF(0,:,0)),dimsizes(DJF(0,0,:))/))
copy_VarMeta(DJF(0,:,:),tval1)

rc2 = regCoef_n(PC2_norm,DJF, 0, 0)
copy_VarMeta(DJF(0,:,:),rc2)

tval2 = reshape(abs(rc2@tval),(/dimsizes(DJF(0,:,0)),dimsizes(DJF(0,0,:))/))
copy_VarMeta(DJF(0,:,:),tval2)

rc3 = regCoef_n(PC3_norm,DJF, 0, 0)
copy_VarMeta(DJF(0,:,:),rc3)

tval3 = reshape(abs(rc3@tval),(/dimsizes(DJF(0,:,0)),dimsizes(DJF(0,0,:))/))
copy_VarMeta(DJF(0,:,:),tval3)

ttestval = 2.023

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=False

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-4,4,33) ;(/-1.2,-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1,1.2/)

res@mpLimitMode = "LatLon"
res@mpMinLatF = min(lat(lat_idx))
res@mpMaxLatF=max(lat(lat_idx))
res@mpMinLonF=min(lon(lon_idx))
res@mpMaxLonF=max(lon(lon_idx))

res@mpCenterLonF = 264.375

res@mpGridAndLimbOn        = False  
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
resshade@cnFillDotSizeF=0.007
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

rts           = True

rts@gsnScale  = True
rts@gsnDraw   = False
rts@gsnFrame  = False
rts@vpWidthF  = 0.75
rts@vpHeightF = 0.26
rts@tiYAxisString = ""
rts@gsnMaximize=True
rts@trYMinF   = -3.0        ; min value on y-axis
rts@trYMaxF   =  3.0        ; max value on y-axis
rts@tmXTOn=False
rts@tmYROn=False
rts@tmXBLabelFontHeightF=0.01
rts@tmYLLabelFontHeightF=0.01

rts2 = rts

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.
rts@gsnAboveYRefLineColor = "orange"
rts@gsnBelowYRefLineColor = "green3"
rts@gsnXYBarChartBarWidth = 0.55 

rts2@gsnXYBarChart         = False
rts2@gsnYRefLine           = 0.
;rts@gsnXYBarChartBarWidth = 0.7
rts2@xyLineThicknessF = 4.

snow1 = asciiread("../TP-SNOW/tpave_norm-PC1.txt", ntime-1, "float")
snow2 = asciiread("../TP-SNOW/tpave_norm-PC2.txt", ntime-1, "float")
snow3 = asciiread("../TP-SNOW/tpave_norm-PC3.txt", ntime-1, "float")

wks=gsn_open_wks("png","EOF1")
gsn_define_colormap(wks,"myblrd2")

res@gsnRightString=round(eof@pcvar(0)*100.0,1)/100.0+"%"
res@gsnLeftString="EOF1"

plot1 = gsn_csm_contour_map(wks,rc1,res)
plot1 = ColorNegDashZeroPosContour(plot1,"black",0,"black")
map1 = gsn_csm_contour(wks, tval1, resshade)
overlay(plot1,map1)

draw(plot1)
frame(wks)
delete(wks)


wks=gsn_open_wks("png","EOF2")
gsn_define_colormap(wks,"myblrd2")

res@gsnRightString=round(eof@pcvar(1)*100.0,1)/100.0+"%"
res@gsnLeftString="EOF2"

plot2 = gsn_csm_contour_map(wks,rc2,res)
plot2 = ColorNegDashZeroPosContour(plot2,"black",0,"black")
map2 = gsn_csm_contour(wks, tval2, resshade)
overlay(plot2,map2)

draw(plot2)
frame(wks)
delete(wks)

wks=gsn_open_wks("png","EOF3")
gsn_define_colormap(wks,"myblrd2")

res@gsnRightString=round(eof@pcvar(2)*100.0,1)/100.0+"%"
res@gsnLeftString="EOF3"

plot3 = gsn_csm_contour_map(wks,rc3,res)
plot3 = ColorNegDashZeroPosContour(plot3,"black",0,"black")
map3 = gsn_csm_contour(wks, tval3, resshade)
overlay(plot3,map3)

draw(plot3)
frame(wks)
delete(wks)

a=ispan(year_start,year_end,1)
printVarSummary(PC1_norm)
printVarSummary(a)

wks=gsn_open_wks("png","PC1")
pc1=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC1_norm,rts)
draw(wks)
frame(wks)
delete(wks)

wks=gsn_open_wks("png","PC2")
pc2=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC2_norm,rts)
draw(wks)
frame(wks)
delete(wks)

wks=gsn_open_wks("png","PC3")
pc3=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC3_norm,rts)
draw(wks)
frame(wks)
delete(wks)


system("rm -rf EOF.nc")
out = addfile("EOF.nc", "c")
out->DJF_clim = DJF_clim
out->DJF = DJF
out->EOF1 = EOF1
out->tval1 = tval1
out->var1 = eof@pcvar(0)
out->PC1_ori = PC1_ori
out->PC1_norm = PC1_norm

out->EOF2 = EOF2
out->tval2 = tval2
out->var2 = eof@pcvar(1)
out->PC2_ori = PC2_ori
out->PC2_norm = PC2_norm

out->EOF3 = EOF3
out->tval3 = tval3
out->var3 = eof@pcvar(2)
out->PC3_ori = PC3_ori
out->PC3_norm = PC3_norm

out->eof = eof

asciiwrite("PC1.txt",PC1_ori)
asciiwrite("PC2.txt",PC2_ori)
asciiwrite("PC3.txt",PC3_ori)

asciiwrite("PC1-norm.txt",PC1_norm)
asciiwrite("PC2-norm.txt",PC2_norm)
asciiwrite("PC3-norm.txt",PC3_norm)

