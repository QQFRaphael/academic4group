
data = asciiread("data.txt",(/8,4/),"float")


rts           = True

rts@gsnScale  = True
rts@gsnDraw   = False
rts@gsnFrame  = False
rts@vpWidthF  = 0.45
rts@vpHeightF = 0.26
rts@tiYAxisString = ""
rts@gsnMaximize=True
rts@trYMinF   = -150.0        ; min value on y-axis
rts@trYMaxF   =  450.0        ; max value on y-axis
rts@tmXTOn=False
rts@tmXBOn=False
rts@tmYROn=False
rts@tmXBLabelFontHeightF=0.01
rts@tmYLLabelFontHeightF=0.02

rts2 = rts

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.
;rts@gsnXYBarChartBarWidth = 0.7
rts@gsnAboveYRefLineColor = "green"
rts@gsnBelowYRefLineColor = "green"
rts@gsnXYBarChartBarWidth = 0.15 


;rts2 = rts
rts2@gsnXYBarChart         = True
rts2@gsnYRefLine           = 0.
rts2@gsnAboveYRefLineColor = "orange"
rts2@gsnBelowYRefLineColor = "orange"
rts2@gsnXYBarChartBarWidth = 0.25 


;rts@xyMarker         = 16
;rts@xyMarkLineMode   = "MarkLines"


wks=gsn_open_wks("eps","time-n")

p5=gsn_csm_xy2(wks,fspan(1,2,4),data(0,:),data(1,:),rts2,rts)

draw(wks)
frame(wks)
