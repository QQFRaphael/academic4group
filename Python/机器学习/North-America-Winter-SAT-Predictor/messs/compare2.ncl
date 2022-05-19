load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

fobs = addfile("obs.nc", "r")
obs = fobs->obs

fcan = addfile("cancm4i.nc", "r")
cancm4i = fcan->cancm4i

fgem = addfile("gemnemo.nc", "r")
gemnemo = fgem->gemnemo

flr = addfile("lr.nc", "r")
lr1 = flr->lr1

fsvr = addfile("svr.nc", "r")
svr1 = fsvr->svr1

fxgboost = addfile("xgboost.nc", "r")
xgboost1 = fxgboost->xgboost1


S = dim_variance_n_Wrap(obs, 0)
MSE_cj = (30.0/29.0)^2*S
MSE_cj = where(MSE_cj.le.1, 1, MSE_cj)
copy_VarMeta(S, MSE_cj)

lr1_MSE_j = dim_avg_n_Wrap((lr1-obs-273.15)^2,0)
svr1_MSE_j = dim_avg_n_Wrap((svr1-obs-273.15)^2,0)
xgboost1_MSE_j = dim_avg_n_Wrap((xgboost1-obs-273.15)^2,0)
cancm4i_MSE_j = dim_avg_n_Wrap((cancm4i-obs-273.15)^2,0)
gemnemo_MSE_j = dim_avg_n_Wrap((gemnemo-obs-273.15)^2,0)

copy_VarMeta(obs(0,:,:), lr1_MSE_j)
copy_VarMeta(obs(0,:,:), svr1_MSE_j)
copy_VarMeta(obs(0,:,:), xgboost1_MSE_j)
copy_VarMeta(obs(0,:,:), cancm4i_MSE_j)
copy_VarMeta(obs(0,:,:), gemnemo_MSE_j)


lr1_skill = 1-lr1_MSE_j/MSE_cj
svr1_skill = 1-svr1_MSE_j/MSE_cj
xgboost1_skill = 1-xgboost1_MSE_j/MSE_cj
cancm4i_skill = 1-cancm4i_MSE_j/MSE_cj
gemnemo_skill = 1-gemnemo_MSE_j/MSE_cj

copy_VarMeta(obs(0,:,:), cancm4i_skill)
copy_VarMeta(obs(0,:,:), gemnemo_skill)
copy_VarMeta(obs(0,:,:), lr1_skill)
copy_VarMeta(obs(0,:,:), svr1_skill)
copy_VarMeta(obs(0,:,:), xgboost1_skill)




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

res@lbOrientation="vertical"

res2 = res

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-7,7,29)    ;ispan(1,10,1)   ;fspan(-7,7,29)
res@cnLineThicknessF=2.0
res@cnLineLabelsOn=False

res2@cnFillOn=False
res2@cnLinesOn=True
res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels=fspan(-7,7,29)
res2@cnLineThicknessF=2.0
res2@cnLineLabelsOn=True
res2@cnInfoLabelOn=False


colors = "temp_19lev"
;colors = "WhiteYellowOrangeRed"

wks = gsn_open_wks("png", "cancm4i_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, cancm4i_skill, res)
;mapp = gsn_csm_contour(wks, cancm4i_skill, res2)
;overlay(map, mapp)

draw(map)
;delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("png", "gemnemo_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, gemnemo_skill, res)
;mapp = gsn_csm_contour(wks, gemnemo_skill, res2)
;overlay(map, mapp)

draw(map)
;delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("png", "lr1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr1_skill, res)
;mapp = gsn_csm_contour(wks, lr1_skill, res2)
;overlay(map, mapp)

draw(map)
;delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("png", "svr1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr1_skill, res)
;mapp = gsn_csm_contour(wks, svr1_skill, res2)
;overlay(map, mapp)

draw(map)
;delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("png", "xgboost1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost1_skill, res)
;mapp = gsn_csm_contour(wks, xgboost1_skill, res2)
;overlay(map, mapp)

draw(map)
;delete(mapp)
frame(wks)
delete(wks)

