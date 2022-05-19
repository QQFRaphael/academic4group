; this script extract snow data during target period

load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"

f = addfile("mysnowcover.nc","r")

snow = lonFlip(f->snowcover)
lat = f->lat
lon = f->lon

lon = lonFlip(lon)
lon(90:) = lon(90:) + 360.0

yearstart = 1979
yearend = 2018

year=calendar_decode2(f->time,0)
year_idx=ind(year(:,0).ge.yearstart.and.year(:,0).le.yearend)

varsss = snow(year_idx,:,:)
varss = (varsss(8::12,:,:)+varsss(9::12,:,:)+varsss(10::12,:,:))/3.0
copy_VarMeta(varsss(8::12,:,:),varss)

ff = addfile("intep_examp.nc", "r")
sc = ff->snow(::-1,:)
latsc = ff->lat_0(::-1)
lonsc = ff->lon_0

ss = linint2(lon,lat,varss,True,lonsc,latsc,0)
copy_VarMeta(sc, ss(0,:,:))
copy_VarMeta(varss(:,0,0),ss(:,0,0))

snow_mask = conform(ss, sc, (/1,2/))
snow_mask = where(.not.ismissing(snow_mask), ss, snow_mask)
copy_VarMeta(ss, snow_mask)

;id_lat = ind(latsc.ge.25.and.latsc.le.45)
;id_lon = ind(lonsc.ge.70.and.lonsc.le.105)
;snow_tibet = snow_mask(:,id_lat,id_lon) / 100.0
;copy_VarMeta(snow_mask(:,id_lat,id_lon),snow_tibet)

system("rm -rf snow.nc")
out = addfile("snow.nc","c")
out->snow = snow_mask ;snow_tibet
