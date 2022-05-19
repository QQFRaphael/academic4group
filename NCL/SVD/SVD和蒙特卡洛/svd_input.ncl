topofile = addfile("/Users/qqf/Desktop/mywork/ncdata/circum.nc","r")

circum = topofile->topo       ; 95 x 144 = 13680
circum_lat = topofile->lat
circum_lon = topofile->lon

topofile = addfile("/Users/qqf/Desktop/mywork/ncdata/tibet.nc","r")

tibet = topofile->topo       ; 51 x 107 = 5457
tibet_lat = topofile->lat
tibet_lon = topofile->lon

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

snowfile = addfile("/Users/qqf/Desktop/mywork/ncdata/snowdepth.nc","r")

snowdepth = snowfile->snowdepth
snow_lat = snowfile->lat
snow_lon = snowfile->lon

snowdepth = where(snowdepth.lt.0,0,snowdepth)
print(max(snowdepth))
print(min(snowdepth))

prefile = addfile("/Users/qqf/Desktop/mywork/ncdata/monthly_precipitation.nc","r")

precipitation = prefile->precipitation
pre_lat = prefile->lat
pre_lon = prefile->lon
pre_station = prefile->station

precipitation = where(precipitation.lt.0,0,precipitation)

print(max(precipitation))
print(min(precipitation))

;--------------------------------------------------------------------------

snowdepth_month_max = dim_max_n_Wrap(snowdepth,2)
printVarSummary(snowdepth_month_max)
print(min(snowdepth_month_max))
print(max(snowdepth_month_max))

tmp = snowdepth_month_max(:,9:11,:,:)

snowdepth_Oct_to_Dec = dim_max_n_Wrap(snowdepth_month_max(:,9:11,:,:),1)

tmp(:,0,:,:) = snowdepth_month_max(:,10,:,:)
tmp(:,1,:,:) = snowdepth_month_max(:,11,:,:)
tmp(:,2,:,:) = snowdepth_month_max(:,0,:,:)
snowdepth_Nov_to_Jan = dim_max_n_Wrap(tmp,1)
copy_VarMeta(snowdepth_Oct_to_Dec,snowdepth_Nov_to_Jan)

tmp(:,0,:,:) = snowdepth_month_max(:,11,:,:)
tmp(:,1,:,:) = snowdepth_month_max(:,0,:,:)
tmp(:,2,:,:) = snowdepth_month_max(:,1,:,:)
snowdepth_Dec_to_Feb = dim_max_n_Wrap(tmp,1)
copy_VarMeta(snowdepth_Oct_to_Dec,snowdepth_Dec_to_Feb)

tmp(:,0,:,:) = snowdepth_month_max(:,0,:,:)
tmp(:,1,:,:) = snowdepth_month_max(:,1,:,:)
tmp(:,2,:,:) = snowdepth_month_max(:,2,:,:)
snowdepth_Jan_to_Mar = dim_max_n_Wrap(tmp,1)
copy_VarMeta(snowdepth_Oct_to_Dec,snowdepth_Jan_to_Mar)

tmp(:,0,:,:) = snowdepth_month_max(:,1,:,:)
tmp(:,1,:,:) = snowdepth_month_max(:,2,:,:)
tmp(:,2,:,:) = snowdepth_month_max(:,3,:,:)
snowdepth_Feb_to_Apr = dim_max_n_Wrap(tmp,1) 
copy_VarMeta(snowdepth_Oct_to_Dec,snowdepth_Feb_to_Apr)

tmp(:,0,:,:) = snowdepth_month_max(:,2,:,:)
tmp(:,1,:,:) = snowdepth_month_max(:,3,:,:)
tmp(:,2,:,:) = snowdepth_month_max(:,4,:,:)
snowdepth_Mar_to_May = dim_max_n_Wrap(tmp,1)
copy_VarMeta(snowdepth_Oct_to_Dec,snowdepth_Mar_to_May)

pre_Jun_to_Aug = dim_sum_n_Wrap(precipitation(:,5:7,:),1)
print("print:"+ max(pre_Jun_to_Aug))
print("print:"+ min(pre_Jun_to_Aug))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

snowdepth_Oct_to_Dec_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Oct_to_Dec(:,::-1,:),tibet_lat,tibet_lon,1)

snowdepth_Nov_to_Jan_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Nov_to_Jan(:,::-1,:),tibet_lat,tibet_lon,1)

snowdepth_Dec_to_Feb_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Dec_to_Feb(:,::-1,:),tibet_lat,tibet_lon,1)

snowdepth_Jan_to_Mar_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Jan_to_Mar(:,::-1,:),tibet_lat,tibet_lon,1)

snowdepth_Feb_to_Apr_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Feb_to_Apr(:,::-1,:),tibet_lat,tibet_lon,1)

snowdepth_Mar_to_May_tibet = rgrid2rcm_Wrap(snow_lat(::-1),snow_lon,snowdepth_Mar_to_May(:,::-1,:),tibet_lat,tibet_lon,1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ntime = 38
ncol = 5457
nstation = 756

snowdepth_Oct_to_Dec_reshape = reshape(snowdepth_Oct_to_Dec_tibet,(/ntime, ncol/))
snowdepth_Nov_to_Jan_reshape = reshape(snowdepth_Nov_to_Jan_tibet,(/ntime, ncol/))
snowdepth_Dec_to_Feb_reshape = reshape(snowdepth_Dec_to_Feb_tibet,(/ntime, ncol/))
snowdepth_Jan_to_Mar_reshape = reshape(snowdepth_Jan_to_Mar_tibet,(/ntime, ncol/))
snowdepth_Feb_to_Apr_reshape = reshape(snowdepth_Feb_to_Apr_tibet,(/ntime, ncol/))
snowdepth_Mar_to_May_reshape = reshape(snowdepth_Mar_to_May_tibet,(/ntime, ncol/))

pre_reshape = reshape(pre_Jun_to_Aug,(/ntime, nstation/))

printVarSummary(pre_reshape)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

outfile = addfile("svd_input.nc","c")

pre_reshape!0="year"
pre_reshape!1="nstation"

snowdepth_Oct_to_Dec_reshape!0="year"
snowdepth_Oct_to_Dec_reshape!1="ncol"

snowdepth_Nov_to_Jan_reshape!0="year"
snowdepth_Nov_to_Jan_reshape!1="ncol"

snowdepth_Dec_to_Feb_reshape!0="year"
snowdepth_Dec_to_Feb_reshape!1="ncol"

snowdepth_Jan_to_Mar_reshape!0="year"
snowdepth_Jan_to_Mar_reshape!1="ncol"

snowdepth_Feb_to_Apr_reshape!0="year"
snowdepth_Feb_to_Apr_reshape!1="ncol"

snowdepth_Mar_to_May_reshape!0="year"
snowdepth_Mar_to_May_reshape!1="ncol"

printVarSummary(snowdepth_Dec_to_Feb_reshape)

outfile->pre_Jun_to_Aug = pre_reshape
outfile->snowdepth_Oct_to_Dec_reshape = snowdepth_Oct_to_Dec_reshape
outfile->snowdepth_Nov_to_Jan_reshape = snowdepth_Nov_to_Jan_reshape
outfile->snowdepth_Dec_to_Feb_reshape = snowdepth_Dec_to_Feb_reshape
outfile->snowdepth_Jan_to_Mar_reshape = snowdepth_Jan_to_Mar_reshape
outfile->snowdepth_Feb_to_Apr_reshape = snowdepth_Feb_to_Apr_reshape
outfile->snowdepth_Mar_to_May_reshape = snowdepth_Mar_to_May_reshape
