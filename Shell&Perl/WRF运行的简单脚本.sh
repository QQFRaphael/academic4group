#!/bin/bash

cd /home/QQF/Program/WRF/WPS/
vi namelist.wps
read -p "Do you want to check it:" listcheck
case $listcheck in
Y | y)
     vi namelist.wps;;
*) echo "namelist.wps complete";;
esac
./geogrid.exe
read -p "Do you want to use your own Geo_data:" geocheck
case $geocheck in
Y | y)
     read -p "Please use CP command move it to the directory:" $path
     $path;;
*) echo "Use the default Geo_data";;
esac
./link_grib.csh /home/QQF/Program/WRF/WRF_DATA_SETS/fnl*
if [ -e Vtable ]
then
   rm Vtable
   ln -s ungrib/Variable_Tables/Vtable.GFS Vtable
else
   ln -s ungrib/Variable_Tables/Vtable.GFS Vtable
fi
./ungrib.exe
./metgrid.exe

cd /home/QQF/Program/WRF/WRFV3/run/
read -p "Do you want to use your own WPS file:" fcheck
case $fcheck in
Y | y)
     read -p "Please use CP command move it to the directory:" mov
     $move;;
*) cp /home/QQF/Program/WRF/WPS/met_em* .;;
esac
vi namelist.input
./real.exe
./wrf.exe

cp wrfout* /home/QQF/
read -p "Do you want to view your output:" outcheck
case $outcheck in
Y | y)
     cd /home/QQF/Program/PanoplyJ/
     ./panoply.sh
     cd /home/QQF/Program/WRF/WRFV3/run/
     rm met_em* wrfbdy* wrfinput* wrfout*
     cd /home/QQF/Program/WRF/WPS/
     rm FILE:* geo_em* GRIBFILE* met_em* Vtable ;;
*)cd /home/QQF/Program/WRF/WRFV3/run/
  rm met_em* wrfbdy* wrfinput* wrfout*
  cd /home/QQF/Program/WRF/WPS/
  rm FILE:* geo_em* GRIBFILE* met_em* Vtable ;;
esac
echo "All Complete"       