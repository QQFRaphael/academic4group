load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"

year_start = 1979
year_end = 2020

nyears = year_end - year_start + 1

idx1 = 9
idx2 = 10
idx3 = 11

f1 = addfile("psi.nc", "r")
f2 = addfile("u.nc", "r")
f3 = addfile("v.nc", "r")

level = f1->P
lev_idx = ind(level.eq.200)

psi = f1->psi((year_start-1949)*12:(year_end-1949+1)*12-1,lev_idx,:,:)
u = f2->u((year_start-1949)*12:(year_end-1949+1)*12-1,lev_idx,:,:)
v = f3->v((year_start-1949)*12:(year_end-1949+1)*12-1,lev_idx,:,:)

psi_A = psi(idx1::12,:,:)
psi_B = psi(idx2::12,:,:)
psi_C = psi(idx3::12,:,:)

u_A = u(idx1::12,:,:)
u_B = u(idx2::12,:,:)
u_C = u(idx3::12,:,:)

v_A = v(idx1::12,:,:)
v_B = v(idx2::12,:,:)
v_C = v(idx3::12,:,:)

psi_season = (psi_A(0:nyears-3,:,:) + psi_B(0:nyears-3,:,:) + psi_C(1:nyears-2,:,:))/3.0
u_season = (u_A(0:nyears-3,:,:)+u_B(0:nyears-3,:,:)+u_C(1:nyears-2,:,:))/3.0
v_season = (v_A(0:nyears-3,:,:)+v_B(0:nyears-3,:,:)+v_C(1:nyears-2,:,:))/3.0

psi_season_ave = dim_avg_n_Wrap(psi_season, 0)
u_season_ave = dim_avg_n_Wrap(u_season, 0)
v_season_ave = dim_avg_n_Wrap(v_season, 0)

copy_VarMeta(psi(0,:,:), psi_season_ave)
copy_VarMeta(u(0,:,:), u_season_ave)
copy_VarMeta(v(0,:,:), v_season_ave)

out = addfile("ray-input.nc", "c")
out->psi = psi_season_ave
out->u = u_season_ave
out->v = v_season_ave
