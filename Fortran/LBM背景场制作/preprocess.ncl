load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"

START_YEAR = 1979
END_YEAR = 2014

f1 = addfile("./nc/air.mon.mean.nc","r")
f2 = addfile("./nc/hgt.mon.mean.nc","r")  
f3 = addfile("./nc/omega.mon.mean.nc","r")
f4 = addfile("./nc/rhum.mon.mean.nc","r")  
f5 = addfile("./nc/uwnd.mon.mean.nc","r")
f6 = addfile("./nc/vwnd.mon.mean.nc","r")
f7 = addfile("./nc/pres.sfc.mon.mean.nc","r")

time = calendar_decode2(f1->time,0)
year_idx=ind(time(:,0).ge.START_YEAR.and.time(:,0).le.END_YEAR)
lat = f1->lat
lon = f1->lon
level = f1->level

air = short2flt(f1->air)
hgt = short2flt(f2->hgt)
omega = short2flt(f3->omega)
rhum = short2flt(f4->rhum)
uwnd = short2flt(f5->uwnd)
vwnd = short2flt(f6->vwnd)
pres = short2flt(f7->pres)
q    = mixhum_ptrh(conform(air,level,1),air,rhum,2) 
copy_VarCoords(air,q)

air_clim = clmMonTLLL(air(year_idx,:,:,:))
hgt_clim = clmMonTLLL(hgt(year_idx,:,:,:))
omega_clim = clmMonTLLL(omega(year_idx,:,:,:))
rhum_clim = clmMonTLLL(rhum(year_idx,:,:,:))
uwnd_clim = clmMonTLLL(uwnd(year_idx,:,:,:))
vwnd_clim = clmMonTLLL(vwnd(year_idx,:,:,:))
pres_clim = clmMonTLL(pres(year_idx,:,:))
q_clim = clmMonTLLL(q(year_idx,:,:,:))

level1 = (/1000., 925., 850., 700., 600., 500., 400., 300./)
level2 = (/1000., 925., 850., 700., 600., 500., 400., 300., 250., 200., 150., 100./)

air_out = new((/12,17,73,144/),"float")
hgt_out = new((/12,17,73,144/),"float")
uwnd_out = new((/12,17,73,144/),"float")
vwnd_out = new((/12,17,73,144/),"float")

omega_out = new((/12,12,73,144/),"float")

rhum_out = new((/12,8,73,144/),"float")
q_out = new((/12,8,73,144/),"float")

pres_out = new((/12,1,73,144/),"float")

air_out = air_clim(month|:,level|:,lat|::-1,lon|:)
hgt_out = hgt_clim(month|:,level|:,lat|::-1,lon|:)
uwnd_out = uwnd_clim(month|:,level|:,lat|::-1,lon|:)
vwnd_out = vwnd_clim(month|:,level|:,lat|::-1,lon|:)

omega_out = omega_clim(month|:,level|0:11,lat|::-1,lon|:)
omega_out!1="level2"
omega_out&level2=level2

rhum_out = rhum_clim(month|:,level|0:7,lat|::-1,lon|:)
rhum_out!1="level1"
rhum_out&level1=level1

q_out = q_clim(month|:,level|0:7,lat|::-1,lon|:)
q_out!1="level1"
q_out&level1=level1

pres_out(:,0,:,:) = pres_clim(month|:,lat|::-1,lon|:)
;printVarSummary(omega_out)
;air_out = air_clim(lon|:,lat|::-1,level|:,month|:)
;hgt_out = hgt_clim(lon|:,lat|::-1,level|:,month|:)
;omega_out = omega_clim(lon|:,lat|::-1,level|:,month|:)
;rhum_out = rhum_clim(lon|:,lat|::-1,level|:,month|:)
;uwnd_out = uwnd_clim(lon|:,lat|::-1,level|:,month|:)
;vwnd_out = vwnd_clim(lon|:,lat|::-1,level|:,month|:)
;q_out = q_clim(lon|:,lat|::-1,level|:,month|:)


outfile = addfile("ncep.nc","c")
outfile->level = level
outfile->level1 = level1
outfile->level2 = level2
outfile->lon = lon
outfile->lat = lat(::-1)
outfile->air = air_out
outfile->hgt = hgt_out
outfile->omega = omega_out
outfile->rhum = rhum_out
outfile->uwnd = uwnd_out
outfile->vwnd = vwnd_out
outfile->q = q_out
outfile->pres = pres_out
