load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

mymodel = "LR"


pc1 = dim_standardize_n_Wrap(asciiread("../"+mymodel+"/"+"PC1.txt", 8, "float"),0,0)
pc2 = dim_standardize_n_Wrap(asciiread("../"+mymodel+"/"+"PC2.txt", 8, "float"),0,0)
pc3 = dim_standardize_n_Wrap(asciiread("../"+mymodel+"/"+"PC3.txt", 8, "float"),0,0)

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
rts@tmXBMode="Explicit"
rts@tmXBValues=ispan(2011,2018,1)
rts@tmXBLabels=ispan(2011,2018,1)
rts@tmXBLabelFontHeightF=0.02
rts@tmYLLabelFontHeightF=0.02

rts2 = rts
rts3 = rts

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.
rts@gsnAboveYRefLineColor = "white"
rts@gsnBelowYRefLineColor = "white"
rts@gsnXYBarChartBarWidth = 0.45 
rts@xyCurveDrawOrder = "PreDraw"


rts2@gsnXYBarChart         = True
rts2@gsnYRefLine           = 0.
rts2@gsnAboveYRefLineColor = "orange"
rts2@gsnBelowYRefLineColor = "green3"
rts2@gsnXYBarChartBarWidth = 0.25 
rts2@xyCurveDrawOrder = "Draw"


rts3@gsnXYBarChart         = False
;rts3@gsnYRefLine           = 0.
rts3@xyLineThicknessF = 4.0
rts3@xyMarkLineMode = "MarkLines"
rts3@xyMarker = 16
rts3@xyMarkerSizes = 10
rts3@xyCurveDrawOrder = "PostDraw"


wks = gsn_open_wks("eps",mymodel)

plot = gsn_csm_xy3(wks,ispan(2011, 2018, 1),pc1,pc2,pc3,rts,rts2,rts3)

draw(wks)
frame(wks)
