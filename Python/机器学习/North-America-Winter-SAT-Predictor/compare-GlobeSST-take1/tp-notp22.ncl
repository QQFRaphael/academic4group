load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/OBS/obs.nc","r")

obs = f->tmp
lat_obs = f->lat
lon_obs = f->lon

fff = addfile("../data/NA-SAT-EOF/EOF.nc","r")

latml = fff->lat(::-1)
lonml = fff->lon

eof1 = linint2_Wrap(lonml,latml,fff->EOF1(::-1,:),True,lon_obs,lat_obs,0)
eof2 = linint2_Wrap(lonml,latml,fff->EOF2(::-1,:),True,lon_obs,lat_obs,0)
eof3 = linint2_Wrap(lonml,latml,fff->EOF3(::-1,:),True,lon_obs,lat_obs,0)

EOF1 = conform(obs,eof1,(/1,2/))
EOF2 = conform(obs,eof2,(/1,2/))
EOF3 = conform(obs,eof3,(/1,2/))

CLIM = linint2_Wrap(lonml,latml,fff->DJF_clim(::-1,:),True,lon_obs,lat_obs,0)
clim = conform(obs,CLIM,(/1,2/))



lr_pc1 = conform(obs,asciiread("../Linear/LR-PC1-TAKE1.txt",39,"float"),(/0/))
lr_pc2 = conform(obs,asciiread("../Linear/LR-PC2-TAKE1.txt",39,"float"),(/0/))
lr_pc3 = conform(obs,asciiread("../Linear/LR-PC3-TAKE1.txt",39,"float"),(/0/))

lr = EOF1*lr_pc1 + EOF2*lr_pc2 + EOF3*lr_pc3 + clim
copy_VarMeta(obs,lr)
lr1 = EOF1*lr_pc1 + clim
copy_VarMeta(obs,lr1)
lr2 = EOF2*lr_pc2 + clim
copy_VarMeta(obs,lr2)
lr3 = EOF3*lr_pc3 + clim
copy_VarMeta(obs,lr3)


lr_notp_pc1 = conform(obs,asciiread("../Linear/LR-PC1-TAKE1-GlobeSST.txt",39,"float"),(/0/))
lr_notp_pc2 = conform(obs,asciiread("../Linear/LR-PC2-TAKE1-GlobeSST.txt",39,"float"),(/0/))
lr_notp_pc3 = conform(obs,asciiread("../Linear/LR-PC3-TAKE1-GlobeSST.txt",39,"float"),(/0/))

lr_notp = EOF1*lr_notp_pc1 + EOF2*lr_notp_pc2 + EOF3*lr_notp_pc3 + clim
copy_VarMeta(obs,lr_notp)
lr1_notp = EOF1*lr_notp_pc1 + clim
copy_VarMeta(obs,lr1_notp)
lr2_notp = EOF2*lr_notp_pc2 + clim
copy_VarMeta(obs,lr2_notp)
lr3_notp = EOF3*lr_notp_pc3 + clim
copy_VarMeta(obs,lr3_notp)

lr_skill = escorc_n(obs, lr, 0, 0)
lr_notp_skill = escorc_n(obs, lr_notp, 0, 0)
diff_lr_tp = lr_skill - lr_notp_skill
copy_VarMeta(obs(0,:,:),lr_skill)
copy_VarMeta(obs(0,:,:),lr_notp_skill)
copy_VarMeta(obs(0,:,:),diff_lr_tp)

lr1_skill = escorc_n(obs, lr1, 0, 0)
lr2_skill = escorc_n(obs, lr2, 0, 0)
lr3_skill = escorc_n(obs, lr3, 0, 0)
copy_VarMeta(obs(0,:,:),lr1_skill)
copy_VarMeta(obs(0,:,:),lr2_skill)
copy_VarMeta(obs(0,:,:),lr3_skill)

lr1_notp_skill = escorc_n(obs, lr1_notp, 0, 0)
lr2_notp_skill = escorc_n(obs, lr2_notp, 0, 0)
lr3_notp_skill = escorc_n(obs, lr3_notp, 0, 0)
copy_VarMeta(obs(0,:,:),lr1_notp_skill)
copy_VarMeta(obs(0,:,:),lr2_notp_skill)
copy_VarMeta(obs(0,:,:),lr3_notp_skill)

diff_lr1_tp = lr1_skill - lr1_notp_skill
diff_lr2_tp = lr2_skill - lr2_notp_skill
diff_lr3_tp = lr3_skill - lr3_notp_skill
copy_VarMeta(obs(0,:,:),diff_lr1_tp)
copy_VarMeta(obs(0,:,:),diff_lr2_tp)
copy_VarMeta(obs(0,:,:),diff_lr3_tp)




svr_pc1 = conform(obs,asciiread("../SVR/SVR-PC1-TAKE1.txt",39,"float"),(/0/))
svr_pc2 = conform(obs,asciiread("../SVR/SVR-PC2-TAKE1.txt",39,"float"),(/0/))
svr_pc3 = conform(obs,asciiread("../SVR/SVR-PC3-TAKE1.txt",39,"float"),(/0/))

svr = EOF1*svr_pc1 + EOF2*svr_pc2 + EOF3*svr_pc3 + clim
copy_VarMeta(obs,svr)
svr1 = EOF1*svr_pc1 + clim
copy_VarMeta(obs,svr1)
svr2 = EOF2*svr_pc2 + clim
copy_VarMeta(obs,svr2)
svr3 = EOF3*svr_pc3 + clim
copy_VarMeta(obs,svr3)


svr_notp_pc1 = conform(obs,asciiread("../SVR/SVR-PC1-TAKE1-GlobeSST.txt",39,"float"),(/0/))
svr_notp_pc2 = conform(obs,asciiread("../SVR/SVR-PC2-TAKE1-GlobeSST.txt",39,"float"),(/0/))
svr_notp_pc3 = conform(obs,asciiread("../SVR/SVR-PC3-TAKE1-GlobeSST.txt",39,"float"),(/0/))


svr_notp = EOF1*svr_notp_pc1 + EOF2*svr_notp_pc2 + EOF3*svr_notp_pc3 + clim
copy_VarMeta(obs,svr_notp)
svr1_notp = EOF1*svr_notp_pc1 + clim
copy_VarMeta(obs,svr1_notp)
svr2_notp = EOF2*svr_notp_pc2 + clim
copy_VarMeta(obs,svr2_notp)
svr3_notp = EOF3*svr_notp_pc3 + clim
copy_VarMeta(obs,svr3_notp)


svr_skill = escorc_n(obs, svr, 0, 0)
svr_notp_skill = escorc_n(obs, svr_notp, 0, 0)
diff_svr_tp = svr_skill - svr_notp_skill
copy_VarMeta(obs(0,:,:),svr_skill)
copy_VarMeta(obs(0,:,:),svr_notp_skill)
copy_VarMeta(obs(0,:,:),diff_svr_tp)

svr1_skill = escorc_n(obs, svr1, 0, 0)
svr2_skill = escorc_n(obs, svr2, 0, 0)
svr3_skill = escorc_n(obs, svr3, 0, 0)
copy_VarMeta(obs(0,:,:),svr1_skill)
copy_VarMeta(obs(0,:,:),svr2_skill)
copy_VarMeta(obs(0,:,:),svr3_skill)

svr1_notp_skill = escorc_n(obs, svr1_notp, 0, 0)
svr2_notp_skill = escorc_n(obs, svr2_notp, 0, 0)
svr3_notp_skill = escorc_n(obs, svr3_notp, 0, 0)
copy_VarMeta(obs(0,:,:),svr1_notp_skill)
copy_VarMeta(obs(0,:,:),svr2_notp_skill)
copy_VarMeta(obs(0,:,:),svr3_notp_skill)

diff_svr1_tp = svr1_skill - svr1_notp_skill
diff_svr2_tp = svr2_skill - svr2_notp_skill
diff_svr3_tp = svr3_skill - svr3_notp_skill
copy_VarMeta(obs(0,:,:),diff_svr1_tp)
copy_VarMeta(obs(0,:,:),diff_svr2_tp)
copy_VarMeta(obs(0,:,:),diff_svr3_tp)





xgboost_pc1 = conform(obs,asciiread("../XGBoost/XGBoost-PC1-TAKE1.txt",39,"float"),(/0/))
xgboost_pc2 = conform(obs,asciiread("../XGBoost/XGBoost-PC2-TAKE1.txt",39,"float"),(/0/))
xgboost_pc3 = conform(obs,asciiread("../XGBoost/XGBoost-PC3-TAKE1.txt",39,"float"),(/0/))

xgboost = EOF1*xgboost_pc1 + EOF2*xgboost_pc2 + EOF3*xgboost_pc3 + clim
copy_VarMeta(obs,xgboost)
xgboost1 = EOF1*xgboost_pc1 + clim
copy_VarMeta(obs,xgboost1)
xgboost2 = EOF2*xgboost_pc2 + clim
copy_VarMeta(obs,xgboost2)
xgboost3 = EOF3*xgboost_pc3 + clim
copy_VarMeta(obs,xgboost3)


xgboost_notp_pc1 = conform(obs,asciiread("../XGBoost/XGBoost-PC1-TAKE1-GlobeSST.txt",39,"float"),(/0/))
xgboost_notp_pc2 = conform(obs,asciiread("../XGBoost/XGBoost-PC2-TAKE1-GlobeSST.txt",39,"float"),(/0/))
xgboost_notp_pc3 = conform(obs,asciiread("../XGBoost/XGBoost-PC3-TAKE1-GlobeSST.txt",39,"float"),(/0/))

xgboost_notp = EOF1*xgboost_notp_pc1 + EOF2*xgboost_notp_pc2 + EOF3*xgboost_notp_pc3 + clim
copy_VarMeta(obs,xgboost_notp)
xgboost1_notp = EOF1*xgboost_notp_pc1 + clim
copy_VarMeta(obs,xgboost1_notp)
xgboost2_notp = EOF2*xgboost_notp_pc2 + clim
copy_VarMeta(obs,xgboost2_notp)
xgboost3_notp = EOF3*xgboost_notp_pc3 + clim
copy_VarMeta(obs,xgboost3_notp)


xgboost_skill = escorc_n(obs, xgboost, 0, 0)
xgboost_notp_skill = escorc_n(obs, xgboost_notp, 0, 0)
diff_xgboost_tp = xgboost_skill - xgboost_notp_skill
copy_VarMeta(obs(0,:,:),xgboost_skill)
copy_VarMeta(obs(0,:,:),xgboost_notp_skill)
copy_VarMeta(obs(0,:,:),diff_xgboost_tp)

xgboost1_skill = escorc_n(obs, xgboost1, 0, 0)
xgboost2_skill = escorc_n(obs, xgboost2, 0, 0)
xgboost3_skill = escorc_n(obs, xgboost3, 0, 0)
copy_VarMeta(obs(0,:,:),xgboost1_skill)
copy_VarMeta(obs(0,:,:),xgboost2_skill)
copy_VarMeta(obs(0,:,:),xgboost3_skill)

xgboost1_notp_skill = escorc_n(obs, xgboost1_notp, 0, 0)
xgboost2_notp_skill = escorc_n(obs, xgboost2_notp, 0, 0)
xgboost3_notp_skill = escorc_n(obs, xgboost3_notp, 0, 0)
copy_VarMeta(obs(0,:,:),xgboost1_notp_skill)
copy_VarMeta(obs(0,:,:),xgboost2_notp_skill)
copy_VarMeta(obs(0,:,:),xgboost3_notp_skill)

diff_xgboost1_tp = xgboost1_skill - xgboost1_notp_skill
diff_xgboost2_tp = xgboost2_skill - xgboost2_notp_skill
diff_xgboost3_tp = xgboost3_skill - xgboost3_notp_skill
copy_VarMeta(obs(0,:,:),diff_xgboost1_tp)
copy_VarMeta(obs(0,:,:),diff_xgboost2_tp)
copy_VarMeta(obs(0,:,:),diff_xgboost3_tp)


colors = "BlueWhiteOrangeRed"

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

res@lbOrientation="Vertical"

res2 = res
res3 = res
res4 = res

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
res3@cnLevels=fspan(-0.4,0.4,17)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False

res4@cnFillOn=True
res4@cnLinesOn=False
res4@cnLevelSelectionMode = "ExplicitLevels"
res4@cnLevels=fspan(-0.2,0.2,11)
res4@cnLineThicknessF=2.0
res4@cnLineLabelsOn=False
res4@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)




wks = gsn_open_wks("eps", "diff_lr_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_lr_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_lr1_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_lr1_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_lr2_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_lr2_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_lr3_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_lr3_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_svr_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr1_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_svr1_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr2_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_svr2_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_svr3_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_svr3_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_xgboost_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost1_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_xgboost1_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost2_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_xgboost2_tp, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "diff_xgboost3_tp")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_xgboost3_tp, res4)
draw(map)
frame(wks)
delete(wks)




wks = gsn_open_wks("eps", "lr_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr_skill, res)
mapp = gsn_csm_contour(wks, lr_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr_notp_skill, res)
mapp = gsn_csm_contour(wks, lr_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr1_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr1_skill, res)
mapp = gsn_csm_contour(wks, lr1_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr2_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr2_skill, res)
mapp = gsn_csm_contour(wks, lr2_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr3_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr3_skill, res)
mapp = gsn_csm_contour(wks, lr3_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr1_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr1_notp_skill, res)
mapp = gsn_csm_contour(wks, lr1_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr2_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr2_notp_skill, res)
mapp = gsn_csm_contour(wks, lr2_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "lr3_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, lr3_notp_skill, res)
mapp = gsn_csm_contour(wks, lr3_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr_skill, res)
mapp = gsn_csm_contour(wks, svr_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr_notp_skill, res)
mapp = gsn_csm_contour(wks, svr_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr1_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr1_skill, res)
mapp = gsn_csm_contour(wks, svr1_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr2_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr2_skill, res)
mapp = gsn_csm_contour(wks, svr2_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr3_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr3_skill, res)
mapp = gsn_csm_contour(wks, svr3_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr1_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr1_notp_skill, res)
mapp = gsn_csm_contour(wks, svr1_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr2_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr2_notp_skill, res)
mapp = gsn_csm_contour(wks, svr2_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "svr3_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, svr3_notp_skill, res)
mapp = gsn_csm_contour(wks, svr3_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost_skill, res)
mapp = gsn_csm_contour(wks, xgboost_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost_notp_skill, res)
mapp = gsn_csm_contour(wks, xgboost_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost1_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost1_skill, res)
mapp = gsn_csm_contour(wks, xgboost1_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost2_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost2_skill, res)
mapp = gsn_csm_contour(wks, xgboost2_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost3_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost3_skill, res)
mapp = gsn_csm_contour(wks, xgboost3_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost1_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost1_notp_skill, res)
mapp = gsn_csm_contour(wks, xgboost1_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost2_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost2_notp_skill, res)
mapp = gsn_csm_contour(wks, xgboost2_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "xgboost3_notp_skill")
gsn_define_colormap(wks,colors)
map = gsn_csm_contour_map(wks, xgboost3_notp_skill, res)
mapp = gsn_csm_contour(wks, xgboost3_notp_skill, res2)
overlay(map, mapp)
draw(map)
delete(mapp)
frame(wks)
delete(wks)
