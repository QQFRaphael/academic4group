load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

case="ice"

f1 = addfile("ctl.nc", "r")
f2 = addfile("ice.nc", "r")

ctl = f1->hgt(0:623,9,:,:)
snt = f2->hgt(0:623,9,:,:)

anom = snt-ctl
copy_VarMeta(ctl, anom)

nov = anom(10::12,:,:)
dec = anom(11::12,:,:)
jan = anom(12::12,:,:)

novc = ctl(10::12,:,:)
decc = ctl(11::12,:,:)
janc = ctl(12::12,:,:)


Hgt_anom = (nov(0:50,:,:)+dec(0:50,:,:)+jan(0:50,:,:))/3.0
copy_VarMeta(anom(0:50,:,:), Hgt_anom)

Hgt_clim = (novc(0:50,:,:)+decc(0:50,:,:)+janc(0:50,:,:))/3.0
copy_VarMeta(ctl(0:50,:,:), Hgt_clim)

hgt_anom = dim_avg_n_Wrap(Hgt_anom(9:49,:,:), 0)
hgt_clim = dim_avg_n_Wrap(Hgt_clim(9:49,:,:), 0)

nova = snt(10::12,:,:) * 30.0 * 24.0 * 60.0 * 60.0
deca = snt(11::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0
jana = snt(12::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0

snt_all = (nova(0:50,:,:)+deca(0:50,:,:)+jana(0:50,:,:))  * 1000.0
copy_VarMeta(anom(0:50,:,:), snt_all)

novc = ctl(10::12,:,:) * 30.0 * 24.0 * 60.0 * 60.0
decc = ctl(11::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0
janc = ctl(12::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0

ctl_all = (novc(0:50,:,:)+decc(0:50,:,:)+janc(0:50,:,:))  * 1000.0
copy_VarMeta(anom(0:50,:,:), ctl_all)

ave1 = dim_avg_n_Wrap(snt_all, 0)
var1 = dim_stddev_n_Wrap(snt_all, 0)
s1 = dimsizes(snt_all(:,0,0))

ave2 = dim_avg_n_Wrap(ctl_all, 0)
var2 = dim_stddev_n_Wrap(ctl_all, 0)
s2 = dimsizes(ctl_all(:,0,0))

hgt_high_ave = ave1
hgt_high_var = var1
hgt_low_ave = ave2
hgt_low_var = var2

n_high = s1
n_low = s2

diff = ave1-ave2
tval = diff/sqrt( ( (n_high-1.)*hgt_high_var^2+(n_low-1.)*hgt_low_var^2)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
tval = abs(tval)
copy_VarMeta(ave1,diff)
copy_VarMeta(ave1,tval)

ttestval = 1.299

lat = f1->lat
lon = f1->lon

nlat = dimsizes(lat)

;  Gas constant
gc=290
;  Gravitational acceleration
ga=9.80665

;  Radius of the earth
re=6378388

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat(:))
f!0 = "lat"
f&lat = lat
f@_FillValue = hgt_anom@_FillValue

; missing for 10S - 10N
do ilat = 0, nlat-1
if (abs(lat(ilat) ).lt. 10. ) then
f(ilat)= f@_FillValue
end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)

coslattmp = conform_dims(dimsizes(hgt_anom),coslat,0)
ftmp = conform_dims(dimsizes(hgt_anom),f,0)

bb=z2geouv(hgt_clim, lat, lon, 1)
uwnd_clim = bb(0,:,:)
vwnd_clim = bb(1,:,:)

; magnitude of climatological wind
cumag = sqrt(uwnd_clim^2 + vwnd_clim^2)
cumag@_FillValue = uwnd_clim@_FillValue
cumag = where(cumag .gt. 0, cumag, cumag@_FillValue)

; QG steam function for anomaly
psidev = hgt_anom*ga /ftmp

;dpsidev/dlon
dpsidevdlon =  center_finite_diff_n(psidev,lon*pi/180.,True,0,1)

;ddpsidev/dlonlon
ddpsidevdlonlon =  center_finite_diff_n(dpsidevdlon,lon*pi/180.,True,0,1)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n(psidev, lat*pi/180., False,0,0)

;ddpsidev/dlonlat
ddpsidevdlonlat =  center_finite_diff_n(dpsidevdlon,lat*pi/180.,False,0,0)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n(dpsidevdlat, lat*pi/180.,False,0,0)

xuterm = (dpsidevdlon*dpsidevdlon - psidev*ddpsidevdlonlon)
xvterm = (dpsidevdlon*dpsidevdlat - psidev*ddpsidevdlonlat)
;yuterm = xvterm
yvterm = (dpsidevdlat*dpsidevdlat - psidev*ddpsidevdlatlat)

; Mask out where westerlies is small or negative (less than 5 m/s).
;  by using mask


;x-component of (38)
Fx = mask( 200.0/1000./(2.*cumag*re*re)*( uwnd_clim/coslattmp * xuterm + vwnd_clim * xvterm), uwnd_clim.lt.5,False)
;Fx =mylev/1000./(2.*cumag*re*re)*( uwnd_clim/coslattmp * xuterm + vwnd_clim * xvterm)

;y-component 
Fy = mask(200.0/1000./(2.*cumag*re*re)*( uwnd_clim*xvterm + coslattmp*vwnd_clim*yvterm),  uwnd_clim.lt.5,False)
;Fy = mylev/1000./(2.*cumag*re*re)*( uwnd_clim*xvterm + coslattmp*vwnd_clim*yvterm)


fspd = sqrt(Fx*Fx+Fy*Fy)
Fx = mask(Fx, fspd.le.0.04, False)
Fy = mask(Fy, fspd.le.0.04, False)


; for output
Fx!0 = "lat"
Fx&lat = lat
Fx!1 = "lon"
Fx&lon = lon

Fy!0 = "lat"
Fy&lat = lat
Fy!1 = "lon"
Fy&lon = lon

psidev!0 = "lat"
psidev&lat = lat
psidev!1 = "lon"
psidev&lon = lon

Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"

copy_VarMeta(hgt_anom, Fx)
copy_VarMeta(hgt_anom, Fy)


res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=True
res@gsnMaximize=True


res@mpLimitMode = "LatLon"
res@mpMinLatF = 10
res@mpMaxLatF = 90
;res@mpMinLonF = -110
;res@mpMaxLonF = 150

res@mpCenterLonF=0

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(-40,40,5)


res@lbOrientation="Vertical"

res@gsnLeftString=""
res@gsnRightString=""

res@gsnPolar="NH"

wks = gsn_open_wks("eps", "wave-"+case)
gsn_define_colormap(wks,"BlueDarkRed18")

map = gsn_csm_contour_map_polar(wks, hgt_anom, res)



resvc                  = True                      ; plot mods desired
resvc@gsnDraw=False
resvc@gsnFrame=False

resvc@gsnLeftString=""
resvc@gsnRightString=""

resvc@vcMinDistanceF=0.014

resvc@vcRefMagnitudeF  = 0.2
resvc@vcRefLengthF     = 0.015

resvc@vcGlyphStyle="LineArrow"
resvc@vcLineArrowThicknessF=2.0


resvc@vcRefAnnoOn               = True
resvc@vcRefAnnoString1          = "0.2"
resvc@vcRefAnnoSide             = "Top"
resvc@vcRefAnnoString2On        = False
resvc@vcRefAnnoPerimOn          = False
resvc@vcRefAnnoOrthogonalPosF   = -0.21
resvc@vcRefAnnoParallelPosF     = 0.999
resvc@vcRefAnnoBackgroundColor  = "green"
resvc@vcVectorDrawOrder         = "PostDraw"
resvc@vcFillArrowWidthF=0.05
resvc@vcFillArrowHeadYF=0.07

resvc@vcMonoFillArrowFillColor =True
resvc@vcFillArrowFillColor = "black"
resvc@vcFillArrowEdgeColor = "white"

map1 = gsn_csm_vector(wks,Fx,Fy,resvc)

overlay(map,map1)



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.002
resshade@cnFillColor = "black"
resshade@cnFillScaleF = 0.6

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""



map3 = gsn_csm_contour(wks, tval, resshade)
overlay(map,map3)

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

typo=asciiread("/home/qqf/work/sic-non-monsoon/utils/tibet_shape",(/2066,2/),"float")
poli=gsn_add_polyline(wks,map,typo(:,0),typo(:,1),resp)



draw(map)
frame(wks)

