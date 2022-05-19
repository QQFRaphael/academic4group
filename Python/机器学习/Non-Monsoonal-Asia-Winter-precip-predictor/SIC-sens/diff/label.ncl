load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

mymodel1 = "LightGBM"
fmodel1 = addfile(mymodel1+".nc", "r")
model1 = fmodel1->model
obs = fmodel1->obs

model1_skill  = escorc_n(obs, model1, 0, 0)

mymodel2 = mymodel1
fmodel2 = addfile("../../"+mymodel2+"/"+mymodel2+".nc", "r")
model2 = fmodel2->model

model2_skill  = escorc_n(obs, model2, 0, 0)

diff = -model1_skill + model2_skill
copy_VarMeta(obs(0,:,:), diff)
print(dim_avg_n_Wrap(dim_avg_n_Wrap(model1_skill,1),0))
print(dim_avg_n_Wrap(dim_avg_n_Wrap(model2_skill,1),0))
print(dim_avg_n_Wrap(dim_avg_n_Wrap(diff,1),0))

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnMaximize=True
res@gsnAddCyclic = False


res@mpMinLatF              =  30
  res@mpMaxLatF              =  60
  res@mpMinLonF              = 30
  res@mpMaxLonF              = 105

  res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5
res@tmXBLabelFontHeightF =0.025
res@tmYLLabelFontHeightF =0.025

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
res3@cnLevels=fspan(-0.8,0.8,11)
res3@cnLineThicknessF=2.0
res3@cnLineLabelsOn=False
res3@lbOrientation="horizontal"
res3@cnFillColors = (/57,65,73,81,89,97,185,201,217,233,249,255/)  ;(/5,6,7,8,9,10,14,15,16,17,18,19/)

colors = "BlueWhiteOrangeRed"
cc2 = "BlueWhiteOrangeRed"    ;"BlueDarkRed18"
type = "eps"

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 6    ; polylines thickness

f2=asciiread("tibet_shape",(/2066,2/),"float")

do ii = 0,59
do jj = 0,149
if(ismissing(diff(ii,jj))) then
diff(ii,jj)=0.0
end if
end do
end do


wks = gsn_open_wks(type, "label")
gsn_define_colormap(wks,cc2)
map = gsn_csm_contour_map(wks, diff, res3)


poli=gsn_add_polyline(wks,map,f2(:,0),f2(:,1),resp)

draw(map)
frame(wks)
delete(wks)

