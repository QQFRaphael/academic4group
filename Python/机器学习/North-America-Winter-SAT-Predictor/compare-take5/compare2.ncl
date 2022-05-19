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

cancm4i_skill = escorc_n(obs, cancm4i, 0, 0)
gemnemo_skill = escorc_n(obs, gemnemo, 0, 0)
lr_skill = escorc_n(obs, lr, 0, 0)
lr1_skill = escorc_n(obs, lr1, 0, 0)
lr2_skill = escorc_n(obs, lr2, 0, 0)
lr3_skill = escorc_n(obs, lr3, 0, 0)
svr_skill = escorc_n(obs, svr, 0, 0)
svr1_skill = escorc_n(obs, svr1, 0, 0)
svr2_skill = escorc_n(obs, svr2, 0, 0)
svr3_skill = escorc_n(obs, svr3, 0, 0)
xgboost_skill = escorc_n(obs, xgboost, 0, 0)
xgboost1_skill = escorc_n(obs, xgboost1, 0, 0)
xgboost2_skill = escorc_n(obs, xgboost2, 0, 0)
xgboost3_skill = escorc_n(obs, xgboost3, 0, 0)
ens_ML_MD_skill = escorc_n(obs, ens_ML_MD, 0, 0)
ens_ML_skill = escorc_n(obs, ens_ML, 0, 0)
ens_MD_skill = escorc_n(obs, ens_MD, 0, 0)

print(dim_avg_n_Wrap(dim_avg_n_Wrap(lr_skill,1),0))
print(dim_avg_n_Wrap(dim_avg_n_Wrap(svr_skill,1),0))
print(dim_avg_n_Wrap(dim_avg_n_Wrap(xgboost_skill,1),0))

diff_ens_md = ens_ML_MD_skill - ens_MD_skill
diff_ml_md = ens_ML_skill - ens_MD_skill

diff_svr_lr = svr_skill - lr_skill
diff_xgboost_lr = xgboost_skill - lr_skill

diff_svr_cancm4i = svr_skill - cancm4i_skill
diff_svr_gemnemo = svr_skill - gemnemo_skill

diff_xgboost_cancm4i = xgboost_skill - cancm4i_skill
diff_xgboost_gemnemo = xgboost_skill - gemnemo_skill

diff_lr_cancm4i = lr_skill - cancm4i_skill
diff_lr_gemnemo = lr_skill - gemnemo_skill


diff1_svr_lr = svr1_skill - lr1_skill
diff2_svr_lr = svr2_skill - lr2_skill
diff3_svr_lr = svr3_skill - lr3_skill
diff1_xgboost_lr = xgboost1_skill - lr1_skill
diff2_xgboost_lr = xgboost2_skill - lr2_skill
diff3_xgboost_lr = xgboost3_skill - lr3_skill

copy_VarMeta(obs(0,:,:), diff_ens_md)
copy_VarMeta(obs(0,:,:), diff_ml_md)

copy_VarMeta(obs(0,:,:), diff_svr_cancm4i)
copy_VarMeta(obs(0,:,:), diff_svr_gemnemo)
copy_VarMeta(obs(0,:,:), diff_xgboost_cancm4i)
copy_VarMeta(obs(0,:,:), diff_xgboost_gemnemo)
copy_VarMeta(obs(0,:,:), diff_lr_cancm4i)
copy_VarMeta(obs(0,:,:), diff_lr_gemnemo)


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
copy_VarMeta(obs(0,:,:), diff_svr_lr)
copy_VarMeta(obs(0,:,:), diff_xgboost_lr)
copy_VarMeta(obs(0,:,:), diff1_svr_lr)
copy_VarMeta(obs(0,:,:), diff2_svr_lr)
copy_VarMeta(obs(0,:,:), diff3_svr_lr)
copy_VarMeta(obs(0,:,:), diff1_xgboost_lr)
copy_VarMeta(obs(0,:,:), diff2_xgboost_lr)
copy_VarMeta(obs(0,:,:), diff3_xgboost_lr)

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
res3@cnLevels=fspan(-0.5,0.5,11)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False
res3@lbOrientation="horizontal"
res3@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)

colors = "BlueWhiteOrangeRed"
cc2 = "BlueDarkRed18"

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

wks = gsn_open_wks("eps", "diff_svr_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_svr_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_xgboost_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff1_svr_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff1_svr_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff2_svr_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff2_svr_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff3_svr_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff3_svr_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff1_xgboost_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff1_xgboost_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff2_xgboost_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff2_xgboost_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff3_xgboost_lr")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff3_xgboost_lr, res3)
draw(map)
frame(wks)
delete(wks)


wks = gsn_open_wks("eps", "diff_svr_cancm4i")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_svr_cancm4i, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr_gemnemo")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_svr_gemnemo, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost_cancm4i")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_xgboost_cancm4i, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost_gemnemo")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_xgboost_gemnemo, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_lr_cancm4i")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_lr_cancm4i, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_lr_gemnemo")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_lr_gemnemo, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_ens_md")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_ens_md, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_ml_md")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff_ml_md, res3)
draw(map)
frame(wks)
delete(wks)
