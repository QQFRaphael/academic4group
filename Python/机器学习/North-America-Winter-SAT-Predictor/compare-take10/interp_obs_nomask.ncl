load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f = addfile("../data/OBS/obs.nc","r")

obs = f->tmp
lat_obs = f->lat
lon_obs = f->lon

system("rm -rf obs.nc")
out = addfile("obs.nc","c")
out->obs = obs(2:31,:,:)


f11 = addfile("../CanCM4i/CanCM4i.nc","r")
cancm4i = f11->tmp
lat_cancm4i = f11->lat_0
lon_cancm4i = f11->lon_0

cancm4i_int = linint2_Wrap(lon_cancm4i,lat_cancm4i,cancm4i,True,lon_obs,lat_obs,0)
copy_VarMeta(obs(2:31,:,:),cancm4i_int)

system("rm -rf cancm4i.nc")
out = addfile("cancm4i.nc","c")
out->cancm4i = cancm4i_int

f111 = addfile("../GEM-NEMO/GEM_NEMO.nc","r")
gemnemo = f111->tmp
lat_gemnemo = f111->lat_0
lon_gemnemo = f111->lon_0

gemnemo_int = linint2_Wrap(lon_gemnemo,lat_gemnemo,gemnemo,True,lon_obs,lat_obs,0)
copy_VarMeta(obs(2:31,:,:),gemnemo_int)

system("rm -rf gemnemo.nc")
out = addfile("gemnemo.nc","c")
out->gemnemo = gemnemo_int

fff = addfile("../data/NA-SAT-EOF/EOF.nc","r")

latml = fff->lat(::-1)
lonml = fff->lon

eof1 = linint2_Wrap(lonml,latml,fff->EOF1(::-1,:),True,lon_obs,lat_obs,0)
eof2 = linint2_Wrap(lonml,latml,fff->EOF2(::-1,:),True,lon_obs,lat_obs,0)
eof3 = linint2_Wrap(lonml,latml,fff->EOF3(::-1,:),True,lon_obs,lat_obs,0)

EOF1 = conform(obs,eof1,(/1,2/))
EOF2 = conform(obs,eof2,(/1,2/))
EOF3 = conform(obs,eof3,(/1,2/))

CLIM = linint2_Wrap(lonml,latml,fff->DJF_clim(::-1,:),True,lon_obs,lat_obs,0)
clim = conform(obs,CLIM,(/1,2/))

lr_pc1 = conform(obs,asciiread("../Linear/LR-PC1-TAKE10.txt",39,"float"),(/0/))
lr_pc2 = conform(obs,asciiread("../Linear/LR-PC2-TAKE10.txt",39,"float"),(/0/))
lr_pc3 = conform(obs,asciiread("../Linear/LR-PC3-TAKE10.txt",39,"float"),(/0/))

lr = EOF1*lr_pc1 + EOF2*lr_pc2 + EOF3*lr_pc3 + clim
copy_VarMeta(obs,lr)
lr1 = EOF1*lr_pc1 + clim
copy_VarMeta(obs,lr1)
lr2 = EOF2*lr_pc2 + clim
copy_VarMeta(obs,lr2)
lr3 = EOF3*lr_pc3 + clim
copy_VarMeta(obs,lr3)

system("rm -rf lr.nc")
out = addfile("lr.nc","c")
out->lr = lr(2:31,:,:)
out->lr1 = lr1(2:31,:,:)
out->lr2 = lr2(2:31,:,:)
out->lr3 = lr3(2:31,:,:)


svr_pc1 = conform(obs,asciiread("../SVR/SVR-PC1-TAKE10.txt",39,"float"),(/0/))
svr_pc2 = conform(obs,asciiread("../SVR/SVR-PC2-TAKE10.txt",39,"float"),(/0/))
svr_pc3 = conform(obs,asciiread("../SVR/SVR-PC3-TAKE10.txt",39,"float"),(/0/))

svr = EOF1*svr_pc1 + EOF2*svr_pc2 + EOF3*svr_pc3 + clim
copy_VarMeta(obs,svr)
svr1 = EOF1*svr_pc1 + clim
copy_VarMeta(obs,svr1)
svr2 = EOF2*svr_pc2 + clim
copy_VarMeta(obs,svr2)
svr3 = EOF3*svr_pc3 + clim
copy_VarMeta(obs,svr3)

system("rm -rf svr.nc")
out = addfile("svr.nc","c")
out->svr = svr(2:31,:,:)
out->svr1 = svr1(2:31,:,:)
out->svr2 = svr2(2:31,:,:)
out->svr3 = svr3(2:31,:,:)


xgboost_pc1 = conform(obs,asciiread("../XGBoost/XGBoost-PC1-TAKE10.txt",39,"float"),(/0/))
xgboost_pc2 = conform(obs,asciiread("../XGBoost/XGBoost-PC2-TAKE10.txt",39,"float"),(/0/))
xgboost_pc3 = conform(obs,asciiread("../XGBoost/XGBoost-PC3-TAKE10.txt",39,"float"),(/0/))

xgboost = EOF1*xgboost_pc1 + EOF2*xgboost_pc2 + EOF3*xgboost_pc3 + clim
copy_VarMeta(obs,xgboost)
xgboost1 = EOF1*xgboost_pc1 + clim
copy_VarMeta(obs,xgboost1)
xgboost2 = EOF2*xgboost_pc2 + clim
copy_VarMeta(obs,xgboost2)
xgboost3 = EOF3*xgboost_pc3 + clim
copy_VarMeta(obs,xgboost3)

system("rm -rf xgboost.nc")
out = addfile("xgboost.nc","c")
out->xgboost = xgboost(2:31,:,:)
out->xgboost1 = xgboost1(2:31,:,:)
out->xgboost2 = xgboost2(2:31,:,:)
out->xgboost3 = xgboost3(2:31,:,:)



ens_ML_MD = (cancm4i_int + gemnemo_int + lr(2:31,:,:) + svr(2:31,:,:) + xgboost(2:31,:,:))/5.0
copy_VarMeta(obs(2:31,:,:),ens_ML_MD)

ens_ML = (lr(2:31,:,:) + svr(2:31,:,:) + xgboost(2:31,:,:))/3.0
copy_VarMeta(obs(2:31,:,:),ens_ML)

ens_MD = (cancm4i_int + gemnemo_int)/2.0
copy_VarMeta(obs(2:31,:,:),ens_MD)

system("rm -rf ens.nc")
out = addfile("ens.nc","c")
out->ens_ML_MD = ens_ML_MD
out->ens_ML = ens_ML
out->ens_MD = ens_MD
