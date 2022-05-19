load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

fca = addfile("/home/qqf/non-monsoonal-asia/feature-prepare/EOF-1979-2010/base-eof-result.nc", "r")
lat_out = fca->lat
lon_out = fca->lon

cancm_prec = new((/38,60,150/), "float")
gem_prec = new((/38,60,150/), "float")

root = "/media/qqf/3d54bd00-8d39-446a-a068-ac1cb8fa00a3/CanSIPSv2/"

do year = 1981, 2010
    filename = root + year + "/cansips_hindcast_raw_latlon1.0x1.0_PRATE_SFC_0_"+year+"-12_allmembers.grib2"
    f = addfile(filename, "r")
    prate = f->PRATE_P11_L1_GLL0_avg1m
    lat_in = f->lat_0
    lon_in = f->lon_0

    cancm4i_dec = prate(0:9,0,:,:)*31*24*3600
    cancm4i_jan = prate(0:9,1,:,:)*31*24*3600
    cancm4i_feb = prate(0:9,2,:,:)*28*24*3600

    gem_dec = prate(10:19,0,:,:)*31*24*3600
    gem_jan = prate(10:19,1,:,:)*31*24*3600
    gem_feb = prate(10:19,2,:,:)*28*24*3600

    cancm = cancm4i_dec + cancm4i_jan + cancm4i_feb
    gem = gem_dec + gem_jan + gem_feb

    cancm_int = linint2_Wrap(lon_in, lat_in, cancm, True, lon_out, lat_out, 0)
    gem_int = linint2_Wrap(lon_in, lat_in, gem, True, lon_out, lat_out, 0)

    cancm_int_ens = dim_avg_n_Wrap(cancm_int, 0)
    gem_int_ens = dim_avg_n_Wrap(gem_int, 0)

    cancm_prec(year-1981,:,:) = cancm_int_ens
    gem_prec(year-1981,:,:) = gem_int_ens

    print(year)
end do
delete(prate)


do year = 2011, 2018
    filename = root + year + "/cansips_hindcast_raw_latlon1.0x1.0_PRATE_SFC_0_"+year+"-12_allmembers.grib2"
    f = addfile(filename, "r")
    prate = f->PRATE_P11_L1_GLL0_avg1m
    lat_in = f->lat_0
    lon_in = f->lon_0

    cancm4i_dec = prate(0:9,1,:,:)*31*24*3600
    cancm4i_jan = prate(0:9,2,:,:)*31*24*3600
    cancm4i_feb = prate(0:9,3,:,:)*28*24*3600

    gem_dec = prate(10:19,1,:,:)*31*24*3600
    gem_jan = prate(10:19,2,:,:)*31*24*3600
    gem_feb = prate(10:19,3,:,:)*28*24*3600

    cancm = cancm4i_dec + cancm4i_jan + cancm4i_feb
    gem = gem_dec + gem_jan + gem_feb

    cancm_int = linint2_Wrap(lon_in, lat_in, cancm, True, lon_out, lat_out, 0)
    gem_int = linint2_Wrap(lon_in, lat_in, gem, True, lon_out, lat_out, 0)

    cancm_int_ens = dim_avg_n_Wrap(cancm_int, 0)
    gem_int_ens = dim_avg_n_Wrap(gem_int, 0)

    cancm_prec(year-1981,:,:) = cancm_int_ens
    gem_prec(year-1981,:,:) = gem_int_ens

    print(year)
end do



system("rm -rf cansips.nc")
out = addfile("cansips.nc", "c")
out->cancm_prec = cancm_prec
out->gem_prec = gem_prec
