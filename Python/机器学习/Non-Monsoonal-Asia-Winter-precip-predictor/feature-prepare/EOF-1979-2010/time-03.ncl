load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

year_start = 1979
year_end = 2010

ntime = year_end - year_start + 1

f = addfile("eof-pre-djf.nc", "r")

ith = "03"

south_interannual = f->ts3

rts           = True

rts@gsnScale  = True
rts@gsnDraw   = False
rts@gsnFrame  = False
rts@vpWidthF  = 0.75
rts@vpHeightF = 0.26
rts@tiYAxisString = ""
rts@gsnMaximize=True
rts@trYMinF   = -2.5        ; min value on y-axis
rts@trYMaxF   =  2.5        ; max value on y-axis
rts@tmXTOn=False
rts@tmYROn=False
rts@tmXBLabelFontHeightF=0.02
rts@tmYLLabelFontHeightF=0.02

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.

rts@gsnAboveYRefLineColor = "red"
rts@gsnBelowYRefLineColor = "blue"
rts@gsnXYBarChartBarWidth = 0.35 

wks=gsn_open_wks("eps","time-"+ith)


p5=gsn_csm_xy(wks,ispan(year_start,year_end,1),south_interannual,rts)


draw(wks)
frame(wks)