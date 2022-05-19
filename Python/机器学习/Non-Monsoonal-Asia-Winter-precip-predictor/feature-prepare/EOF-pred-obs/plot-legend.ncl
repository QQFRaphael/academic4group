load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


lr_pc1 = dim_standardize_n_Wrap(asciiread("../../LR/PC1.txt", 8, "float"),0,0)
gbdt_pc1 = dim_standardize_n_Wrap(asciiread("../../GBDT/PC1.txt", 8, "float"),0,0)
cat_pc1 = dim_standardize_n_Wrap(asciiread("../../CatBoost/PC1.txt", 8, "float"),0,0)
light_pc1 = dim_standardize_n_Wrap(asciiread("../../LightGBM/PC1.txt", 8, "float"),0,0)
xg_pc1 = dim_standardize_n_Wrap(asciiread("../../XGBoost/PC1.txt", 8, "float"),0,0)
obs_pc1 = dim_standardize_n_Wrap(asciiread("PC1-pred-obs.txt", 8, "float"),0,0)

lr_pc2 = dim_standardize_n_Wrap(asciiread("../../LR/PC2.txt", 8, "float"),0,0)
gbdt_pc2 = dim_standardize_n_Wrap(asciiread("../../GBDT/PC2.txt", 8, "float"),0,0)
cat_pc2 = dim_standardize_n_Wrap(asciiread("../../CatBoost/PC2.txt", 8, "float"),0,0)
light_pc2 = dim_standardize_n_Wrap(asciiread("../../LightGBM/PC2.txt", 8, "float"),0,0)
xg_pc2 = dim_standardize_n_Wrap(asciiread("../../XGBoost/PC2.txt", 8, "float"),0,0)
obs_pc2 = dim_standardize_n_Wrap(asciiread("PC2-pred-obs.txt", 8, "float"),0,0)

lr_pc3 = dim_standardize_n_Wrap(asciiread("../../LR/PC3.txt", 8, "float"),0,0)
gbdt_pc3 = dim_standardize_n_Wrap(asciiread("../../GBDT/PC3.txt", 8, "float"),0,0)
cat_pc3 = dim_standardize_n_Wrap(asciiread("../../CatBoost/PC3.txt", 8, "float"),0,0)
light_pc3 = dim_standardize_n_Wrap(asciiread("../../LightGBM/PC3.txt", 8, "float"),0,0)
xg_pc3 = dim_standardize_n_Wrap(asciiread("../../XGBoost/PC3.txt", 8, "float"),0,0)
obs_pc3 = dim_standardize_n_Wrap(asciiread("PC3-pred-obs.txt", 8, "float"),0,0)

plots = new(3, graphic)


wks   = gsn_open_wks ("eps", "PCs-leng")

res                  = True 
 res@gsnDraw          = False
 res@gsnFrame         = False
 res@xyLineThicknessF = 1.

res@vpWidthF=0.7
res@vpHeightF=0.25

res@trYMinF   = -2.5        ; min value on y-axis
res@trYMaxF   =  2.5        ; max value on y-axis

 res@xyLineColors     = (/ "Red", "Green", "Blue","orange","pink","black" /)
 res@xyMarkerColors   = (/ "Green", "blue", "red" /)
res@tmXBLabels = ispan(2011, 2018, 1)
res@tmXBFormat = "f" 


res@pmLegendDisplayMode    = "Always"  
res@pmLegendSide           = "bottom" 
res@pmLegendWidthF         = 0.15    
res@pmLegendHeightF        = 0.18 

res@xyExplicitLegendLabels = (/"","","","","",""/)   



 plots(0)  = gsn_csm_xy (wks,ispan(2011,2018,1), (/lr_pc1, gbdt_pc1, cat_pc1, light_pc1, xg_pc1, obs_pc1/), res) 
 plots(1)  = gsn_csm_xy (wks,ispan(2011,2018,1), (/lr_pc2, gbdt_pc2, cat_pc2, light_pc2, xg_pc2, obs_pc2/), res) 




plots(2)  = gsn_csm_xy (wks,ispan(2011,2018,1), (/lr_pc3, gbdt_pc3, cat_pc3, light_pc3, xg_pc3, obs_pc3/), res) 

gsn_panel(wks, plots, (/3,1/), False)

;draw(wks)
;frame(wks)
