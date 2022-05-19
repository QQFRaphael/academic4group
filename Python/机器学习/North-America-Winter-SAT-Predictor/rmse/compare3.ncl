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

diff_lr1_MD = lr1_skill - ens_MD_skill
diff_svr1_MD = svr1_skill - ens_MD_skill
diff_xg1_MD = xgboost1_skill - ens_MD_skill
copy_VarMeta(obs(0,:,:), diff_lr1_MD)
copy_VarMeta(obs(0,:,:), diff_svr1_MD)
copy_VarMeta(obs(0,:,:), diff_xg1_MD)

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
res3 = res

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-0.9,0.9,37)
res@cnLineThicknessF=2.0
res@cnLineLabelsOn=False

res2@cnFillOn=False
res2@cnLinesOn=True
res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels=(/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0/)
res2@cnLineThicknessF=2.0
res2@cnLineLabelsOn=True
res2@cnInfoLabelOn=False

res3@cnFillOn=True
res3@cnLinesOn=False
res3@cnLevelSelectionMode = "ExplicitLevels"
res3@cnLevels=fspan(-2,2,21)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False
res3@lbOrientation="horizontal"
res3@cnFillColors=(/2,10,18,26,34,42,50,58,66,82,0,0,143,146,149,152,155,158,161,164,167,170,173,176/)

colors = "BlueWhiteOrangeRed"
cc2 = "BlueWhiteOrangeRed"

wks = gsn_open_wks("eps", "diff_lr1_MD")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_lr1_MD, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr1_MD")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_svr1_MD, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xg1_MD")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_xg1_MD, res3)
draw(map)
frame(wks)
delete(wks)