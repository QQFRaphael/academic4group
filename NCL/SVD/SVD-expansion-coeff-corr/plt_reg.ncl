load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

ttestval = 1.995

ff= addfile("mysvd_reg.nc", "r")

jja_time0 = ff->jja_time0
;jja_time1 = ff->jja_time1
mam_time0 = ff->mam_time0
;mam_time1 = ff->mam_time1

;lines = new((/2,48/),"float")
;lines(0,:) = jja_time0(:)
;lines(1,:) = mam_time0(:)
;lines(2,:) = jja_time1(:)
;lines(3,:) = mam_time1(:)


jja0 = ff->jja0
;jja1 = ff->jja1

mam0 = ff->mam0
;mam1 = ff->mam1

tval_jja0 = ff->tval_jja0
;tval_jja1 = ff->tval_jja1

tval_mam0 = ff->tval_mam0
;tval_mam1 = ff->tval_mam1

tval_jja = abs(tval_jja0)
copy_VarMeta(tval_jja0, tval_jja)

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
res@cnLevels=ispan(-120, 120, 20)
res@cnFillColors = (/2,11,18,27,42,57,0,0,73,83,97,107,118,129/)

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

wks = gsn_open_wks("eps", "JJA")
gsn_define_colormap(wks,"MPL_BrBG")

map = gsn_csm_contour_map(wks, jja0, res)
map = ColorNegDashZeroPosContour(map,"black","white","black")
draw(wks)
frame(wks)
delete(wks)

wks = gsn_open_wks("eps", "MAM")
gsn_define_colormap(wks,"MPL_BrBG")

map = gsn_csm_contour_map(wks, mam0, res)
map = ColorNegDashZeroPosContour(map,"black","white","black")
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

