load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; SON
season = "MAM"
idx_A = 2
idx_B = 3
idx_C = 4

yearstart = 1971
yearend = 2018
nyear = yearend - yearstart + 1

airfile = addfile("/home/qqf/Data/NCEP1-DAILY/monthlymean/watflux.mon.mean.nc","r")

airs = airfile->qVdiv_int


lat_wind = airfile->lat
lon_wind = airfile->lon
year=calendar_decode2(airfile->time,0)
year_idx=ind(year(:,0).ge.(yearstart).and.year(:,0).le.(yearend))

air = airs(year_idx,:,:)

hA = air(idx_A::12,:,:)
hB = air(idx_B::12,:,:)
hC = air(idx_C::12,:,:)
air_season = (hA + hB + hC) / 3.0 
copy_VarMeta(hC, air_season)

idxH = (/6,21,31,39/)
idxL = (/5,10,11,18,25,34/)

ave1 = dim_avg_n_Wrap(air_season(idxH,:,:), 0)
var1 = dim_stddev_n_Wrap(air_season(idxH,:,:), 0)
s1 = dimsizes(idxH)

ave2 = dim_avg_n_Wrap(air_season(idxL,:,:), 0)
var2 = dim_stddev_n_Wrap(air_season(idxL,:,:), 0)
s2 =  dimsizes(idxL)


hgt_high_ave = ave1
hgt_high_var = var1
hgt_low_ave = ave2
hgt_low_var = var2

n_high = s1
n_low = s2

diff = ave1-ave2
tval = diff/sqrt( ( (n_high-1.)*hgt_high_var^2+(n_low-1.)*hgt_low_var^2+0.000000001)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
tval = abs(tval)

diff = diff * 1E4
copy_VarMeta(ave1,diff)
copy_VarMeta(ave1,tval)

ttestval =1.860



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

  res@mpGridAndLimbOn        = False  
res@pmTickMarkDisplayMode  = "Always"
res@mpGridLatSpacingF      = 5
res@mpGridLonSpacingF      = 5

res@mpGridLineDashPattern  = 5


res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(-6, 6, 1)
;res@cnFillColors = (/2,3,4,5,6,7,0,0,12,13,14,15,16,17/)

;res@cnLineThicknessF = 3

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

res@mpLandFillColor="white"

res@mpPerimOn   = True

fff=asciiread("tibet_shape",(/2066,2/),"float")

do ii = 0, 72
do jj = 0, 143

if(gc_inout(lat_wind(ii),lon_wind(jj),fff(:,1),fff(:,0))) then
          diff(ii,jj) = diff@_FillValue
          tval(ii,jj) = tval@_FillValue
end if

end do
end do

wks = gsn_open_wks("eps", "PRE-only-one-"+season)
gsn_define_colormap(wks,"BlueYellowRed")


map = gsn_csm_contour_map(wks, diff, res)



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.004
resshade@cnFillColor = "red"
resshade@cnFillScaleF = 2.0

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""


tval=smth9_Wrap(tval, 0.5, -0.25, False)



map3 = gsn_csm_contour(wks, tval, resshade)
overlay(map,map3)





resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 4    ; polylines thickness
poli=gsn_add_polyline(wks,map,fff(:,0),fff(:,1),resp)



delete(airs)
delete(air)
delete(year)
delete(year_idx)
delete(diff)
delete(lat_wind)
delete(lon_wind)
delete(hA)
delete(hB)
delete(hC)
delete(air_season)
delete(ave1)
delete(var1)
delete(s1)
delete(ave2)
delete(var2)
delete(s2)
delete(hgt_high_ave)
delete(hgt_high_var)
delete(hgt_low_ave)
delete(hgt_low_var)
delete(tval)







us = airfile->uq_int
vs = airfile->vq_int

lat_wind = airfile->lat
lon_wind = airfile->lon
year=calendar_decode2(airfile->time,0)
year_idx=ind(year(:,0).ge.(yearstart).and.year(:,0).le.(yearend))

level = airfile->level

uu = us(year_idx,:,:)
vv = vs(year_idx,:,:)

uA = uu(idx_A::12,:,:)
uB = uu(idx_B::12,:,:)
uC = uu(idx_C::12,:,:)
u_season = (uA + uB + uC) / 3.0 
copy_VarMeta(uC, u_season)

vA = vv(idx_A::12,:,:)
vB = vv(idx_B::12,:,:)
vC = vv(idx_C::12,:,:)
v_season = (vA + vB + vC) / 3.0 
copy_VarMeta(vC, v_season)


s1 = dimsizes(idxH)
s2 =  dimsizes(idxL)

n_high = s1
n_low = s2


uave1 = dim_avg_n_Wrap(u_season(idxH,:,:), 0)
uvar1 = dim_stddev_n_Wrap(u_season(idxH,:,:), 0)

uave2 = dim_avg_n_Wrap(u_season(idxL,:,:), 0)
uvar2 = dim_stddev_n_Wrap(u_season(idxL,:,:), 0)

u_high_ave = uave1
u_high_var = uvar1
u_low_ave = uave2
u_low_var = uvar2

udiff = uave1-uave2
utval = udiff/sqrt( ( (n_high-1.)*u_high_var^2+(n_low-1.)*u_low_var^2+0.000000001)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
utval = abs(utval)
copy_VarMeta(uave1,udiff)
copy_VarMeta(uave1,utval)


vave1 = dim_avg_n_Wrap(v_season(idxH,:,:), 0)
vvar1 = dim_stddev_n_Wrap(v_season(idxH,:,:), 0)

vave2 = dim_avg_n_Wrap(v_season(idxL,:,:), 0)
vvar2 = dim_stddev_n_Wrap(v_season(idxL,:,:), 0)

v_high_ave = vave1
v_high_var = vvar1
v_low_ave = vave2
v_low_var = vvar2

vdiff = vave1-vave2
vtval = vdiff/sqrt( ( (n_high-1.)*v_high_var^2+(n_low-1.)*v_low_var^2+0.000000001)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
vtval = abs(vtval)
copy_VarMeta(vave1,vdiff)
copy_VarMeta(vave1,vtval)

do ii = 0, 72
do jj = 0, 143

if(gc_inout(lat_wind(ii),lon_wind(jj),fff(:,1),fff(:,0))) then
          udiff(ii,jj) = udiff@_FillValue
          vdiff(ii,jj) = vdiff@_FillValue
end if

end do
end do


u_sig = where(utval.ge.ttestval.or.vtval.ge.ttestval,udiff,udiff@_FillValue) / 1000.0
u_not_sig = where(utval.lt.ttestval.and.vtval.lt.ttestval,udiff,udiff@_FillValue) / 1000.0

v_sig = where(utval.ge.ttestval.or.vtval.ge.ttestval,vdiff,vdiff@_FillValue) / 1000.0
v_not_sig = where(utval.lt.ttestval.and.vtval.lt.ttestval,vdiff,vdiff@_FillValue) / 1000.0

copy_VarMeta(vave1,u_sig)
copy_VarMeta(vave1,u_not_sig)


copy_VarMeta(vave1,v_sig)
copy_VarMeta(vave1,v_not_sig)

resvc                  = True                      ; plot mods desired
resvc@gsnDraw=False
resvc@gsnFrame=False
resvc@gsnAddCyclic=False
resvc@gsnMaximize=True

resvc@gsnLeftString=""
resvc@gsnRightString=""

resvc@vcMinDistanceF=0.02

resvc@vcRefMagnitudeF  = 0.3
resvc@vcRefLengthF     = 0.025

resvc@vcGlyphStyle="FillArrow"
resvc@vcLineArrowThicknessF=2.6

resvc@vcRefAnnoOn               = True
resvc@vcRefAnnoString1          = "0.3"
resvc@vcRefAnnoSide             = "Top"
resvc@vcRefAnnoString2On        = False
resvc@vcRefAnnoPerimOn          = False
resvc@vcRefAnnoOrthogonalPosF   = -1.00
resvc@vcRefAnnoParallelPosF     = 0.050
resvc@vcRefAnnoBackgroundColor  = "green"
resvc@vcVectorDrawOrder         = "PostDraw"
resvc@vcFillArrowWidthF=0.05
resvc@vcFillArrowHeadYF=0.07

resvc@vcMonoFillArrowFillColor =True
resvc@vcFillArrowFillColor="black"
resvc@vcFillArrowEdgeColor="black"
resvc@vcGlyphOpacityF = 1.0



resvc@gsnLeftString=""
resvc@gsnRightString=""



map111 = gsn_csm_vector(wks,u_sig,v_sig,resvc)


resvc@vcGlyphOpacityF = 0.3
map222 = gsn_csm_vector(wks,u_not_sig,v_not_sig,resvc)


overlay(map,map111)
overlay(map,map222)





draw(map)
frame(wks)




lat1 = 27.5
lat2 = 37.5
lon1 = 105
lon2 = 135

lat1_to_lat2 = ind(lat_wind.ge.lat1.and.lat_wind.le.lat2)
lon1_to_lon2 = ind(lon_wind.ge.lon1.and.lon_wind.le.lon2)

idxlat1 = ind(lat_wind.eq.lat1)
idxlat2 = ind(lat_wind.eq.lat2)
idxlon1 = ind(lon_wind.eq.lon1)
idxlon2 = ind(lon_wind.eq.lon2)

northLat1 = dim_sum_n_Wrap(vdiff(idxlat1,lon1_to_lon2),0)
northLat2 = dim_sum_n_Wrap(vdiff(idxlat2,lon1_to_lon2),0)

zonalLon1 = dim_sum_n_Wrap(udiff(lat1_to_lat2,idxlon1),0)
zonalLon2 = dim_sum_n_Wrap(udiff(lat1_to_lat2,idxlon2),0)

print("meridional 27.5: " + northLat1)
print("meridional 37.5: " + northLat2)
print("zonal 105: " + zonalLon1)
print("zonal 135: " + zonalLon2)