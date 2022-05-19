load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$GEODIAG_ROOT/geodiag.ncl"

path = "mess/"
scene = "ens-ssp585-2081-2100"

f = addfile(path+scene+".nc", "r")

data = f->Band1

data = where(isnan_ieee(data),data@_FillValue,data)

data = where(data.le.0, data+2.,data)

wks = gsn_open_wks("eps",scene)         
gsn_define_colormap(wks,"BlRe")
res                     = True  

res@gsnDraw=False
res@gsnFrame=False

res@gsnAddCyclic = False        
res@gsnMaximize = True   
res@cnFillOn            = True             
res@cnFillMode          = "RasterFill"     
res@cnLinesOn           = False           

res@cnLevelSelectionMode = "ExplicitLevels"    
res@cnLevels=ispan(-60,60,5)  ;(/200,400,600/)
;res@cnFillColors=(/"green4","yellow2","orange","red"/)

res@isShowProvince = True
res@isShowSouthChinaSea = True
res@isShowRivers = False
res@provinceColor="black"
res@provinceThickness=2.2
setup_china_map(res)

res@mpFillOn = True
res@mpLandFillColor   = "white"
res@mpPerimOn = False
res@mpOutlineOn = False

res@mpGridAndLimbOn     = False
res@tmYLLabelFontHeightF = 0.025
res@tmXBLabelFontHeightF = 0.025 ; 0.018
;res@lbLabelFontHeightF = 0.02

res@gsnLeftString = ""
res@gsnRightString = ""
res@lbLabelBarOn = False
res@cnLineLabelsOn = False

plot = gsn_csm_contour_map(wks, data, res)
attach_china_map(wks, plot)

draw(plot)
frame(wks)
