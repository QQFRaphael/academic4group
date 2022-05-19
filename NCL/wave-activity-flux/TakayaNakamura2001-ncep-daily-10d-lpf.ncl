; 3-D wave-activity flux derived by Takaya and Nakamura (1999, 2001)
; See (38) of Takaya and Nakamura (2001, JAS)
;
; Used data: 
;  Daily-mean data of NCEP/NCAR reanalys 1
;   geopotential height (hgt: m) ; hgt.1999.nc hgt.2000.nc hgt.2001.nc 
;
;  Daily climatology of NCEP/NCAR reanalys 1 (365 days)
;   geopotential height (hgt: m) ; hgt.day.ltm.nc
;   air tempeature (air: degK)   ; air.day.ltm.nc
;   zonal wind (uwnd: m/s)       ; uwnd.day.ltm.nc
;   meridional wind (vwnd: m/s)  ; vwnd.day.ltm.nc
;
; The data are available at 
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html
;
; The period for calcuation is 1st January, 2000 to 31th December, 2000
; (see variables of fyear,fmon, fday, lyear, lmon, lday)
;
; The unit of level is [hPa]
;
; Basic state: daily climatology
;
; Perturbation: deviation from climatology for each calendar day
;
; Calculating the flux for each day of input data.
;
; Note that 
; (i)  10-day low-pass filter is applied
;       (Assume that phase speed (Cp) is almost zero)
;
; (ii) "p" (pressure) in Eq. (5.7) is dimensionless (pressure/1000mb)
;
; (iii) The year 2000 is a leap year (366 days)
;
; (iv)  Using height data of 1999 and 2001 is for time filtering. 
;       The filter makes the first and last several days unavailable.

; Output files are
; x-component:  TN2001-Fx.daily.2000.nc
; y-component:  TN2001-Fy.daily.2000.nc
; z-component:  TN2001-Fz.daily.2000.nc
; daily QG stream function anomaly: psidev.daily.2000.nc
; Brunt Vaisala frequency: NN.daily.2000.nc

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; The first date of calculation
fyear = 2000
fmon = 1
fday = 1

; The last date of calculation
lyear = 2000
lmon = 12
lday = 31

;  direcotry name
diri = "/e4b/ncep/plev/daily_mean/nc/"
dirci = "/e4b/ncep/plev/daily24h-climate/nc/"
;
; daily mean data
; modify direcotry name
filenames = systemfunc("ls "+diri+"hgt.1999.nc "+diri+"hgt.2000.nc "+diri+"hgt.2001.nc")
zfile = addfiles(filenames,"r")

ListSetType (zfile, "cat")

; daily climatology data
filename = systemfunc("ls "+dirci+"air.day.ltm.nc")
btfile = addfile(filename,"r")
filename = systemfunc("ls "+dirci+"hgt.day.ltm.nc")
bzfile = addfile(filename,"r")
filename = systemfunc("ls "+dirci+"uwnd.day.ltm.nc")
bufile = addfile(filename,"r")
filename = systemfunc("ls "+dirci+"vwnd.day.ltm.nc")
bvfile = addfile(filename,"r")


; Test a variable's type prior to reading the variable
if (getfilevartypes(zfile[0],"hgt").eq."short")then
zvarorg = short2flt(zfile[:]->hgt)
else
zvarorg = zfile[:]->hgt
end if

if (getfilevartypes(btfile,"air").eq."short")then
btvar = short2flt(btfile->air)
else
btvar = btfile->air
end if

if (getfilevartypes(bzfile,"hgt").eq."short")then
bzvar = short2flt(bzfile->hgt)
else
bzvar = bzfile->hgt
end if

if (getfilevartypes(bufile,"uwnd").eq."short")then
buvar = short2flt(bufile->uwnd)
else
buvar = bufile->uwnd
end if

if (getfilevartypes(bvfile,"vwnd").eq."short")then
bvvar = short2flt(bvfile->vwnd)
else
bvvar = bvfile->vwnd
end if

time = zfile[:]->time
lat = zfile[0]->lat
lon = zfile[0]->lon
level = zfile[0]->level

ntime = dimsizes(time)
nlat = dimsizes(lat)
nlon = dimsizes(lon)
nlevel = dimsizes(level)

; for climatology
btime = btfile->time
nbtime = dimsizes(btime)

; Calendar for input file
; Assume that the calendar is "standard" (gregorian).
time@calendar = "standard"
option = 0
option@calendar = time@calendar
utc_date = cd_calendar( time,option)

; corresponding date of time(0) (not necesarily the same as the first date of the data)
syear = utc_date(0,0)
smon = utc_date(0,1)
sday = utc_date(0,2)

; Calendar for input file of daily climatology
; Assume that the calendar is "standard" (Gregorian).
btime@calendar = "standard"
option = 0
option@calendar = btime@calendar
butc_date = cd_calendar( btime(0),option)

; The first date of btime (not necesarily the same as the first date of the data)
bsyear = tointeger(butc_date(0,0))
bsmon = tointeger(butc_date(0,1))
bsday = tointeger(butc_date(0,2))
bshour = tointeger(butc_date(0,3))
bsmin = tointeger(butc_date(0,4))
bssec = tointeger(butc_date(0,5))

; time interval of the calendar
dtime = time(1)-time(0)
dbtime = btime(1)-btime(0)

fhh = 0
fmin = 0
fsec = 0

; in time() (double)
fdate = cd_inv_calendar(fyear,fmon,fday,fhh,fmin,fsec,time@units,option)

; time step of the first date of the calculation (integer)
fstep = tointeger((fdate - time(0))/dtime)

ldate = cd_inv_calendar(lyear,lmon,lday,fhh,fmin,fsec,time@units,option)

; time step of the last date of the calculation
lstep = tointeger((ldate - time(0))/dtime)

; new "time array" for output data

ctime = time(fstep:lstep)
nctime = dimsizes(ctime)

;10-day low-pass fileter
wgt = filwgts_lanczos(21, 0,0.1, -999.,1)
zvarorgb = wgt_runave_n_Wrap(zvarorg,wgt,0,0)

zvar = zvarorgb(fstep:lstep,:,:,:)

; make arrays for climatology that are suitable for calculation
; bzvar <- bzvarorg
; btvar <- btvarorg

czvar = new((/nctime,nlevel,nlat,nlon/),float,zvarorg@_FillValue)
ctvar = new((/nctime,nlevel,nlat,nlon/),float,zvarorg@_FillValue)
cuvar = new((/nctime,nlevel,nlat,nlon/),float,zvarorg@_FillValue)
cvvar = new((/nctime,nlevel,nlat,nlon/),float,zvarorg@_FillValue)

czvar@_FillValue = zvarorg@_FillValue
ctvar@_FillValue = zvarorg@_FillValue
cuvar@_FillValue = zvarorg@_FillValue
cvvar@_FillValue = zvarorg@_FillValue

do istep = 0,nctime-1

iyear = tointeger(utc_date(fstep + istep,0))
imon = tointeger(utc_date(fstep + istep,1))
iday = tointeger(utc_date(fstep + istep,2))

;The climatological value of leap day is replaced by 28th February
if (isleapyear(iyear) .and. imon .eq. 2 .and. iday .eq. 29) then
; 29feb -> 28feb
iday = 28
end if

idate = cd_inv_calendar(bsyear,imon,iday,bshour,bsmin,bssec,btime@units,option)
jstep  = tointeger((idate-btime(0))/dbtime)
czvar(istep,:,:,:) = bzvar(jstep,:,:,:)
ctvar(istep,:,:,:) = btvar(jstep,:,:,:)
cuvar(istep,:,:,:) = buvar(jstep,:,:,:)
cvvar(istep,:,:,:) = bvvar(jstep,:,:,:)
end do

;height anomaly
zavar = zvar - czvar
delete(czvar)
delete(bzvar)
delete(btvar)
delete(buvar)
delete(bvvar)

;  Gas constant
gc=290
;  Gravitational acceleration
ga=9.80665

;  Radius of the earth
re=6378388

; scale height
sclhgt=8000.

; pi
pi = atan(1.0)*4.

; Coriolis parameter
f =  2.*2.*pi/(60.*60.*24.)*sin(pi/180. * lat(:))
f!0 = "lat"
f&lat = lat
f@_FillValue = zvarorg@_FillValue

; missing for 10S - 10N
do ilat = 0, nlat-1
if (abs(lat(ilat) ).lt. 10. ) then
f(ilat)= f@_FillValue
end if
end do

; cosine
coslat = cos(lat(:)*pi/180.)

; 1-D -> 4-D
leveltmp = conform_dims(dimsizes(zvar),level,1)
coslattmp = conform_dims(dimsizes(zvar),coslat,2)
ftmp = conform_dims(dimsizes(zvar),f,2)

; vertical gradient of potential temperature  (K/m)
dthetadz = center_finite_diff_n(ctvar*(1000./leveltmp)^0.286,-sclhgt*log(level/1000),False,0,1)

; Brunt Vaisala frequency
NN = (gc*(leveltmp/1000.)^0.286)/sclhgt * dthetadz
NN@_FillValue = ctvar@_FillValue
NN = where(NN .gt. 0, NN, NN@_FillValue)

; magnitude of climatological wind
cumag = sqrt(cuvar^2 + cvvar^2)
cumag@_FillValue = cuvar@_FillValue
cumag = where(cumag .gt. 0, cumag, cumag@_FillValue)

; QG steam function for anomaly
psidev = zavar*ga /ftmp

;dpsidev/dlon
dpsidevdlon =  center_finite_diff_n(psidev,lon*pi/180.,True,0,3)

;ddpsidev/dlonlon
ddpsidevdlonlon =  center_finite_diff_n(dpsidevdlon,lon*pi/180.,True,0,3)

;dpsidev/dlat
dpsidevdlat = center_finite_diff_n(psidev, lat*pi/180., False,0,2)

;ddpsidev/dlonlat
ddpsidevdlonlat =  center_finite_diff_n(dpsidevdlon,lat*pi/180.,False,0,2)

;ddpsidev/dlatdlat
ddpsidevdlatlat = center_finite_diff_n(dpsidevdlat, lat*pi/180.,False,0,2)

;dpsidev/dz
dpsidevdz = center_finite_diff_n(psidev, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dlondz
ddpsidevdlonz = center_finite_diff_n(dpsidevdlon, -sclhgt*log(level/1000),False,0,1)

;ddpsidev/dlatdz
ddpsidevdlatz = center_finite_diff_n(dpsidevdlat, -sclhgt*log(level/1000),False,0,1)

xuterm = (dpsidevdlon*dpsidevdlon - psidev*ddpsidevdlonlon)
xvterm = (dpsidevdlon*dpsidevdlat - psidev*ddpsidevdlonlat)
;yuterm = xvterm
yvterm = (dpsidevdlat*dpsidevdlat - psidev*ddpsidevdlatlat)

zuterm = (dpsidevdlon*dpsidevdz - psidev*ddpsidevdlonz)
zvterm = (dpsidevdlat*dpsidevdz - psidev*ddpsidevdlatz)

; Mask out where westerlies is small or negative (less than 5 m/s).
;  by using mask

;x-component of (38)
Fx = mask( leveltmp/1000./(2.*cumag*re*re)*( cuvar/coslattmp * xuterm + cvvar * xvterm), cuvar.lt.5,False)

;y-component 
Fy = mask(leveltmp/1000./(2.*cumag*re*re)*( cuvar*xvterm + coslattmp*cvvar*yvterm),  cuvar.lt.5,False)

;z-component 
Fz = mask(leveltmp/1000.*ftmp*ftmp/(2.*cumag*NN*re)*(cuvar*zuterm + coslattmp*cvvar*zvterm), cuvar.lt.5, False)

; for output
Fx!0 = "time"
Fx&time = ctime
Fx!1 = "level"
Fx&level = level
Fx!2 = "lat"
Fx&lat = lat
Fx!3 = "lon"
Fx&lon = lon

Fy!0 = "time"
Fy&time = ctime
Fy!1 = "level"
Fy&level = level
Fy!2 = "lat"
Fy&lat = lat
Fy!3 = "lon"
Fy&lon = lon

Fz!0 = "time"
Fz&time = ctime
Fz!1 = "level"
Fz&level = level
Fz!2 = "lat"
Fz&lat = lat
Fz!3 = "lon"
Fz&lon = lon

psidev!0 = "time"
psidev&time = ctime
psidev!1 = "level"
psidev&level = level
psidev!2 = "lat"
psidev&lat = lat
psidev!3 = "lon"
psidev&lon = lon

NN!0 = "time"
NN&time = ctime
NN!1 = "level"
NN&level = level
NN!2 = "lat"
NN&lat = lat
NN!3 = "lon"
NN&lon = lon

Fx@units = "m^2/s^2"
Fx@units = "m^2/s^2"
Fz@units = "m^2/s^2"

psidev@units = "m^2/s"

NN@units = "1/s^2"

ncFx =     addfile("TN2001-Fx.daily.2000.nc","c")
ncFy =     addfile("TN2001-Fy.daily.2000.nc","c")
ncFz =     addfile("TN2001-Fz.daily.2000.nc","c")
ncpsidev = addfile("psidev.daily.2000.nc","c")
ncNN =     addfile("NN.daily.2000.nc","c")

ncFx->Fx = Fx
ncFy->Fy = Fy
ncFz->Fz = Fz
ncpsidev->psidev = psidev

ncNN->NN = NN
end

