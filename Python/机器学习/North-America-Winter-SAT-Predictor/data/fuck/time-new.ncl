load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

year_start = 1979
year_end = 2017

ntime = year_end - year_start + 1

f1 = asciiread("winter.txt", ntime, "float")
f2 = asciiread("winter2.txt", ntime, "float")
f3 = asciiread("winter3.txt", ntime, "float")

data = new((/ntime,3/),float)
data(:,0) = f1
data(:,1) = f2
data(:,2) = f3

rts           = True

rts@gsnScale  = True
rts@gsnDraw   = False
rts@gsnFrame  = False
rts@vpWidthF  = 0.75
rts@vpHeightF = 0.26
rts@tiYAxisString = ""
rts@gsnMaximize=True
rts@trYMinF   = -3.0        ; min value on y-axis
rts@trYMaxF   =  3.0        ; max value on y-axis
rts@tmXTOn=False
rts@tmYROn=False
rts@tmXBLabelFontHeightF=0.01
rts@tmYLLabelFontHeightF=0.01

rts2 = rts

rts@gsnXYBarChart         = False
rts@gsnYRefLine           = 0.
;rts@gsnXYBarChartBarWidth = 0.7
rts@xyLineThicknessF = 4.


;rts2 = rts
rts2@gsnXYBarChart         = True
rts2@gsnYRefLine           = 0.
rts2@gsnAboveYRefLineColor = "orange"
rts2@gsnBelowYRefLineColor = "green3"
rts2@gsnXYBarChartBarWidth = 0.25 

rts3 = rts2
rts3@gsnXYBarChartBarWidth = 0.65 
rts3@gsnAboveYRefLineColor = "white"
rts3@gsnBelowYRefLineColor = "white"

;rts@xyMarker         = 16
;rts@xyMarkLineMode   = "MarkLines"


wks=gsn_open_wks("png","time-n")

p5=gsn_csm_xy3(wks,ispan(year_start,year_end,1),f1,f2,f3,rts3,rts2,rts)

print(escorc(f1,f2))
print(escorc(f1,f3))
print(escorc(f2,f3))

draw(wks)
frame(wks)
