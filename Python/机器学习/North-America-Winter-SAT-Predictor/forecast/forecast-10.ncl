load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/OBS/obs.nc","r")

obs = f->tmp(31:37,:,:)
lat_obs = f->lat
lon_obs = f->lon

nyear = 7

f2  = addfile("cancm4i.nc", "r")
cancm4i = f2->cancm4i(0:6,:,:)

f3  = addfile("gemnemo.nc", "r")
gemnemo = f3->gemnemo(0:6,:,:)


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

lr_pc1 = conform(obs,asciiread("LR-PC1.txt",nyear,"float"),(/0/))
lr_pc2 = conform(obs,asciiread("LR-PC2.txt",nyear,"float"),(/0/))
lr_pc3 = conform(obs,asciiread("LR-PC3.txt",nyear,"float"),(/0/))

lr = EOF1*lr_pc1 + EOF2*lr_pc2 + EOF3*lr_pc3 + clim
copy_VarMeta(obs,lr)

svr_pc1 = conform(obs,asciiread("SVR-PC1.txt",nyear,"float"),(/0/))
svr_pc2 = conform(obs,asciiread("SVR-PC2.txt",nyear,"float"),(/0/))
svr_pc3 = conform(obs,asciiread("SVR-PC3.txt",nyear,"float"),(/0/))

svr = EOF1*svr_pc1 + EOF2*svr_pc2 + EOF3*svr_pc3 + clim
copy_VarMeta(obs,svr)

xgboost_pc1 = conform(obs,asciiread("XGBoost-PC1.txt",nyear,"float"),(/0/))
xgboost_pc2 = conform(obs,asciiread("XGBoost-PC2.txt",nyear,"float"),(/0/))
xgboost_pc3 = conform(obs,asciiread("XGBoost-PC3.txt",nyear,"float"),(/0/))

xgboost = EOF1*xgboost_pc1 + EOF2*xgboost_pc2 + EOF3*xgboost_pc3 + clim
copy_VarMeta(obs,xgboost)

ens3 = (lr+svr+xgboost)/3.0
ens2 = (svr+xgboost)/2.0

ens5 = (-lr-svr-xgboost+cancm4i+gemnemo)/5.0

dyn = (cancm4i+gemnemo)/2.0
super = (svr+xgboost+cancm4i)/3.0

lr_skill = escorc_n(obs, -lr, 0, 0)
svr_skill = escorc_n(obs, -svr, 0, 0)
xgboost_skill = escorc_n(obs, -xgboost, 0, 0)
ens3_skill = escorc_n(obs, ens3, 0, 0)
ens2_skill = escorc_n(obs, ens2, 0, 0)
ens5_skill = escorc_n(obs, ens5, 0, 0)

can_skill = escorc_n(obs, cancm4i, 0, 0)
gem_skill = escorc_n(obs, gemnemo, 0, 0)

dyn_skill = escorc_n(obs, dyn, 0, 0)
super_skill = escorc_n(obs, super, 0, 0)

copy_VarMeta(obs(0,:,:),lr_skill)
copy_VarMeta(obs(0,:,:),svr_skill)
copy_VarMeta(obs(0,:,:),xgboost_skill)
copy_VarMeta(obs(0,:,:),can_skill)
copy_VarMeta(obs(0,:,:),gem_skill)
copy_VarMeta(obs(0,:,:),ens5_skill)
copy_VarMeta(obs(0,:,:),dyn_skill)


print("lr: "+dim_avg_n_Wrap(dim_avg_n_Wrap(lr_skill,1),0))
print("svr: "+dim_avg_n_Wrap(dim_avg_n_Wrap(svr_skill,1),0))
print("xg: "+dim_avg_n_Wrap(dim_avg_n_Wrap(xgboost_skill,1),0))
print("can: "+dim_avg_n_Wrap(dim_avg_n_Wrap(can_skill,1),0))
print("gem: "+dim_avg_n_Wrap(dim_avg_n_Wrap(gem_skill,1),0))
print("ens: "+dim_avg_n_Wrap(dim_avg_n_Wrap(NewCosWeight(ens5_skill),1),0))
print("dyn: "+dim_avg_n_Wrap(dim_avg_n_Wrap(NewCosWeight(dyn_skill),1),0))



diff_svr_lr = svr_skill - lr_skill
diff_xgboost_lr = xgboost_skill - lr_skill
diff_ens3_lr = ens3_skill - lr_skill
diff_ens2_lr = ens2_skill - lr_skill
diff_ens = ens2_skill - ens3_skill

diff_ens2_dyn = ens2_skill - dyn_skill
diff_ens3_dyn = ens3_skill - dyn_skill
diff_ens5_dyn = ens5_skill - dyn_skill
diff_ens2_cancm4i = ens2_skill - can_skill
diff_super_cancm4i = super_skill - can_skill

rmse_lr = sqrt(dim_avg_n_Wrap((lr-obs-273.15)^2,0)/nyear)
rmse_svr = sqrt(dim_avg_n_Wrap((svr-obs-273.15)^2,0)/nyear)
rmse_xg = sqrt(dim_avg_n_Wrap((xgboost-obs-273.15)^2,0)/nyear)
rmse_can = sqrt(dim_avg_n_Wrap((cancm4i-obs-273.15)^2,0)/nyear)
rmse_gem = sqrt(dim_avg_n_Wrap((gemnemo-obs-273.15)^2,0)/nyear)
rmse_dyn = sqrt(dim_avg_n_Wrap((dyn-obs-273.15)^2,0)/nyear)
rmse_ens5 = sqrt(dim_avg_n_Wrap((ens5-obs-273.15)^2,0)/nyear)
rmse_diff = rmse_ens5 - rmse_dyn

copy_VarMeta(obs(0,:,:), rmse_lr)
copy_VarMeta(obs(0,:,:), rmse_svr)
copy_VarMeta(obs(0,:,:), rmse_xg)
copy_VarMeta(obs(0,:,:), rmse_can)
copy_VarMeta(obs(0,:,:), rmse_gem)
copy_VarMeta(obs(0,:,:), rmse_dyn)
copy_VarMeta(obs(0,:,:), rmse_ens5)
copy_VarMeta(obs(0,:,:), rmse_diff)

copy_VarMeta(obs(0,:,:), lr_skill)
copy_VarMeta(obs(0,:,:), svr_skill)
copy_VarMeta(obs(0,:,:), xgboost_skill)
copy_VarMeta(obs(0,:,:), ens3_skill)
copy_VarMeta(obs(0,:,:), ens2_skill)
copy_VarMeta(obs(0,:,:), ens5_skill)

copy_VarMeta(obs(0,:,:), can_skill)
copy_VarMeta(obs(0,:,:), gem_skill)
copy_VarMeta(obs(0,:,:), dyn_skill)
copy_VarMeta(obs(0,:,:), super_skill)

copy_VarMeta(obs(0,:,:), diff_svr_lr)
copy_VarMeta(obs(0,:,:), diff_xgboost_lr)
copy_VarMeta(obs(0,:,:), diff_ens3_lr)
copy_VarMeta(obs(0,:,:), diff_ens2_lr)
copy_VarMeta(obs(0,:,:), diff_ens)
copy_VarMeta(obs(0,:,:), diff_ens2_dyn)
copy_VarMeta(obs(0,:,:), diff_ens3_dyn)
copy_VarMeta(obs(0,:,:), diff_ens5_dyn)
copy_VarMeta(obs(0,:,:), diff_ens2_cancm4i)
copy_VarMeta(obs(0,:,:), diff_super_cancm4i)

type = "png"

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
res5 = res

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
res3@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False

res4@cnFillOn=True
res4@cnLinesOn=False
res4@cnLevelSelectionMode = "ExplicitLevels"
res4@cnLevels=fspan(-0.5,0.5,11)
res4@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)
res4@cnLineThicknessF=2.0
res4@cnLineLabelsOn=False

res5@cnFillOn=True
res5@cnLinesOn=False
res5@cnLevelSelectionMode = "ExplicitLevels"
res5@cnLevels=fspan(-1,1,11)
res5@cnFillColors = (/5,6,7,8,9,10,14,15,16,17,18,19/)
res5@cnLineThicknessF=2.0
res5@cnLineLabelsOn=False

colors = "BlueWhiteOrangeRed"

wks = gsn_open_wks(type, "lr-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, lr_skill, res)
mapp = gsn_csm_contour(wks, lr_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "svr-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, svr_skill, res)
mapp = gsn_csm_contour(wks, svr_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "xgboost-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, xgboost_skill, res)
mapp = gsn_csm_contour(wks, xgboost_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "cancm4i-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, can_skill, res)
mapp = gsn_csm_contour(wks, can_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)



wks = gsn_open_wks(type, "gem-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, gem_skill, res)
mapp = gsn_csm_contour(wks, gem_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "dyn-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, dyn_skill, res)
mapp = gsn_csm_contour(wks, dyn_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "super-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, super_skill, res)
mapp = gsn_csm_contour(wks, super_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "ens3-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens3_skill, res)
mapp = gsn_csm_contour(wks, ens3_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)



wks = gsn_open_wks(type, "ens5-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens5_skill, res)
mapp = gsn_csm_contour(wks, ens5_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)




wks = gsn_open_wks(type, "ens2-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, ens2_skill, res)
mapp = gsn_csm_contour(wks, ens2_skill, res2)
overlay(map, mapp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "diff_svr_lr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_svr_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_xgboost_lr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_xgboost_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_ens3_lr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens3_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_ens2_lr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens2_lr, res3)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_ens")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_ens2_dyn")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens2_dyn, res4)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "diff_ens3_dyn")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens3_dyn, res4)
draw(map)
frame(wks)
delete(wks)



wks = gsn_open_wks(type, "diff_ens5_dyn")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens5_dyn, res4)
draw(map)
frame(wks)
delete(wks)



wks = gsn_open_wks(type, "diff_ens2_cancm4i")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_ens2_cancm4i, res4)
draw(map)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "diff_super_cancm4i")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, diff_super_cancm4i, res4)
draw(map)
frame(wks)
delete(wks)





wks = gsn_open_wks(type, "rmse_lr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_lr, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_svr")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_svr, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_xg")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_xg, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_can")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_can, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_gem")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_gem, res5)
draw(map)
frame(wks)
delete(wks)


wks = gsn_open_wks(type, "rmse_dyn")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_dyn, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_ens5")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_ens5, res5)
draw(map)
frame(wks)
delete(wks)

wks = gsn_open_wks(type, "rmse_diff")
gsn_define_colormap(wks,"BlueDarkRed18")
map = gsn_csm_contour_map(wks, rmse_diff, res3)
draw(map)
frame(wks)
delete(wks)
