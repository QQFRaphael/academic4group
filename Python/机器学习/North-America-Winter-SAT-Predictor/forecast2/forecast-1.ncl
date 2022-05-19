load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/OBS/obs.nc","r")

obs = f->tmp(38,:,:)
lat_obs = f->lat
lon_obs = f->lon

nyear = 39

fff = addfile("../data/NA-SAT-EOF/EOF.nc","r")

latml = fff->lat(::-1)
lonml = fff->lon

EOF1 = linint2_Wrap(lonml,latml,fff->EOF1(::-1,:),True,lon_obs,lat_obs,0)
EOF2 = linint2_Wrap(lonml,latml,fff->EOF2(::-1,:),True,lon_obs,lat_obs,0)
EOF3 = linint2_Wrap(lonml,latml,fff->EOF3(::-1,:),True,lon_obs,lat_obs,0)

clim = linint2_Wrap(lonml,latml,fff->DJF_clim(::-1,:),True,lon_obs,lat_obs,0)

lr = EOF1*-16.37439739 + EOF2*14.72743821 + EOF3*3.3106987 + clim - 273.15
copy_VarMeta(obs,lr)

;svr = EOF1*-15.93441177 + EOF2*7.31074083 + EOF3*0.14934517 + clim - 273.15
svr = EOF1*-4.68779743 + EOF2*21.44366731 + EOF3*-0.09298924 + clim - 273.15
copy_VarMeta(obs,svr)

;xgboost = EOF1*-25.193092 + EOF2*-0.13458645 + EOF3*-3.1693282 + clim - 273.15
;xgboost = EOF1*-15.885651 + EOF2*-1.8763278 + EOF3*-3.394196 + clim - 273.15
xgboost = EOF1*-1.8525279 + EOF2*6.7592134 + EOF3*0.87482786 + clim - 273.15
copy_VarMeta(obs,xgboost)

diff_lr = lr-obs
diff_svr = svr-obs
diff_xgboost = xgboost-obs
copy_VarMeta(obs,diff_lr)
copy_VarMeta(obs,diff_svr)
copy_VarMeta(obs,diff_xgboost)

rmse_svr_lr = sqrt(diff_svr*diff_svr) - sqrt(diff_lr*diff_lr)
rmse_xg_lr = sqrt(diff_xgboost*diff_xgboost) - sqrt(diff_lr*diff_lr)
copy_VarMeta(obs,rmse_svr_lr)
copy_VarMeta(obs,rmse_xg_lr)

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnMaximize=True
res@gsnAddCyclic = False

res@mpCenterLonF = 265


res@mpMinLatF              =  10
  res@mpMaxLatF              =  70
  res@mpMinLonF              = 210
  res@mpMaxLonF              = 320

  res@mpGridAndLimbOn        = True  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5

res@gsnLeftString=""
res@gsnRightString=""

res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpOceanFillColor = 0
res@mpOutlineOn = True
res@mpMaskAreaSpecifiers = (/"Land"/)
res@cnFillDrawOrder="PreDraw"
res@cnLineDrawOrder="PreDraw"
res@mpInlandWaterFillColor = 0

res@lbOrientation="horizontal"

res2 = res
res3 = res
res4 = res

res@cnFillOn=True
res@cnLinesOn=True
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(-28,28,4)
res@cnLineThicknessF=2.0
res@cnLineLabelsOn=False

res2@cnFillOn=False
res2@cnLinesOn=True
;res2@cnLevelSelectionMode = "ExplicitLevels"
;res2@cnLevels=(/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0/)
res2@cnLineThicknessF=2.0
res2@cnLineLabelsOn=True
res2@cnInfoLabelOn=False

res3@cnFillOn=True
res3@cnLinesOn=False
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLevels=fspan(-12,12,25)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False
res3@lbOrientation="horizontal"
;res3@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)

res4@cnFillOn=True
res4@cnLinesOn=False
res4@cnLevelSelectionMode = "ExplicitLevels"
res4@cnLevels=fspan(-1,1,21)
res4@cnLineThicknessF=2.0
res4@cnLineLabelsOn=False
res4@lbOrientation="horizontal"
;res3@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)

colors = "BlueWhiteOrangeRed"
cc2 = "BlueDarkRed18"

type = "eps"

wks = gsn_open_wks(type, "lr")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr, res)

draw(map)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "svr")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr, res)

draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "xgboost")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost, res)

draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "obs")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, obs, res)

draw(map)
frame(wks)
delete(wks)

lrcorr = escorc_n(ndtooned(lr),ndtooned(obs),0,0)
svrcorr = escorc_n(ndtooned(svr),ndtooned(obs),0,0)
xgboostcorr = escorc_n(ndtooned(xgboost),ndtooned(obs),0,0)

print(lrcorr)
print(svrcorr)
print(xgboostcorr)

lrrmse = dim_avg_n_Wrap(ndtooned((lr-obs)^2),0)
svrrmse = dim_avg_n_Wrap(ndtooned((svr-obs)^2),0)
xgboostrmse = dim_avg_n_Wrap(ndtooned((xgboost-obs)^2),0)

print(lrrmse)
print(svrrmse)
print(xgboostrmse)

wks = gsn_open_wks(type, "diff_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_svr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_svr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_xgboost")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_xgboost, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_svr_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, rmse_svr_lr, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_xg_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, rmse_xg_lr, res4)
draw(map)
frame(wks)
delete(wks)
