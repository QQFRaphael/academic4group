load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ff = addfile("frac.nc", "r")
jja_svd_var_frac = ff->jja_svd_var_frac
mam_svd_var_frac = ff->mam_svd_var_frac

jja = jja_svd_var_frac*100
mam = mam_svd_var_frac*100

copy_VarMeta(jja_svd_var_frac, jja)
copy_VarMeta(mam_svd_var_frac, mam)

latU = 55
latL = 0.
lonL = 85
lonR = 145.

res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=False
res@gsnMaximize=True

res@mpLimitMode        = "LatLon"               ; Portion of map to zoom
res@mpMinLatF = latL   
res@mpMaxLatF = latU
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

  res@mpGridAndLimbOn        = True  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5


res@cnFillOn=True
res@cnLinesOn=True
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(5, 75, 10)
;res@cnFillColors = (/2,11,18,27,42,57,0,0,73,83,97,107,118,129/)

res@cnLineThicknessF = 3

res@lbOrientation="Vertical"

res@gsnMaximize=True
res@vpWidthF      = 0.4
res@vpHeightF     = 0.6

res@gsnLeftString=""
res@gsnRightString=""

res@mpDataSetName = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"          ; Default is LowRes
res@mpOutlineOn              = True
res@mpOutlineDrawOrder    = "PostDraw"           ; Draw map outlines last

res@mpPerimOn   = True

wks = gsn_open_wks("eps", "JJA-frac")
gsn_define_colormap(wks,"WhiteYellowOrangeRed")

map = gsn_csm_contour_map(wks, jja, res)
;map = ColorNegDashZeroPosContour(map,"black","white","black")
draw(wks)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "MAM-frac")
gsn_define_colormap(wks,"WhiteYellowOrangeRed")

map = gsn_csm_contour_map(wks, mam, res)
;map = ColorNegDashZeroPosContour(map,"black","white","black")
draw(wks)
frame(wks)

;map = ColorNegDashZeroPosContour(map,"black","white","black")

;resshade=True
;resshade@pmTickMarkDisplayMode="Always"
;resshade@cnFillOn=True
;resshade@cnLinesOn=False
;resshade@cnLineLabelsOn=False
;resshade@cnMonoFillPattern=False
;resshade@cnMonoFillColor=True
;
;resshade@cnFillPatterns=(/-1,17/)
;resshade@cnFillDotSizeF=0.006
;resshade@cnFillColor = "black"
;resshade@cnMonoFillScale = True 
;resshade@cnFillScaleF = 3.0
;
;resshade@cnLevelSelectionMode="ExplicitLevels"
;resshade@cnLevels=(/ttestval/)
;resshade@lbLabelBarOn=False
;resshade@cnInfoLabelOn=False
;
;resshade@gsnAddCyclic=False
;
;resshade@gsnDraw=False
;resshade@gsnFrame=False
;
;resshade@gsnLeftString=""
;resshade@gsnRightString=""
;
;
;map2 = gsn_csm_contour(wks, tval_jja, resshade)
;overlay(map,map2)

