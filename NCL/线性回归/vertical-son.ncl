load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; SON
season = "SON"
idx_A = 8
idx_B = 9
idx_C = 10

yearstart = 1979
yearend = 1994
nyear = yearend - yearstart + 1

ttestval = 2.120

snow = asciiread("../../fig01/before.txt",(/nyear/),"float")

uwindfile = addfile("../../ncfile/ncep2nc/uwnd.mon.mean.nc","r")
vwindfile = addfile("../../ncfile/ncep2nc/omega.mon.mean.nc","r")
airfile = addfile("../../ncfile/ncep2nc/hgt.mon.mean.nc","r")
tfile = addfile("../../ncfile/ncep2nc/air.mon.mean.nc","r")

uwinds = short2flt(uwindfile->uwnd(0:473,:,:,:))
vwinds = short2flt(vwindfile->omega(0:473,:,:,:))
airs = short2flt(airfile->hgt)
tt = short2flt(tfile->air)

lat_wind = uwindfile->lat
lon_wind = uwindfile->lon
year=calendar_decode2(uwindfile->time,0)
year_idx=ind(year(:,0).ge.(yearstart).and.year(:,0).le.(yearend))









lon1 = 30
lon2 = 150
lat_idx = ind(lat_wind.eq.32.5)










level = airfile->level
levels = conform(vwinds, level, 1)

;printVarSummary(vwinds)
;printVarSummary(levels)
;printVarSummary(tt)

vwindss = omega_to_w(vwinds,levels,tt)*10

uwind= uwinds(year_idx,:,:,:)
vwind = vwindss(year_idx,:,:,:)
air = airs(year_idx,:,:,:)

uA = uwind(idx_A::12,:,:,:)
uB = uwind(idx_B::12,:,:,:)
uC = uwind(idx_C::12,:,:,:)
uwind_season = (uA + uB + uC) / 3.0

vA = vwind(idx_A::12,:,:,:)
vB = vwind(idx_B::12,:,:,:)
vC = vwind(idx_C::12,:,:,:)
vwind_season = (vA + vB + vC) / 3.0

hA = air(idx_A::12,:,:,:)
hB = air(idx_B::12,:,:,:)
hC = air(idx_C::12,:,:,:)
air_season = (hA + hB + hC) / 3.0 

rc_uwind = regCoef_n(snow, uwind_season, 0, 0)
rc_vwind = regCoef_n(snow, vwind_season, 0, 0)
rc_air = regCoef_n(snow, air_season, 0, 0)


tval_uwind = reshape(abs(rc_uwind@tval),(/dimsizes(rc_uwind(:,0,0)),dimsizes(rc_uwind(0,:,0)),dimsizes(rc_uwind(0,0,:))/))
tval_vwind = reshape(abs(rc_vwind@tval),(/dimsizes(rc_vwind(:,0,0)),dimsizes(rc_vwind(0,:,0)),dimsizes(rc_vwind(0,0,:))/))
tval_air = reshape(abs(rc_air@tval),(/dimsizes(rc_air(:,0,0)),dimsizes(rc_air(0,:,0)),dimsizes(rc_air(0,0,:))/))

u_sig = where(tval_uwind.ge.ttestval.or.tval_vwind.ge.ttestval,rc_uwind,rc_uwind@_FillValue)
u_not_sig = where(tval_uwind.lt.ttestval.and.tval_vwind.lt.ttestval,rc_uwind,rc_uwind@_FillValue)

v_sig = where(tval_uwind.ge.ttestval.or.tval_vwind.ge.ttestval,rc_vwind,rc_vwind@_FillValue)
v_not_sig = where(tval_uwind.lt.ttestval.and.tval_vwind.lt.ttestval,rc_vwind,rc_vwind@_FillValue)




ff = addfile("../../ncfile/ncep2nc/hgt.sfc.nc", "r")
typography = short2flt(ff->hgt(0,:,:))
typography = 1013.25*(1-typography*0.0065/288.15)^5.25145
typo = conform(rc_air, typography, (/1,2/))
lev = conform(rc_air, level, (/0/))





copy_VarMeta(uwind(0,:,:,:),rc_uwind)
copy_VarMeta(vwind(0,:,:,:),rc_vwind)
copy_VarMeta(air(0,:,:,:),rc_air)


copy_VarMeta(uwind(0,:,:,:),tval_uwind)
copy_VarMeta(vwind(0,:,:,:),tval_vwind)
copy_VarMeta(air(0,:,:,:),tval_air)

copy_VarMeta(uwind(0,:,:,:),u_sig)
copy_VarMeta(vwind(0,:,:,:),v_sig)

copy_VarMeta(uwind(0,:,:,:),u_not_sig)
copy_VarMeta(vwind(0,:,:,:),v_not_sig)



rc_air2 = mask(rc_air,typo.lt.lev,False)
rc_uwind2 = mask(rc_uwind,typo.lt.lev,False)
rc_vwind2 = mask(rc_vwind,typo.lt.lev,False)

tval_air2 = mask(tval_air,typo.lt.lev,False)
tval_uwind2 = mask(tval_uwind,typo.lt.lev,False)
tval_vwind2 = mask(tval_vwind,typo.lt.lev,False)

u_sig2 = mask(u_sig,typo.lt.lev,False)
u_not_sig2 = mask(u_not_sig,typo.lt.lev,False)

v_sig2 = mask(v_sig,typo.lt.lev,False)
v_not_sig2 = mask(v_not_sig,typo.lt.lev,False)

copy_VarMeta(rc_air,rc_air2)
copy_VarMeta(rc_uwind,rc_uwind2)
copy_VarMeta(rc_vwind,rc_vwind2)


copy_VarMeta(tval_air,tval_air2)
copy_VarMeta(tval_uwind,tval_uwind2)
copy_VarMeta(tval_vwind,tval_vwind2)

copy_VarMeta(u_sig,u_sig2)
copy_VarMeta(u_not_sig,u_not_sig2)

copy_VarMeta(v_sig,v_sig2)
copy_VarMeta(v_not_sig,v_not_sig2)



;print(u_not_sig2(0,:,:))
;print(v_not_sig2(0,:,:))








res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnMaximize=True


res@vpXF = 0.13 
res@vpWidthF = 0.75 
res@vpHeightF = 0.3


res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels=(/-1.1,-0.9,-0.7,-0.5,-0.3,-0.1,0,0.1,0.3,0.5,0.7,0.9,1.1/)
res@cnLevels=fspan(-7,7,15)
;res@cnFillColors=(/18,34,50,66,82,0,0,146,162,178,194,210,226,242,255,268/)

res@lbOrientation="Vertical"


res@cnMissingValFillColor    = "gray30"

;res@cnFillOpacityF=0.8



        ;res@tmBorderThicknessF       = 6.0    ; border 6x as thick
        ;res@tmXTOn                   = False  ; Turn off top and right
        ;res@tmYROn                   = False  ; tickmarks

        res@trXMinF                  = lon1     ; Set min/max of X axis
        res@trXMaxF                  = lon2
        res@trYReverse               = True   ; Reverse Y axis

        res@trYMinF                  = 150

ind_lon = ind(lon_wind.ge.lon1.and.lon_wind.le.lon2)
mlon = dimsizes(ind_lon)

res@tmXBMode   = "Explicit"
       res@tmXBValues = ispan(lon1,lon2,30)
       res@tmXBLabels = ispan(lon1,lon2,30)


res@gsnLeftString=""
res@gsnRightString=""

wks = gsn_open_wks("eps", "before-"+season)
gsn_define_colormap(wks,"BlueWhiteOrangeRed")


map = gsn_csm_contour(wks, rc_air2(:,lat_idx,:), res)

;print(rc_air2(:,lat_idx,:))

resvc                  = True                      ; plot mods desired
resvc@gsnDraw=False
resvc@gsnFrame=False

resvc@gsnLeftString=""
resvc@gsnRightString=""

resvc@vcMinDistanceF=0.02

resvc@vcRefMagnitudeF  = 1.4
resvc@vcRefLengthF     = 0.025

resvc@vcGlyphStyle="FillArrow"
resvc@vcLineArrowThicknessF=2.6

resvc@vcRefAnnoOn               = True
resvc@vcRefAnnoString1          = "1.4"
resvc@vcRefAnnoSide             = "Top"
resvc@vcRefAnnoString2On        = False
resvc@vcRefAnnoPerimOn          = False
resvc@vcRefAnnoOrthogonalPosF   = -0.215
resvc@vcRefAnnoParallelPosF     = 0.999
resvc@vcRefAnnoBackgroundColor  = "green"
resvc@vcVectorDrawOrder         = "PostDraw"
resvc@vcFillArrowWidthF=0.05
resvc@vcFillArrowHeadYF=0.07

resvc@vcMonoFillArrowFillColor =True
resvc@vcFillArrowFillColor="black"
resvc@vcFillArrowEdgeColor="black"


resvc@vcMapDirection   = False


resvc@tmXBOn                   = False 
;resvc@tmXBMode   = "Explicit"
;       resvc@tmXBValues = ispan(lon1,lon2,30)
;       resvc@tmXBLabels = ispan(lon1,lon2,30)

;map1 = gsn_csm_vector(wks,rc_uwind_200,rc_vwind_200,resvc)

map1 = gsn_csm_vector(wks,rc_uwind2(:,lat_idx,:),rc_vwind2(:,lat_idx,:),resvc)

overlay(map,map1)



resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=False
resshade@cnLinesOn=True
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True
resshade@gsnDraw=False
resshade@gsnFrame=False
resshade@gsnLeftString=""
resshade@gsnRightString=""
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade2 = resshade

resshade2@cnLevelSelectionMode="ExplicitLevels"
resshade2@cnLevels=(/ttestval/)
resshade2@cnLineThicknessF = 7
resshade2@cnLineColor = "purple"

resshade2@tmXBOn                   = False 


;map3 = gsn_csm_contour(wks, tval_air2(:,lat_idx,:), resshade2)
;overlay(map,map3)



draw(map)
frame(wks)
