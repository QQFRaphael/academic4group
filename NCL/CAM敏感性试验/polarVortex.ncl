load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

case="ice"

f1 = addfile("ctl.nc", "r")
f2 = addfile("ice.nc", "r")

ctl = f1->hgt(0:623,14,:,:)
snt = f2->hgt(0:623,14,:,:)

anom = snt-ctl
copy_VarMeta(ctl, anom)

nov = anom(10::12,:,:)
dec = anom(11::12,:,:)
jan = anom(12::12,:,:)

novc = ctl(10::12,:,:)
decc = ctl(11::12,:,:)
janc = ctl(12::12,:,:)


Hgt_anom = (nov(0:50,:,:)+dec(0:50,:,:)+jan(0:50,:,:))/3.0
copy_VarMeta(anom(0:50,:,:), Hgt_anom)

Hgt_clim = (novc(0:50,:,:)+decc(0:50,:,:)+janc(0:50,:,:))/3.0
copy_VarMeta(ctl(0:50,:,:), Hgt_clim)

hgt_anom = dim_avg_n_Wrap(Hgt_anom(9:49,:,:), 0)
hgt_clim = dim_avg_n_Wrap(Hgt_clim(9:49,:,:), 0)

nova = snt(10::12,:,:) * 30.0 * 24.0 * 60.0 * 60.0
deca = snt(11::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0
jana = snt(12::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0

snt_all = (nova(0:50,:,:)+deca(0:50,:,:)+jana(0:50,:,:))  * 1000.0
copy_VarMeta(anom(0:50,:,:), snt_all)

novc = ctl(10::12,:,:) * 30.0 * 24.0 * 60.0 * 60.0
decc = ctl(11::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0
janc = ctl(12::12,:,:) * 31.0 * 24.0 * 60.0 * 60.0

ctl_all = (novc(0:50,:,:)+decc(0:50,:,:)+janc(0:50,:,:))  * 1000.0
copy_VarMeta(anom(0:50,:,:), ctl_all)

ave1 = dim_avg_n_Wrap(snt_all, 0)
var1 = dim_stddev_n_Wrap(snt_all, 0)
s1 = dimsizes(snt_all(:,0,0))

ave2 = dim_avg_n_Wrap(ctl_all, 0)
var2 = dim_stddev_n_Wrap(ctl_all, 0)
s2 = dimsizes(ctl_all(:,0,0))

hgt_high_ave = ave1
hgt_high_var = var1
hgt_low_ave = ave2
hgt_low_var = var2

n_high = s1
n_low = s2

diff = ave1-ave2
tval = diff/sqrt( ( (n_high-1.)*hgt_high_var^2+(n_low-1.)*hgt_low_var^2)/(n_high+n_low-2.0))/sqrt(1.0/n_high+1.0/n_low)  
tval = abs(tval)
copy_VarMeta(ave1,diff)
copy_VarMeta(ave1,tval)

ttestval = 1.299



res = True
res@gsnDraw=False
res@gsnFrame=False
res@gsnSpreadColors=True
res@gsnAddCyclic=True
res@gsnMaximize=True


res@mpLimitMode = "LatLon"
res@mpMinLatF = 10
res@mpMaxLatF = 90
;res@mpMinLonF = -110
;res@mpMaxLonF = 150

res@mpCenterLonF=0

res@cnFillOn=True
res@cnLinesOn=False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels=ispan(-40,40,5)


res@lbOrientation="Vertical"

res@gsnLeftString=""
res@gsnRightString=""

res@gsnPolar="NH"

wks = gsn_open_wks("eps", "polarVortex-"+case)
gsn_define_colormap(wks,"BlueDarkRed18")

map = gsn_csm_contour_map_polar(wks, hgt_anom, res)




resshade=True
resshade@pmTickMarkDisplayMode="Always"
resshade@cnFillOn=True
resshade@cnLinesOn=False
resshade@cnLineLabelsOn=False
resshade@cnMonoFillPattern=False
resshade@cnMonoFillColor=True

resshade@cnFillPatterns=(/-1,17/)
resshade@cnFillDotSizeF=0.002
resshade@cnFillColor = "black"
resshade@cnFillScaleF = 0.6

resshade@cnLevelSelectionMode="ExplicitLevels"
resshade@cnLevels=(/ttestval/)
resshade@lbLabelBarOn=False
resshade@cnInfoLabelOn=False

resshade@gsnAddCyclic=False

resshade@gsnDraw=False
resshade@gsnFrame=False

resshade@gsnLeftString=""
resshade@gsnRightString=""



map3 = gsn_csm_contour(wks, tval, resshade)
overlay(map,map3)

resp = True
resp@gsLineColor      = "black" ; polylines color
resp@gsLineThicknessF = 2    ; polylines thickness

typo=asciiread("/home/qqf/work/sic-non-monsoon/utils/tibet_shape",(/2066,2/),"float")
poli=gsn_add_polyline(wks,map,typo(:,0),typo(:,1),resp)



draw(map)
frame(wks)

