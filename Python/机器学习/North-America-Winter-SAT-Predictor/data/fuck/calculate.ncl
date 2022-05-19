load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


f1 = addfile("autumn.nc", "r")
autumn = f1->snow
lat = f1->lat_0
lon = f1->lon_0

f2 = addfile("spring.nc", "r")
spring = f2->snow

f3 = addfile("winter.nc", "r")
winter = f3->snow


lat_low = 27.5   ;29.0
lat_high = 36.0  ;34.0
lon_left = 88.5  ;90.0
lon_right = 100.5

idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)

autumn_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(autumn(:,idx_region_lat,idx_region_lon),2),1)  
autumn_std = dim_standardize_n_Wrap(autumn_ave, 0, 0)

spring_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(spring(:,idx_region_lat,idx_region_lon),2),1)  
spring_std = dim_standardize_n_Wrap(spring_ave, 0, 0)

winter_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(winter(:,idx_region_lat,idx_region_lon),2),1)  
winter_std = dim_standardize_n_Wrap(winter_ave, 0, 0)


asciiwrite("spring.txt", spring_std)
asciiwrite("autumn.txt", autumn_std)
asciiwrite("winter.txt", winter_std)


lat_low = 48.0   ;29.0
lat_high = 60.0 ;34.0
lon_left = 30.0  ;90.0
lon_right = 60.0

delete(idx_region_lat)
delete(idx_region_lon)
delete(autumn_ave)
delete(autumn_std)

idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)

autumn_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(autumn(:,idx_region_lat,idx_region_lon),2),1)  
autumn_std = dim_standardize_n_Wrap(autumn_ave, 0, 0)

asciiwrite("autumn2.txt", autumn_std)


lat_low = 46.0   ;29.0
lat_high = 70.0 ;34.0
lon_left = 110.0  ;90.0
lon_right = 140.0

delete(idx_region_lat)
delete(idx_region_lon)
delete(autumn_ave)
delete(autumn_std)

idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)

autumn_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(autumn(:,idx_region_lat,idx_region_lon),2),1)  
autumn_std = dim_standardize_n_Wrap(autumn_ave, 0, 0)

asciiwrite("autumn3.txt", autumn_std)





lat_low = 46.0   ;29.0
lat_high = 60.0 ;34.0
lon_left = 10.0  ;90.0
lon_right = 30.0

delete(idx_region_lat)
delete(idx_region_lon)
delete(autumn_ave)
delete(autumn_std)

idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)

autumn_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(winter(:,idx_region_lat,idx_region_lon),2),1)  
autumn_std = dim_standardize_n_Wrap(autumn_ave, 0, 0)

asciiwrite("winter2.txt", autumn_std)


lat_low = 46.0   ;29.0
lat_high = 70.0 ;34.0
lon_left = 110.0  ;90.0
lon_right = 140.0

delete(idx_region_lat)
delete(idx_region_lon)
delete(autumn_ave)
delete(autumn_std)

idx_region_lat = ind(lat.ge.lat_low.and.lat.le.lat_high)
idx_region_lon=ind(lon.ge.lon_left.and.lon.le.lon_right)

autumn_ave = dim_avg_n_Wrap(dim_avg_n_Wrap(winter(:,idx_region_lat,idx_region_lon),2),1)  
autumn_std = dim_standardize_n_Wrap(autumn_ave, 0, 0)

asciiwrite("winter3.txt", autumn_std)