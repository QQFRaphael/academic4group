load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

year_start = 1971
year_end = 2018

ntime = year_end - year_start + 1

;south_tpsc = asciiread("./south-TPSC.txt",(/ntime/),"float")

f = addfile("mysvd_reg.nc", "r")

jja = f->jja_time0
mam = f->mam_time0
;south_decadal = asciiread("./south-decadal.txt",(/ntime/),"float")

rts           = True

rts@gsnScale  = True
rts@gsnDraw   = False
rts@gsnFrame  = False
rts@vpWidthF  = 0.75
rts@vpHeightF = 0.16
rts@tiYAxisString = ""
rts@gsnMaximize=True
rts@trYMinF   = -4.0        ; min value on y-axis
rts@trYMaxF   =  4.0        ; max value on y-axis
rts@tmXTOn=False
rts@tmYROn=False
rts@tmXBLabelFontHeightF=0.01
rts@tmYLLabelFontHeightF=0.01

rts2 = rts

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.
;rts@gsnXYBarChartBarWidth = 0.7
rts@gsnYRefLine           = 0.
rts@gsnAboveYRefLineColor = "white"
rts@gsnBelowYRefLineColor = "white"
rts@gsnXYBarChartBarWidth = 0.6 


;rts2 = rts
rts2@gsnXYBarChart         = True
rts2@gsnYRefLine           = 0.
rts2@gsnAboveYRefLineColor = "orange"
rts2@gsnBelowYRefLineColor = "green3"
rts2@gsnXYBarChartBarWidth = 0.3 


;rts@xyMarker         = 16
;rts@xyMarkLineMode   = "MarkLines"


wks=gsn_open_wks("eps","time-n")

p5=gsn_csm_xy2(wks,ispan(year_start,year_end,1),jja,mam,rts,rts2)

print(escorc(jja,mam))

draw(wks)
frame(wks)
