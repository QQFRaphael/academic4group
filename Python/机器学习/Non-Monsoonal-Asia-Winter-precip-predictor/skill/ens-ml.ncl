load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/CanSIPSv2/cansips.nc", "r")
cancm = f->cancm_prec(30:,:,:)
gem   = f->gem_prec(30:,:,:)

ff = addfile("../data/CFSv2/cfs.nc", "r")
cfs = ff->cfs


ens_dy = (cancm + gem + cfs) / 3.0
ens_dy22 = (cancm + cfs) / 2.0


f1 = addfile("../GBDT/GBDT.nc", "r")
gbdt = f1->model
obs = f1->obs

f2 = addfile("../LightGBM/LightGBM.nc", "r")
lightgbm = f2->model

f3 = addfile("../CatBoost/CatBoost.nc", "r")
catboost = f3->model

f4 = addfile("../XGBoost/XGBoost.nc", "r")
xgboost = f4->model

ens_ml = (gbdt+lightgbm+catboost+xgboost)/4.0

ens_cancm = (gbdt+lightgbm+catboost+xgboost+cancm)/5.0

ens_all = (gbdt+lightgbm+catboost+xgboost+cancm+gem+cfs)/7.0

ens_all22 = (gbdt+lightgbm+catboost+xgboost+cancm+cfs)/6.0  

model_skill  = escorc_n(obs, ens_ml, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill)

model_skill2  = escorc_n(obs, ens_all, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill2)

model_skill3  = escorc_n(obs, ens_cancm, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill3)

model_skill4  = escorc_n(obs, ens_dy, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill4)


model_skill5  = escorc_n(obs, ens_all22, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill5)

model_skill6  = escorc_n(obs, ens_dy22, 0, 0)
copy_VarMeta(obs(0,:,:), model_skill6)

print("ens ml skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill,1),0))
print("ens all skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill2,1),0))
print("ens cancm skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill3,1),0))
print("ens dy skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill4,1),0))


print("ens all22 skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill5,1),0))
print("ens dy22 skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill6,1),0))




res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnMaximize=True
res@gsnAddCyclic = False

;res@mpCenterLonF = 265


res@gsnLeftString=""
res@gsnRightString=""

res@cnFillDrawOrder="PreDraw"
res@cnLineDrawOrder="PreDraw"

res2 = res
res3 = res

res@mpMinLatF              =  30
  res@mpMaxLatF              =  60
  res@mpMinLonF              = 30
  res@mpMaxLonF              = 105

  res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Always"
res@tmXBLabelFontHeightF =0.025
res@tmYLLabelFontHeightF =0.025

res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5

res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion = "MediumRes"
res@mpOceanFillColor = 0
res@mpOutlineOn = True
res@mpMaskAreaSpecifiers = (/"Land"/)

res@mpInlandWaterFillColor = 0

res@lbOrientation="vertical"



res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=fspan(-0.9,0.9,19)
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

resp = True
resp@gsLineColor      = "green2" ; polylines color
resp@gsLineThicknessF = 2.5    ; polylines thickness

ftp=asciiread("../data/tibet_shape",(/2066,2/),"float")


wks = gsn_open_wks("eps", "ens-ml-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill, res)
mapp = gsn_csm_contour(wks, model_skill, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)




wks = gsn_open_wks("eps", "ens-all-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill2, res)
mapp = gsn_csm_contour(wks, model_skill2, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("eps", "ens-cancm-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill3, res)
mapp = gsn_csm_contour(wks, model_skill3, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)


wks = gsn_open_wks("eps", "ens-dy-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill4, res)
mapp = gsn_csm_contour(wks, model_skill4, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)




wks = gsn_open_wks("eps", "ens-all22-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill5, res)
mapp = gsn_csm_contour(wks, model_skill5, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)





wks = gsn_open_wks("eps", "ens-dy22-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill6, res)
mapp = gsn_csm_contour(wks, model_skill6, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,ftp(:,0),ftp(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)
