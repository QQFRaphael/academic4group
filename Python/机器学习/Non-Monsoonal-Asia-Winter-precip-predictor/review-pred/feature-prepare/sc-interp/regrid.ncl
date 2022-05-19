load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

filein = addfile("nhsce_v01r01_19661004_20210301.nc","r")
scin = filein->snow_cover_extent
latitude = filein->latitude
longitude = filein->longitude

lat = (/0.5, 2.5, 4.5, 6.5, 8.5, 10.5, 12.5, 14.5, 16.5, 18.5, 20.5, 22.5, \
    24.5, 26.5, 28.5, 30.5, 32.5, 34.5, 36.5, 38.5, 40.5, 42.5, 44.5, 46.5, \
    48.5, 50.5, 52.5, 54.5, 56.5, 58.5, 60.5, 62.5, 64.5, 66.5, 68.5, 70.5, \
    72.5, 74.5, 76.5, 78.5, 80.5, 82.5, 84.5, 86.5, 88.5/)
lon = (/-179, -177, -175, -173, -171, -169, -167, -165, -163, -161, -159, \
    -157, -155, -153, -151, -149, -147, -145, -143, -141, -139, -137, -135, \ 
    -133, -131, -129, -127, -125, -123, -121, -119, -117, -115, -113, -111, \
    -109, -107, -105, -103, -101, -99, -97, -95, -93, -91, -89, -87, -85, \
    -83, -81, -79, -77, -75, -73, -71, -69, -67, -65, -63, -61, -59, -57, \
    -55, -53, -51, -49, -47, -45, -43, -41, -39, -37, -35, -33, -31, -29,\
    -27, -25, -23, -21, -19, -17, -15, -13, -11, -9, -7, -5, -3, -1, 1, 3, 5, \
    7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, \
    45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, \
    81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, \
    113, 115, 117, 119, 121, 123, 125, 127, 129, 131, 133, 135, 137, 139, \
    141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, \
    169, 171, 173, 175, 177, 179/)

tmp = scin*100
copy_VarMeta(scin, tmp)


srcGridName = "src_SCRIP.nc"
dstGridName = "dst_SCRIP.nc"
wgtFileName = "wgt.nc"

opt                = True
opt@LargeFile      = True

rectilinear_to_SCRIP(dstGridName,lat,lon,opt)
curvilinear_to_SCRIP(srcGridName,latitude,longitude,opt)


Opt                = True
Opt@InterpMethod   = "neareststod" 
Opt@SrcRegional=True

ESMF_regrid_gen_weights(srcGridName,dstGridName,wgtFileName,Opt)

OPT                = True
temp_regrid = ESMF_regrid_with_weights(scin,wgtFileName,OPT)

out=addfile("out.nc","c")
out->snowcover=temp_regrid
out->lat=lat
out->lon=lon

