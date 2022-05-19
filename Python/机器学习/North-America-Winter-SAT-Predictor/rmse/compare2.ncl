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
lr = flr->lr
lr1 = flr->lr1
lr2 = flr->lr2
lr3 = flr->lr3

fsvr = addfile("svr.nc", "r")
svr = fsvr->svr
svr1 = fsvr->svr1
svr2 = fsvr->svr2
svr3 = fsvr->svr3

fxgboost = addfile("xgboost.nc", "r")
xgboost = fxgboost->xgboost
xgboost1 = fxgboost->xgboost1
xgboost2 = fxgboost->xgboost2
xgboost3 = fxgboost->xgboost3

fens = addfile("ens.nc", "r")
ens_ML_MD = fens->ens_ML_MD
ens_ML = fens->ens_ML
ens_MD = fens->ens_MD

lr_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((lr-obs-273.15)^2,0)),0.5,-0.25,False)
lr1_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((lr1-obs-273.15)^2,0)),0.5,-0.25,False)
lr2_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((lr2-obs-273.15)^2,0)),0.5,-0.25,False)
lr3_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((lr3-obs-273.15)^2,0)),0.5,-0.25,False)

svr_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((svr-obs-273.15)^2,0)),0.5,-0.25,False)
svr1_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((svr1-obs-273.15)^2,0)),0.5,-0.25,False)
svr2_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((svr2-obs-273.15)^2,0)),0.5,-0.25,False)
svr3_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((svr3-obs-273.15)^2,0)),0.5,-0.25,False)

xgboost_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((xgboost-obs-273.15)^2,0)),0.5,-0.25,False)
xgboost1_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((xgboost1-obs-273.15)^2,0)),0.5,-0.25,False)
xgboost2_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((xgboost2-obs-273.15)^2,0)),0.5,-0.25,False)
xgboost3_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((xgboost3-obs-273.15)^2,0)),0.5,-0.25,False)



cancm4i_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((cancm4i-obs-273.15)^2,0)),0.5,-0.25,False)
gemnemo_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((gemnemo-obs-273.15)^2,0)),0.5,-0.25,False)

ens_ML_MD_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((ens_ML_MD-obs-273.15)^2,0)),0.5,-0.25,False)
ens_ML_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((ens_ML-obs-273.15)^2,0)),0.5,-0.25,False)
ens_MD_skill = smth9_Wrap(sqrt(dim_avg_n_Wrap((ens_MD-obs-273.15)^2,0)),0.5,-0.25,False)

copy_VarMeta(obs(0,:,:), cancm4i_skill)
copy_VarMeta(obs(0,:,:), gemnemo_skill)
copy_VarMeta(obs(0,:,:), lr_skill)
copy_VarMeta(obs(0,:,:), lr1_skill)
copy_VarMeta(obs(0,:,:), lr2_skill)
copy_VarMeta(obs(0,:,:), lr3_skill)
copy_VarMeta(obs(0,:,:), svr_skill)
copy_VarMeta(obs(0,:,:), svr1_skill)
copy_VarMeta(obs(0,:,:), svr2_skill)
copy_VarMeta(obs(0,:,:), svr3_skill)
copy_VarMeta(obs(0,:,:), xgboost_skill)
copy_VarMeta(obs(0,:,:), xgboost1_skill)
copy_VarMeta(obs(0,:,:), xgboost2_skill)
copy_VarMeta(obs(0,:,:), xgboost3_skill)
copy_VarMeta(obs(0,:,:), ens_ML_MD_skill)
copy_VarMeta(obs(0,:,:), ens_ML_skill)
copy_VarMeta(obs(0,:,:), ens_MD_skill)


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
;res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels=ispan(2,15,1)   ;fspan(-0.9,0.9,37)
res@cnLineThicknessF=2.0
res@cnLineLabelsOn=False

res2@cnFillOn=False
res2@cnLinesOn=True
;res2@cnLevelSelectionMode = "ExplicitLevels"
;res2@cnLevels=ispan(2,15,1)
res2@cnLineThicknessF=2.0
res2@cnLineLabelsOn=True
res2@cnInfoLabelOn=False


colors = "WhiteYellowOrangeRed"


wks = gsn_open_wks("eps", "cancm4i_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, cancm4i_skill, res)
mapp = gsn_csm_contour(wks, cancm4i_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "gemnemo_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, gemnemo_skill, res)
mapp = gsn_csm_contour(wks, gemnemo_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("eps", "lr-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr_skill, res)
mapp = gsn_csm_contour(wks, lr_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr1_skill, res)
mapp = gsn_csm_contour(wks, lr1_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr2-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr2_skill, res)
mapp = gsn_csm_contour(wks, lr2_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr3-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr3_skill, res)
mapp = gsn_csm_contour(wks, lr3_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr_skill, res)
mapp = gsn_csm_contour(wks, svr_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr1_skill, res)
mapp = gsn_csm_contour(wks, svr1_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr2-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr2_skill, res)
mapp = gsn_csm_contour(wks, svr2_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr3-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr3_skill, res)
mapp = gsn_csm_contour(wks, svr3_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost_skill, res)
mapp = gsn_csm_contour(wks, xgboost_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost1_skill, res)
mapp = gsn_csm_contour(wks, xgboost1_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost2-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost2_skill, res)
mapp = gsn_csm_contour(wks, xgboost2_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost3-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost3_skill, res)
mapp = gsn_csm_contour(wks, xgboost3_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "ens_ML_MD_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens_ML_MD_skill, res)
mapp = gsn_csm_contour(wks, ens_ML_MD_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "ens_ML_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens_ML_skill, res)
mapp = gsn_csm_contour(wks, ens_ML_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "ens_MD_skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens_MD_skill, res)
mapp = gsn_csm_contour(wks, ens_MD_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)
