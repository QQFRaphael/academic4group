load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$GEODIAG_ROOT/geodiag.ncl"

  wks = gsn_open_wks("eps", "pre")  ; Open graphics file
  gsn_define_colormap(wks,"cmp_b2r")

wrff1=addfile("/home/yongluo/WORK/wrfoutput/wrfout/2007-07-01/wrfout_d01_2007-07-01_00:00:00","r")


filename_d01=systemfunc("ls *d01.nc")
filename_d02=systemfunc("ls *d02.nc")

files_d01=addfiles(filename_d01, "r")
files_d02=addfiles(filename_d02, "r")
ListSetType(files_d01,"cat")     
ListSetType(files_d02,"cat")
pre_d01=files_d01[:]->pre_d01
pre_d02=files_d02[:]->pre_d02
lat_d01=files_d01[0]->lat_d01
lat_d02=files_d02[0]->lat_d02
lon_d01=files_d01[0]->lon_d01
lon_d02=files_d02[0]->lon_d02

lat1=lat_d01
lon1=lon_d01
lat2=lat_d02
lon2=lon_d02


pre_d01_total=dim_sum_n_Wrap(pre_d01,0)
pre_d02_total=dim_sum_n_Wrap(pre_d02,0)

pre_d01_total@lat2d=lat_d01
pre_d01_total@lon2d=lon_d01
pre_d02_total@lat2d=lat_d02
pre_d02_total@lon2d=lon_d02

  dom_dims = dimsizes(pre_d01_total)
  dom_rank = dimsizes(dom_dims)
  nx1 = dom_dims(dom_rank - 1) - 1
  ny1 = dom_dims(dom_rank - 2) - 1
  dom_dims = dimsizes(pre_d02_total)
  dom_rank = dimsizes(dom_dims)
  nx2 = dom_dims(dom_rank - 1) - 1
  ny2 = dom_dims(dom_rank - 2) - 1


res                 = True
res@cnFillOn        = True
res@cnLinesOn       = False
res@cnLineLabelsOn  = False
res@cnInfoLabelOn   = False
res@gsnSpreadColors = True
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=(/40,80,120,160,200,240,280,320,360,400,440/)
res@gsnLeftString = ""
res@gsnRightString = ""
res@gsnDraw         = False
res@gsnFrame        = False

res2 = res

res@isShowProvince = True
res@isShowSouthChinaSea = False
res@isAddMask = False
res@isShowRivers = True
res@riverColor = "black"
res@riverThickness = 0.5
res@boundaryColor = "black"
res@boundaryThickness = 0.5
setup_china_map(res)

res@mpDataBaseVersion     = "MediumRes"          ; Default is LowRes
res@mpOutlineOn              = True
res@mpOutlineDrawOrder    = "PostDraw"           ; Draw map outlines last
res@mpGridAndLimbOn       = True                ; Turn off lat/lon lines
res@mpGridLineDashPattern       = 2
res@pmTickMarkDisplayMode = "Always"             ; Turn on map tickmarks
res = set_mp_wrf_map_resources(wrff1,res)
res@mpLimitMode        = "Corners"               ; Portion of map to zoom
res@mpLeftCornerLatF   = lat1(0,0)
res@mpLeftCornerLonF   = lon1(0,0)
res@mpRightCornerLatF  = lat1(ny1,nx1)
res@mpRightCornerLonF  = lon1(ny1,nx1)
res@lbLabelAutoStride = True
res@gsnMaximize     = True    ; Maximize plot in frame

res2@lbLabelBarOn = False  ; Labelbar already created in 1st plot
res2@gsnMaximize  = False  ; Use maximization from original plot


xbox_out = new(5,float)
ybox_out = new(5,float)
lnres = True
lnres@gsLineThicknessF  = 1.5


map = gsn_csm_contour_map(wks, pre_d01_total, res)
plot = gsn_csm_contour(wks, pre_d02_total, res2)
attach_china_map(wks, map)


draw(map) 
gsn_polyline(wks,map,lon2(0,:),lat2(0,:),True)
gsn_polyline(wks,map,lon2(:,0),lat2(:,0),True)
gsn_polyline(wks,map,lon2(ny2,:),lat2(ny2,:),True)
gsn_polyline(wks,map,lon2(:,nx2),lat2(:,nx2),True)

frame(wks)



