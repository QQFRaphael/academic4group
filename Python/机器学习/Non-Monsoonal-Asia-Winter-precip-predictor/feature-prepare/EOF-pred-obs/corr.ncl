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

print("lr-obs-pc1   : "+escorc_n(lr_pc1,obs_pc1,0,0))
print("gbdt-obs-pc1 : "+escorc_n(gbdt_pc1,obs_pc1,0,0))
print("light-obs-pc1: "+escorc_n(light_pc1,obs_pc1,0,0))
print("xg-obs-pc1   : "+escorc_n(xg_pc1,obs_pc1,0,0))
print("cat-obs-pc1  : "+escorc_n(cat_pc1,obs_pc1,0,0))

print("lr-obs-pc2   : "+escorc_n(lr_pc2,obs_pc2,0,0))
print("gbdt-obs-pc2 : "+escorc_n(gbdt_pc2,obs_pc2,0,0))
print("light-obs-pc2: "+escorc_n(light_pc2,obs_pc2,0,0))
print("xg-obs-pc2   : "+escorc_n(xg_pc2,obs_pc2,0,0))
print("cat-obs-pc2  : "+escorc_n(cat_pc2,obs_pc2,0,0))

print("lr-obs-pc3   : "+escorc_n(lr_pc3,obs_pc3,0,0))
print("gbdt-obs-pc3 : "+escorc_n(gbdt_pc3,obs_pc3,0,0))
print("light-obs-pc3: "+escorc_n(light_pc3,obs_pc3,0,0))
print("xg-obs-pc3   : "+escorc_n(xg_pc3,obs_pc3,0,0))
print("cat-obs-pc3  : "+escorc_n(cat_pc3,obs_pc3,0,0))
