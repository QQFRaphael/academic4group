; convert the regrided weekly data to monthly
; start from 1966-10-03, weekly data

outfile = addfile("out.nc", "r")
scin = outfile->snowcover
nweek = dimsizes(outfile->time)

lat = outfile->lat
nlat = dimsizes(lat)

lon = outfile->lon
nlon = dimsizes(lon)


daily = new((/nweek*7,nlat,nlon/),"float")

do ii=0,nweek-1
    daily(ii*7,:,:) = scin(ii,:,:)
    daily(ii*7+1,:,:) = scin(ii,:,:)
    daily(ii*7+2,:,:) = scin(ii,:,:)
    daily(ii*7+3,:,:) = scin(ii,:,:)
    daily(ii*7+4,:,:) = scin(ii,:,:)
    daily(ii*7+5,:,:) = scin(ii,:,:)
    daily(ii*7+6,:,:) = scin(ii,:,:)
end do 

time = ispan(1,nweek*7,1)
time@units = "days since 1966-10-03"
time@long_name = "Time"
time@standard_name = "time" 
time@calendar = "standard"

;aa=cd_calendar(time,0)
;print(aa(:,0)+"year "+aa(:,1)+"mon "+aa(:,2))

daily&time = time

;printVarSummary(daily) 

ss=calculate_monthly_values(daily(89:18716,:,:), "avg", 0, True)
sco = round(ss*100.0,1)
copy_VarMeta(ss, sco)
sco@_FillValue = -900
sco@missing_value = -900
delete(sco@valid_range)

;print(sco(0,:,:))




mysc = addfile("mysnowcover.nc","c")
mysc->snowcover = sco
mysc->lat = lat
mysc->lon = lon