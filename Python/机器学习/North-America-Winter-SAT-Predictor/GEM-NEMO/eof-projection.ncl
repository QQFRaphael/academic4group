load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

fff = addfile("../data/NA-SAT-EOF/EOF.nc","r")

latml = fff->lat(::-1)
lonml = fff->lon

eof = fff->eof

year_start = 1981
year_end = 2010

tfile = addfile("GEM_NEMO.nc","r")

tems = tfile->tmp
lat = tfile->lat_0
lon = tfile->lon_0

ntime = year_end - year_start + 1

lat_idx = ind(lat.le.70.and.lat.ge.10)
lon_idx = ind(lon.ge.210.and.lon.le.320)

DJF = linint2_Wrap(lon, lat, tems, True, lonml, latml, 0)

eof_ts = eofunc_ts_n_Wrap(DJF, eof, True,0)
printVarSummary(eof_ts)

PC1_ori = eof_ts(0,:)
PC2_ori = eof_ts(1,:)
PC3_ori = eof_ts(2,:)

PC1_norm = dim_standardize_n_Wrap(PC1_ori,0,0)
PC2_norm = dim_standardize_n_Wrap(PC2_ori,0,0)
PC3_norm = dim_standardize_n_Wrap(PC3_ori,0,0)



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

rts@gsnXYBarChart         = True
rts@gsnYRefLine           = 0.
rts@gsnAboveYRefLineColor = "orange"
rts@gsnBelowYRefLineColor = "green3"
rts@gsnXYBarChartBarWidth = 0.55 

rts2@gsnXYBarChart         = False
rts2@gsnYRefLine           = 0.
;rts@gsnXYBarChartBarWidth = 0.7
rts2@xyLineThicknessF = 4.



wks=gsn_open_wks("png","PC1")
;pc1=gsn_csm_xy2(wks,ispan(year_start,year_end-1,1),PC1_norm,-snow1,rts,rts2)
;print(escorc_n(PC1_norm, snow1, 0, 0))
pc1=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC1_norm,rts)
draw(wks)
frame(wks)
delete(wks)

wks=gsn_open_wks("png","PC2")
pc2=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC2_norm,rts)
;pc2=gsn_csm_xy2(wks,ispan(year_start,year_end,1),PC2_norm,snow2,rts,rts2)
;print(escorc_n(PC2_norm, snow2, 0, 0))
draw(wks)
frame(wks)
delete(wks)

wks=gsn_open_wks("png","PC3")
;pc3=gsn_csm_xy2(wks,ispan(year_start,year_end-1,1),PC3_norm,snow3,rts,rts2)
pc3=gsn_csm_xy(wks,ispan(year_start,year_end,1),PC3_norm,rts)
;print(escorc_n(PC3_norm, snow3, 0, 0))
draw(wks)
frame(wks)
delete(wks)

asciiwrite("PC1.txt",PC1_ori)
asciiwrite("PC2.txt",PC2_ori)
asciiwrite("PC3.txt",PC3_ori)

asciiwrite("PC1-norm.txt",PC1_norm)
asciiwrite("PC2-norm.txt",PC2_norm)
asciiwrite("PC3-norm.txt",PC3_norm)

