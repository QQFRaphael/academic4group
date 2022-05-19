# Barotropical Model

这个模式是Sardeshmukh和Hoskins在1988年发展的浅水模式，至今许多文章中仍然在使用。具体模式细节参考：Sardeshmukh, P. D., and B. J. Hoskins, 1988: The generation of global rotational ﬂow by steady ideali
zed tropical divergence. Journal of Atmospheric Science.

# 背景场制作

背景场制作分成两步：第一步是把ncep1或者ncep2的数据转写成二进制，具体代码参考`myscript/convert_ncep2binary.ncl`。注意必须得完整放入一年每个月的200hPa高度场；第二步则是把第一步输出的二进制数据转换为模式需要的变量，直接修改编译并运行`myscript/GetVorticity.f`即可。

最终生成的`GetVorticity.clim`可以配上`data`目录下的`GetVorticity.ctl`用CDO转换成nc后查看。

为了方便使用，在`run.sh`脚本中写了一部分自动完成背景场制作的代码，最终生成的`GetVorticity.clim`移到`data`目录下：

```shell
# define the background field
yearStart=1979
yearEnd=2018
nyears=`expr $yearEnd - $yearStart + 1`
nmonths=`expr $nyears \* 12`

cd myscript
sed -i "13s/^.*.$/yearstart = $yearStart/g" convert_ncep2binary.ncl
sed -i "14s/^.*.$/yearend = $yearEnd/g" convert_ncep2binary.ncl
sed -i "12s/^.*.$/                  parameter (ix=145,iy=73,it=$nmonths,nytt=$nyears)/g" GetVorticity.f
ncl convert_ncep2binary.ncl
ifort GetVorticity.f
./a.out
rm -rf a.out umon200.dat vmon200.dat
mv GetVorticity.clim ../data
cd ..
```

# 制作强迫场

强迫场分两种，一种是散度强迫，一种是涡度强迫。对于控制试验，气候态的涡度散度用于驱动模式，对于敏感性试验，在气候态的基础上叠加强迫就可以了

具体做法见`myscript/make_forcing.ncl`

# 模式运行

强迫场备好后就可以直接运行了。运行后的结果输出风场和高度场，敏感性试验减控制试验就是响应。

为了方便使用，这里直接把从背景场制作到运行结束的所有过程都写成脚本。中间文件全部清理掉，最终输出结果直接转换为netcdf格式方便使用

```shell
#!/bin/sh

# some parameters
yearStart=1979
yearEnd=2010

cent_lat=40.0
cent_lon=320.0
len_lat=10.0
len_lon=15.0

div_intensity=-7e-6
vor_intensity=0.0

month_idx="(\/2,3,4\/)"

exp_name="test"

run_days=40

# define the background field
nyears=`expr $yearEnd - $yearStart + 1`
nmonths=`expr $nyears \* 12`

cd myscript
sed -i "13s/^.*.$/yearstart = $yearStart/g" convert_ncep2binary.ncl
sed -i "14s/^.*.$/yearend = $yearEnd/g" convert_ncep2binary.ncl
sed -i "12s/^.*.$/                  parameter (ix=145,iy=73,it=$nmonths,nytt=$nyears)/g" GetVorticity.f
ncl convert_ncep2binary.ncl
ifort GetVorticity.f 
./a.out >& /dev/null
rm -rf a.out umon200.dat vmon200.dat
mv GetVorticity.clim ../data
cd ../data
cat << EOF > GetVorticity.ctl
dset GetVorticity.clim
title NCEP pentad mean data in grads
undef -9.99e+33
options template little_endian
xdef 144 linear   0 2.5
ydef  73 linear -90 2.5
zdef   1 levels 1 1
tdef  12 linear 01jan2000 1mo
vars   4
div    0  99  div
vor    0  99  vor
vpt    0  99  vpt
str    0  99  str
endvars
EOF
cdo -f nc import_binary GetVorticity.ctl GetVorticity.nc
rm -rf GetVorticity.ctl
cd ..

# make forcing field
cd myscript
ncl convert_Gaussian_R40.ncl
sed -i "8s/^.*.$/cent_lat = $cent_lat/g" make_forcing.ncl
sed -i "9s/^.*.$/cent_lon = $cent_lon/g" make_forcing.ncl
sed -i "10s/^.*.$/len_lon = $len_lon/g" make_forcing.ncl
sed -i "11s/^.*.$/len_lat = $len_lat/g" make_forcing.ncl
sed -i "13s/^.*.$/div_intensity = $div_intensity/g" make_forcing.ncl
sed -i "14s/^.*.$/vor_intensity = $vor_intensity/g" make_forcing.ncl
sed -i "16s/^.*.$/month_idx = $month_idx/g" make_forcing.ncl
ncl make_forcing.ncl
cd ..

# following is conducting experiment...
# if div forcing is set, then modify PreDivergence.f
# if vor forcing is set, then modify PreVorticity.f

# ctl preprocessing...
cd code
sed -i "29s/^.*.$/      open(2,file='..\/data\/div.grads.clim',access='direct',form=/g" PreDivergence.f
ifort -O  -save -zero PreDivergence.f subs2.f
./a.out >& /dev/null
mv fort.77 ../data/div_clim.dat

sed -i "29s/^.*.$/      open(2,file='..\/data\/vor.grads.clim',access='direct',form=/g" PreVorticity.f
ifort -O  -save -zero PreVorticity.f subs2.f
./a.out >& /dev/null

ifort -O  -save -zero initial.f
./a.out >& /dev/null
mv fort.2 ../data/initial_clim.dat
mv fort.88 ../data/vor_clim.dat

rm -rf a.out *.o

# ctl compile...
ifort -O -save -zero -w -c main.f
ifort -O -save -zero -w -c subs1.f
ifort -O -save -zero -w -c subs2.f
ifort -O -save -zero -o model main.o subs1.o subs2.o
rm -rf *.o

# ctl file link...
ln -sf ../data/initial_clim.dat fort.24
ln -sf ../data/div_clim.dat fort.44

cat << EOF > fort.7
$run_days
2.0000000000000000E-02  0.5000000000000000    
2.3380000000000000E+16  2.3380000000000000E+16
1 1
EOF

# ctl run...
./model >& /dev/null

rm -rf fort.24 fort.44 fort.7
mv fort.66 form.dat

# ctl post processing...
ifort -O -save -zero -w -o postuv postuv.f postsubs.f
ifort -O -save -zero -w -o postStream postStream.f postsubs.f

cat << EOF > input
'uv_ctl.dat'
'form.dat'
$run_days
0
EOF
./postuv < input

cat << EOF > input
'stream_ctl.dat'
'form.dat'
$run_days
0
EOF
./postStream < input

# generate grads ctl files...
cat << EOF > uv_ctl.ctl
DSET  ^uv_ctl.dat
UNDEF  -9.99e33
TITLE R40 Barotropic model
*
XDEF 128 LINEAR  0.0 2.8125
*
YDEF 102 LEVELS -88.66 -86.91 -85.16 -83.41 -81.65 -79.9
-78.14 -76.39 -74.63 -72.88 -71.12 -69.36 -67.61 -65.85
-64.1 -62.34 -60.58 -58.83 -57.07 -55.32 -53.56 -51.8 
-50.05 -48.29 -46.54 -44.78 -43.02 -41.27 -39.51 -37.76 
-36.00 -34.24 -32.49 -30.73 -28.98 -27.22 -25.46 -23.71 
-21.95 -20.19 -18.44 -16.68 -14.93 -13.17 -11.41 -9.66 
-7.9 -6.15 -4.39 -2.63 -0.88 0.88 2.63 4.39 6.15 7.9 9.66 
11.41 13.17 14.93 16.68 18.44 20.19 21.95 23.71 25.46 27.22 
28.98 30.73 32.49 34.24 36.00 37.76 39.51 41.27 43.02 44.78 
46.54 48.29 50.05 51.8 53.56 55.32 57.07 58.83 60.58 62.34 
64.10 65.85 67.61 69.36 71.12 72.88 74.63 76.39 78.14 79.9 
81.65 83.41 85.16 86.91 88.66
*
ZDEF 1 LEVELS 200
*
TDEF $run_days LINEAR 01jan1982 1dy
*
VARS 2
u  0  99   zonal wind
v  0  99   meridional wind
ENDVARS
EOF

cat << EOF > stream_ctl.ctl
DSET  ^stream_ctl.dat
UNDEF  -9.99e33
TITLE R40 Barotropic model
*
XDEF 128 LINEAR  0.0 2.8125
*
YDEF 102 LEVELS -88.66 -86.91 -85.16 -83.41 -81.65 -79.9
-78.14 -76.39 -74.63 -72.88 -71.12 -69.36 -67.61 -65.85
-64.1 -62.34 -60.58 -58.83 -57.07 -55.32 -53.56 -51.8 
-50.05 -48.29 -46.54 -44.78 -43.02 -41.27 -39.51 -37.76 
-36.00 -34.24 -32.49 -30.73 -28.98 -27.22 -25.46 -23.71 
-21.95 -20.19 -18.44 -16.68 -14.93 -13.17 -11.41 -9.66 
-7.9 -6.15 -4.39 -2.63 -0.88 0.88 2.63 4.39 6.15 7.9 9.66 
11.41 13.17 14.93 16.68 18.44 20.19 21.95 23.71 25.46 27.22 
28.98 30.73 32.49 34.24 36.00 37.76 39.51 41.27 43.02 44.78 
46.54 48.29 50.05 51.8 53.56 55.32 57.07 58.83 60.58 62.34 
64.10 65.85 67.61 69.36 71.12 72.88 74.63 76.39 78.14 79.9 
81.65 83.41 85.16 86.91 88.66
*
ZDEF 1 LEVELS 200
*
TDEF $run_days LINEAR 01jan1982 1dy
*
VARS 2
sf  0  99   stream function
vp  0  99   velocity potential
ENDVARS
EOF

cdo -f nc import_binary uv_ctl.ctl uv_ctl.nc
cdo -f nc import_binary stream_ctl.ctl stream_ctl.nc

rm -rf input postuv postStream fort.23 stream_ctl.dat form.dat uv_ctl.dat uv_ctl.ctl stream_ctl.ctl model
mv uv_ctl.nc stream_ctl.nc ../data/
cd ..

# frc preprocessing...
cd code
sed -i "29s/^.*.$/      open(2,file='..\/data\/div.grads.frc',access='direct',form=/g" PreDivergence.f
ifort -O  -save -zero PreDivergence.f subs2.f
./a.out >& /dev/null
mv fort.77 ../data/div_frc.dat

sed -i "29s/^.*.$/      open(2,file='..\/data\/vor.grads.frc',access='direct',form=/g" PreVorticity.f
ifort -O  -save -zero PreVorticity.f subs2.f
./a.out >& /dev/null

ifort -O  -save -zero initial.f
./a.out >& /dev/null
mv fort.2 ../data/initial_frc.dat
mv fort.88 ../data/vor_frc.dat

rm -rf a.out *.o

# frc compile...
ifort -O -save -zero -w -c main.f
ifort -O -save -zero -w -c subs1.f
ifort -O -save -zero -w -c subs2.f
ifort -O -save -zero -o model main.o subs1.o subs2.o
rm -rf *.o

# frc file link...
ln -sf ../data/initial_frc.dat fort.24
ln -sf ../data/div_frc.dat fort.44

cat << EOF > fort.7
$run_days
2.0000000000000000E-02  0.5000000000000000    
2.3380000000000000E+16  2.3380000000000000E+16
1 1
EOF

# frc run...
./model >& /dev/null

rm -rf fort.24 fort.44 fort.7
mv fort.66 form.dat

# frc post processing...
ifort -O -save -zero -w -o postuv postuv.f postsubs.f
ifort -O -save -zero -w -o postStream postStream.f postsubs.f

cat << EOF > input
'uv_frc.dat'
'form.dat'
$run_days
0
EOF
./postuv < input

cat << EOF > input
'stream_frc.dat'
'form.dat'
$run_days
0
EOF
./postStream < input

# generate grads ctl files...
cat << EOF > uv_frc.ctl
DSET  ^uv_frc.dat
UNDEF  -9.99e33
TITLE R40 Barotropic model
*
XDEF 128 LINEAR  0.0 2.8125
*
YDEF 102 LEVELS -88.66 -86.91 -85.16 -83.41 -81.65 -79.9
-78.14 -76.39 -74.63 -72.88 -71.12 -69.36 -67.61 -65.85
-64.1 -62.34 -60.58 -58.83 -57.07 -55.32 -53.56 -51.8 
-50.05 -48.29 -46.54 -44.78 -43.02 -41.27 -39.51 -37.76 
-36.00 -34.24 -32.49 -30.73 -28.98 -27.22 -25.46 -23.71 
-21.95 -20.19 -18.44 -16.68 -14.93 -13.17 -11.41 -9.66 
-7.9 -6.15 -4.39 -2.63 -0.88 0.88 2.63 4.39 6.15 7.9 9.66 
11.41 13.17 14.93 16.68 18.44 20.19 21.95 23.71 25.46 27.22 
28.98 30.73 32.49 34.24 36.00 37.76 39.51 41.27 43.02 44.78 
46.54 48.29 50.05 51.8 53.56 55.32 57.07 58.83 60.58 62.34 
64.10 65.85 67.61 69.36 71.12 72.88 74.63 76.39 78.14 79.9 
81.65 83.41 85.16 86.91 88.66
*
ZDEF 1 LEVELS 200
*
TDEF $run_days LINEAR 01jan1982 1dy
*
VARS 2
u  0  99   zonal wind
v  0  99   meridional wind
ENDVARS
EOF

cat << EOF > stream_frc.ctl
DSET  ^stream_frc.dat
UNDEF  -9.99e33
TITLE R40 Barotropic model
*
XDEF 128 LINEAR  0.0 2.8125
*
YDEF 102 LEVELS -88.66 -86.91 -85.16 -83.41 -81.65 -79.9
-78.14 -76.39 -74.63 -72.88 -71.12 -69.36 -67.61 -65.85
-64.1 -62.34 -60.58 -58.83 -57.07 -55.32 -53.56 -51.8 
-50.05 -48.29 -46.54 -44.78 -43.02 -41.27 -39.51 -37.76 
-36.00 -34.24 -32.49 -30.73 -28.98 -27.22 -25.46 -23.71 
-21.95 -20.19 -18.44 -16.68 -14.93 -13.17 -11.41 -9.66 
-7.9 -6.15 -4.39 -2.63 -0.88 0.88 2.63 4.39 6.15 7.9 9.66 
11.41 13.17 14.93 16.68 18.44 20.19 21.95 23.71 25.46 27.22 
28.98 30.73 32.49 34.24 36.00 37.76 39.51 41.27 43.02 44.78 
46.54 48.29 50.05 51.8 53.56 55.32 57.07 58.83 60.58 62.34 
64.10 65.85 67.61 69.36 71.12 72.88 74.63 76.39 78.14 79.9 
81.65 83.41 85.16 86.91 88.66
*
ZDEF 1 LEVELS 200
*
TDEF $run_days LINEAR 01jan1982 1dy
*
VARS 2
sf  0  99   stream function
vp  0  99   velocity potential
ENDVARS
EOF

cdo -f nc import_binary uv_frc.ctl uv_frc.nc
cdo -f nc import_binary stream_frc.ctl stream_frc.nc

rm -rf input postuv postStream fort.23 stream_frc.dat form.dat uv_frc.dat uv_frc.ctl stream_frc.ctl model
mv uv_frc.nc stream_frc.nc ../data/
cd ..

# clean data dir
cd data
rm -rf *.dat *.clim *.frc Gaussian_R40.nc GetVorticity.nc
cd ..

# sort model output
cd output
rm -rf $exp_name
mkdir $exp_name
cd $exp_name
mv ../../data/frc_bs.nc  .
mv ../../data/stream_ctl.nc . 
mv ../../data/stream_frc.nc . 
mv ../../data/uv_ctl.nc . 
mv ../../data/uv_frc.nc .

cd ../../

```

