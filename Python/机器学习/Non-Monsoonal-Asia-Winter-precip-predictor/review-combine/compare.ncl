load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


mymodel = "LR"
fmodel = addfile(mymodel+".nc", "r")
model = fmodel->model
model1 = fmodel->model1
model2 = fmodel->model2
model3 = fmodel->model3
obs = fmodel->obs

model_skill  = escorc_n(obs, model, 0, 0)
model1_skill = escorc_n(obs, model1, 0, 0)
model2_skill = escorc_n(obs, model2, 0, 0)
model3_skill = escorc_n(obs, model3, 0, 0)


print(mymodel+" skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model_skill,1),0))
print(mymodel+" eof1 skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model1_skill,1),0))
print(mymodel+" eof2 skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model2_skill,1),0))
print(mymodel+" eof3 skill: "+dim_avg_n_Wrap(dim_avg_n_Wrap(model3_skill,1),0))



copy_VarMeta(obs(0,:,:), model_skill)
copy_VarMeta(obs(0,:,:), model1_skill)
copy_VarMeta(obs(0,:,:), model2_skill)
copy_VarMeta(obs(0,:,:), model3_skill)


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
resp@gsLineThicknessF = 4    ; polylines thickness

f2=asciiread("tibet_shape",(/2066,2/),"float")


wks = gsn_open_wks("eps", mymodel+"-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model_skill, res)
mapp = gsn_csm_contour(wks, model_skill, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", mymodel+"1-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model1_skill, res)
mapp = gsn_csm_contour(wks, model1_skill, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", mymodel+"2-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model2_skill, res)
mapp = gsn_csm_contour(wks, model2_skill, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", mymodel+"3-skill")
gsn_define_colormap(wks,colors)

map = gsn_csm_contour_map(wks, model3_skill, res)
mapp = gsn_csm_contour(wks, model3_skill, res2)
overlay(map, mapp)

poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
delete(mapp)
frame(wks)
delete(wks)

