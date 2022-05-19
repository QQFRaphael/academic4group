%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Calculate 2d Barotropic Rossby ray paths over specified
%%  background fields.
%%  Written by Jeff Shaman.
%%  Some minor changes, and all the errors: Eli Tziperman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Look for "Required input:" below.

%%  There 3 background states to be used, possibly
%%  Complex solutions are tracked, initial northward propagation is 
%%  required
%%  Everything is done with units this time
%%  All fields needed are solved for in the grid and those grids are
%%  then interpolated in the actual ray tracing.

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  The following are needed (based on Karoly, 1983):
%%  1)  BetaM--this can be solved for a number of ways, as Karoly did 
%%  (and also Hoskins and Karoly, 1981), where BetaM=2*Omega*cos2(Lat)/r
%%         - d/dy[(1/cos2(Lat))*d/dy(cos2(Lat)*UbarM)]
%%     or as Hoskins and Ambrizzi specify (2 ways: w/ and w/o Mercator) 
%%
%%  2)  UbarM--per Karoly, this is u/cos(Lat)
%%  3)  VbarM--per Karoly, this is v/cos(Lat)
%%  4)  x--r*Lat, where Lat=degrees*pi/180
%%  5)  y--r*log[(1+sin(lat))/cos(lat)]
%%  6)  qbar--this is (d2/dx+d2/dy)psi/cos2(lat) + 2*Omega*sin(lat)
%%  7)  dqbar/dy--this is BetaM
%%  8)  dqbar/dx--this is -d/dx[(d2/dx+d2/dy)psi/cos2(lat)]
%%  9)  d2qbar/dxx
%%  10) d2qbar/dxy
%%  11) d2qbar/dyy
%%  12) dUbarM/dx
%%  13) dUbarM/dy
%%  14) dVbarM/dx
%%  15) dVbarM/dy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  From these we can interpolate the fields and calculate values needed
%%  for ray tracing, namely:
%%  Ks--this is (abs(BetaM/Um))^0.5 for zonally symmetric flows
%%     Kw, those with non-zero frequency are (abs(BetaM/(Um-w/k))^0.5
%%     For 2-D flow, Ks might be (abs(BetaM/Um + dqbar/dx/Vm))^0.5 or some such
%%  The other way is to calculate it for stationary waves straight from the
%%    wave numbers
%%  A) Ks=sqrt(k^2+l^2)
%%  Karoly (1983) Eqn 10:
%%  B) dk/dt=-k*dUbarM/dx -l*dVbarM/dx +(d2qbar/dxy*k-d2qbar/dxx*l)/Ks^2
%%  C) dl/dt=-k*dUbarM/dy -l*dVbarM/dy +(d2qbar/dyy*k-d2qbar/dxy*l)/Ks^2
%%  Karoly (1983) Eqn 9:
%%  D) dx/dt=ug=UbarM+{(k^2-l^2)*dqbar/dy - 2*k*l*dqbar/dx}/Ks^4
%%  E) dy/dt=vg=VbarM+{2*k*l*dqbar/dy - (k^2-l^2)*dqbar/dx}/Ks^4

%%  Getting the September climatology
close all; clear all
%profile on
addpath /usr/local/bin %% Adds the location of loaddap
%% savepath % Saves the paths for future sessions

%%%%%%%%%%%%%%%%%%%%%
%% Required input: %%
%%%%%%%%%%%%%%%%%%%%%

%% Specify initial ray locations (=forcing sites):
%% y=33 is equator, smaller values are north of it:
%frcx=[70 80 90 100 70 80 90 100];
%frcy=[35 35 35 35  31 31 31 31];
%frcx=[70:5:110 70:5:110];
%frcy=[ones(1,9)*31 ones(1,9)*35];
frcx=[86];
frcy=[9];
Nlocations=length(frcx);


%% Eli: specify periods (use Inf for a zero frequency):
day=86400;
Periods=[Inf]*day;
%Periods=[-80 -60 -40 -20 Inf 20 40 60 80]*day;
frequencies=2*pi./Periods;
Nfrequencies=length(frequencies);

%% specify initial k wave number:
k_wavenumbers=[7];
%k_wavenumbers=[2];

%% time step: make sure results are robust to halving the time step:
dt=900;

%% integration duration (in hours):
integration_time=240;

Nsteps=round(integration_time*3600/dt);

%%fprintf(1,'calc_2d_raytrace.m run parameters: \n');
%%k_wavenumbers,Periods/day,Nlocations,frcx,frcy,dt,Nsteps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% options that don't need to be changed in most cases:

% use interp2 instead of griddata?
use_interp2=1;

% Eli: set to 1 to do complex ray tracing (0 if you don't know what
% that is)
do_complex_tracing=0;

% set to 1 if you are interested only in rays that go to the northern
% hemisphere:
do_only_northern_hisphere_rays=0;

%% smoothing before ray tracing is a good idea...:
do_smooth_background_fields=1;

%% see background field data reading section below:
use_climatology=0;

%% specify highest latitudes where background fields are specified;
%% this depends on the resolution and format of the background fields:
jmin=5;
jmax=69;


%% save parameters to be read by plot_rays.m:
%%save('Output/parameters.mat','k_wavenumbers','Nsteps'...
%%     ,'frcx','frcy','frequencies','do_complex_tracing');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ENd of required input: %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Eli: changed from loaddods to loaddap:
psi_in = ncread("input/ray-input.nc",'psi');
u_in = ncread("input/ray-input.nc",'u');
v_in = ncread("input/ray-input.nc",'v');

lat_in = ncread("input/ray-input.nc",'Y');
lon_in = ncread("input/ray-input.nc",'X');

mylat = lat_in(frcy);
mylon = lon_in(frcx);


u200=permute(u_in,[2,1]);

v200=permute(v_in,[2,1]);
psi200=permute(psi_in,[2,1]);

%%disp('done getting data.');

%%%  Other

x=transpose(lon_in); %% Eli changed from x=transpose(X)
y=lat_in;  %% Eli changed from =u
Y=y*ones(1,144);
X=ones(73,1)*x;
lat=Y*pi/180;
Lat(:,:,1)=lat;

f=(2*7.2925e-5)*sin(Lat);
r=6.37e6;

%%%%%%%%%%%%%%%%%%%%
%%  Getting the x and y Mercator coordinates

xx=r*x*pi/180;
yy=r*log((1+sin(y*pi/180))./cos(y*pi/180));

%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Taking the 200 mbar fields

%% Eli changed from u to u.u etc for all three fields here:
%% u,v,psi; needed for conversion to loaddap.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Smoothing the fields

if do_smooth_background_fields
  u200=zfltr(u200,1,10,1);
  v200=zfltr(v200,1,10,1);
  psi200=zfltr(psi200,1,10,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for UbarM, VbarM, and even psiM

%%%  Ks= {[2*omega - ((1/cos(lat))(d/d(lat))^2)*((1+cos2*Lat)/2)*U]/U}^0.5

UbarM=u200./cos(Lat);
VbarM=v200./cos(Lat);
PsiM=psi200./cos(Lat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for BetaM; NOTE that cos2(Lat)=(1+cos(2*Lat))/2

a=(2*7.2925e-5);
b=(1+cos(2*Lat))/2;
trm1=a*b/r;
c=b.*UbarM;
d=1./b;
cdy=c;cdy2=c;
for i=2:72
  cdy(i,:)=(mean(c(i-1:i,:))-mean(c(i:i+1,:)))/(mean(yy(i-1:i))- ...
                                                mean(yy(i:i+1)));
end
cdy=cdy.*d;
for i=3:71
  cdy2(i,:)=(mean(cdy(i-1:i,:))-mean(cdy(i:i+1,:)))/(mean(yy(i- ...
                                                    1:i))-mean(yy(i:i+1)));
end

BetaM=trm1-cdy2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for qbar
%%%%  The larger structure is to make sure have entire zonal field

tempPSI=[PsiM(:,141:144) PsiM PsiM(:,1:4)];
tempxx=[xx(141:144) xx xx(1:4)];

px1=tempPSI;px2=px1;py1=px1;py2=px1;
for i=2:72
  py1(i,:)=(mean(tempPSI(i-1:i,:))-mean(tempPSI(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end
for i=3:71
  py2(i,:)=(mean(py1(i-1:i,:))-mean(py1(i:i+1,:)))/(mean(yy(i-1: ...
                                                    i))-mean(yy(i:i+1)));
end
for i=2:151
  px1(:,i)=(mean(tempPSI(:,i-1:i)')'-mean(tempPSI(:,i:i+1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end
for i=3:150
  px2(:,i)=(mean(px1(:,i-1:i)')'-mean(px1(:,i:i+1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end

dd=[d(:,141:144) d d(:,1:4)];
tempf=[f(:,141:144) f f(:,1:4)];

tempqbar=tempf+dd.*(px2+py2);
qbar=tempqbar(:,5:148);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for dqbar/dx, and d2qbar/dx2

px1=NaN*ones(73,152); px2=px1;
for i=4:149
  px1(:,i)=(mean(tempqbar(:,i-1:i)')'-mean(tempqbar(:,i:i+ ...
                                                    1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end
for i=5:148
  px2(:,i)=(mean(px1(:,i-1:i)')'-mean(px1(:,i:i+1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end

dqbardx=px1(:,5:148);
d2qbardx2=px2(:,5:148);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for dqbar/dy (should be same as BetaM), and d2qbar/dy2

py1=NaN*ones(73,152); py2=py1;
for i=(jmin-1):(jmax+1)
  py1(i,:)=(mean(tempqbar(i-1:i,:))-mean(tempqbar(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end
for i=jmin:jmax
  py2(i,:)=(mean(py1(i-1:i,:))-mean(py1(i:i+1,:)))/(mean(yy(i-1: ...
                                                    i))-mean(yy(i:i+1)));
end

dqbardy=py1(:,5:148);
d2qbardy2a=py2(:,5:148);

%%%%  Alternately for d2qbar/dy2

py2=NaN*ones(73,144);
for i=4:70
  py2(i,:)=(mean(BetaM(i-1:i,:))-mean(BetaM(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end

d2qbardy2=py2;

%% A debugging text for the calculation of d^2 qbar/dy^2:
% sum(sum(d2qbardy2(6:68,6:138)-d2qbardy2a(6:68,6:138)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for d2qbar/dxy (once);  COULD ALSO DO dx of either BetaM or
%%%%  dqbardy

py1=NaN*ones(73,144);
for i=2:72
  py1(i,:)=(mean(dqbardx(i-1:i,:))-mean(dqbardx(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end

d2qbardxy=py1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for dUbarM/dx and dUbarM/dy

tempU=[UbarM(:,144) UbarM UbarM(:,1)];

px1=NaN*ones(73,146);py1=px1;
for i=2:72
  py1(i,:)=(mean(tempU(i-1:i,:))-mean(tempU(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end
for i=2:145
  px1(:,i)=(mean(tempU(:,i-1:i)')'-mean(tempU(:,i:i+1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end

dUbarMdx=px1(:,2:145);
dUbarMdy=py1(:,2:145);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Solving for dVbarM/dx and dVbarM/dy

tempV=[VbarM(:,144) VbarM VbarM(:,1)];

px1=NaN*ones(73,146);py1=px1;
for i=2:72
  py1(i,:)=(mean(tempV(i-1:i,:))-mean(tempV(i:i+1,:)))/ ...
           (mean(yy(i-1:i))-mean(yy(i:i+1)));
end
for i=2:145
  px1(:,i)=(mean(tempV(:,i-1:i)')'-mean(tempV(:,i:i+1)')')/ ...
           (mean(tempxx(i-1:i))-mean(tempxx(i:i+1)));
end

dVbarMdx=px1(:,2:145);
dVbarMdy=py1(:,2:145);

%%%%%%%%%%%%%%%%%%%%%
%% Start ray tracing:
%%%%%%%%%%%%%%%%%%%%%

%% Solving for the ray path for different forcing sites (initial
%% locations of rays):

for ilocation=1:Nlocations

  frx=frcx(ilocation);
  fry=frcy(ilocation);
 
  [subxx,subyy]=meshgrid(xx,yy(jmin:jmax));
  [subyy_interp2,subxx_interp2]=meshgrid(yy(jmin:jmax),xx);
  [XX,YY]=meshgrid(x,y(jmin:jmax));
  sBetaM=BetaM(jmin:jmax,:);
  sUbarM=UbarM(jmin:jmax,:);
  sVbarM=VbarM(jmin:jmax,:);
  sqbar=qbar(jmin:jmax,:);
  sdqbardy=dqbardy(jmin:jmax,:);
  sdqbardx=dqbardx(jmin:jmax,:);
  sd2qbardx2=d2qbardx2(jmin:jmax,:);
  sd2qbardy2=d2qbardy2(jmin:jmax,:);
  sd2qbardxy=d2qbardxy(jmin:jmax,:);
  sdUbarMdx=dUbarMdx(jmin:jmax,:);
  sdUbarMdy=dUbarMdy(jmin:jmax,:);
  sdVbarMdx=dVbarMdx(jmin:jmax,:);
  sdVbarMdy=dVbarMdy(jmin:jmax,:);
  
  %%%%%%%%%%%%%
  %%%%  Estimating the initial Ks from the forcing site for a specific
  %%%%  BetaM and UbarM
  

  Nk_wavenumbers=length(k_wavenumbers);
  for iomega=1:Nfrequencies
    omega=frequencies(iomega);
    period=round((2*pi/omega)/day);
    
    for kkr=1:Nk_wavenumbers
      kk=k_wavenumbers(kkr);
      for RR=1:3
        fprintf('Ray tracing... period=%d, k=%d, root=%d, ilocation=%d, frcx=%d, frcy=%d\n' ...
                ,period,kk,RR,ilocation,frcx,frcy);
        spotk=kk/r/cos(Lat(fry+4,frx));
        subk=[ilocation kk RR];
        ytt=yy(jmin:jmax);yi=ytt(fry);xi=xx(frx);
        %%  Ks=sqrt(abs(sBetaM(fry,frx)/sUbarM(fry,frx)));
        %%  spotl=real((Ks^2-spotk^2)^0.5);
        Bint=sBetaM(fry,frx);Uint=sUbarM(fry,frx);Vint=sVbarM(fry,frx);
        qxint=sdqbardx(fry,frx);qyint=sdqbardy(fry,frx);
        %% Calculate the initial l wave number from the initial omega
        %% and k by solving the polynomial equation based on the
        %% dispersion relation (equation 8 in Karoly 1983):
        %% change the following to have a non zero frequency:
        
        %% Eli: added omega terms here for the non zero frequency case:
        cz(1)=Vint;
        cz(2)=Uint*spotk-omega;
        cz(3)=Vint*spotk^2+qxint;
        cz(4)=Uint*spotk^3-qyint*spotk-omega*spotk^2;
        tl=roots(cz);
        spotl=tl(RR);
        Ks=(spotl^2+spotk^2)^0.5;
        
        
        if do_only_northern_hisphere_rays
          %%  If only interested in rays that go northward, break the
          %%  run if the starting l wavenumber has negative real part:
          tstl=real(spotl)*r*cos(Lat(fry+4,1));
          if real(spotl)<=0 
            fprintf(1,['*** found real(l)<0, ray going to southern ' ...
                       'hemisphere, not tracing it\n']);
            fprintf('[real(l) ilocation kk RR]=[%g %g %g %g]' ...
                    ,real(spotl),ilocation,kk,RR);
            break 
          end
        end
        
        if do_complex_tracing==0
          %%  If not interested in complex ray tracing, break the run
          %%  if the starting l wavenumber has an imaginary part.  N.B.
          %%  The complex conjugates give redundant solutions, so only
          %%  need to trace one
          tstl2=imag(spotl)*r*cos(Lat(fry+4,1));
          if tstl2~=0
            fprintf('*** found complex initial l, not tracing. \n')
            fprintf('    [tstl2 ilocation kk omega RR]=[%g,%g,%g,%g,%g]\n' ...
                    ,tstl2,ilocation,kk,omega,RR);
            break
          end
        end
        
        %%%%%%%%%%%
        %%  Starting the loop with the above initial k,l, and Ks
        
        for t=1:Nsteps
          if rem(t,60)==0
            fprintf(1,'t = %g\n',t);
          end
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%  Interpolating the fields to the current spot
          
          if use_interp2==0
            Uint=griddata(subyy,subxx,sUbarM,yi,xi,'spline');
            Bint=griddata(subyy,subxx,sBetaM,yi,xi,'spline');
            Vint=griddata(subyy,subxx,sVbarM,yi,xi,'spline');
            qint=griddata(subyy,subxx,sqbar,yi,xi,'spline');
            qyint=griddata(subyy,subxx,sdqbardy,yi,xi,'spline');
            qxint=griddata(subyy,subxx,sdqbardx,yi,xi,'spline');
            qyyint=griddata(subyy,subxx,sd2qbardy2,yi,xi,'spline');
            qxxint=griddata(subyy,subxx,sd2qbardx2,yi,xi,'spline');
            qxyint=griddata(subyy,subxx,sd2qbardxy,yi,xi,'spline');
            Uyint=griddata(subyy,subxx,sdUbarMdy,yi,xi,'spline');
            Uxint=griddata(subyy,subxx,sdUbarMdx,yi,xi,'spline');
            Vyint=griddata(subyy,subxx,sdVbarMdy,yi,xi,'spline');
            Vxint=griddata(subyy,subxx,sdVbarMdx,yi,xi,'spline');
            Cosint=griddata(subyy,subxx,cos(Lat(jmin:jmax,:)),yi,xi,'spline');
          else
            Uint=interp2(subyy_interp2,subxx_interp2,sUbarM',yi,xi,'spline');
            Bint=interp2(subyy_interp2,subxx_interp2,sBetaM',yi,xi,'spline');
            Vint=interp2(subyy_interp2,subxx_interp2,sVbarM',yi,xi,'spline');
            qint=interp2(subyy_interp2,subxx_interp2,sqbar',yi,xi,'spline');
            qyint=interp2(subyy_interp2,subxx_interp2,sdqbardy',yi,xi,'spline');
            qxint=interp2(subyy_interp2,subxx_interp2,sdqbardx',yi,xi,'spline');
            qyyint=interp2(subyy_interp2,subxx_interp2,sd2qbardy2',yi,xi,'spline');
            qxxint=interp2(subyy_interp2,subxx_interp2,sd2qbardx2',yi,xi,'spline');
            qxyint=interp2(subyy_interp2,subxx_interp2,sd2qbardxy',yi,xi,'spline');
            Uyint=interp2(subyy_interp2,subxx_interp2,sdUbarMdy',yi,xi,'spline');
            Uxint=interp2(subyy_interp2,subxx_interp2,sdUbarMdx',yi,xi,'spline');
            Vyint=interp2(subyy_interp2,subxx_interp2,sdVbarMdy',yi,xi,'spline');
            Vxint=interp2(subyy_interp2,subxx_interp2,sdVbarMdx',yi,xi,'spline');
            Cosint=interp2(subyy_interp2,subxx_interp2,cos(Lat(jmin:jmax,:))',yi,xi,'spline');
          end

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%  Solving for the changes
          
          dkdt=-spotk*Uxint-spotl*Vxint+(qxyint*spotk-qxxint*spotl)/Ks^2;
          dldt=-spotk*Uyint-spotl*Vyint+(qyyint*spotk-qxyint*spotl)/Ks^2;
          dxdt=Uint+((spotk^2-spotl^2)*qyint-2*spotk*spotl*qxint)/Ks^4;
          dydt=Vint+(2*spotk*spotl*qyint-(spotk^2-spotl^2)*qxint)/Ks^4;
          
          %%%%%%%%%%%%%%
          %%  Updating the changes
          
          xi=xi+real(dxdt)*dt;
          if xi>=max(max(subxx))
            xi=xi-max(max(subxx));
          end
          yi=yi+real(dydt)*dt;
          spotl=spotl+dldt*dt;
          spotk=spotk+dkdt*dt;
          Ks=(spotk^2+spotl^2)^0.5;
          
          %%%%%%%%%%%%%%%
          %%  Finding the location
          
          if use_interp2==0
            Yint=griddata(subyy,subxx,YY,yi,xi,'spline');
            Xint=griddata(subyy,subxx,XX,yi,xi,'spline');
          else
            Yint=interp2(subyy_interp2,subxx_interp2,YY',yi,xi,'spline');
            Xint=interp2(subyy_interp2,subxx_interp2,XX',yi,xi,'spline');
          end

          %% make sure ray does not leave the domain where
          %% background fields are given:
          if Yint<y(jmax) || Yint>y(jmin)
            fprintf(1,'*** Yint>Ymax, breaking.  (Xint,Yint)=(%g,%g)\n'...
                    ,Xint,Yint);
            break
          end
          
          %%%%%%%%%%%%%%
          %%  Storing

          %% XX what is each of these?
          adj=r*Cosint;
          trl(t,:)=[xi yi];
          rnums(t,:)=[real(spotl)*adj real(spotk)*adj real(Ks)*adj];
          inums(t,:)=[imag(spotl)*adj imag(spotk)*adj imag(Ks)*adj];
          rpchg(t,:)=[real(dxdt)*adj real(dydt)*adj];
          ipchg(t,:)=[imag(dxdt)*adj imag(dydt)*adj];
          loc(t,:)=[Yint Xint];
          wchg(t,:)=[real(dldt)*adj real(dkdt)*adj imag(dldt)*adj imag(dkdt)*adj];
          rsom(t,:)=[real(Uint*spotk+Vint*spotl+(qxint*spotl-qyint*spotk)/Ks^2)];
          isom(t,:)=[imag(Uint*spotk+Vint*spotl+(qxint*spotl-qyint*spotk)/Ks^2)];
          
          if rem(t,5)==0
            ss=double(loc);
            eval(sprintf('save Output/raypath_k%d_period%d_root%d_frcx%d_frcy%d ss -ascii -tabs',kk,period,RR,frcx,frcy));
            %%alL=[trl rnums inums rpchg ipchg wchg loc rsom isom];
            %% Eli: moved output files to subdirectory:
            %%sprintf('save Output/raypath_k%d_period%d_location%d_root%d alL -ascii -tabs'...
            %%             ,kk,period,ilocation,RR)
            %%eval(sprintf('save Output/raypath_k%d_period%d_location%d_root%d alL -ascii -tabs'...
            %%             ,kk,period,ilocation,RR));
          end
          
        end
      end % end do loop over roots
    end % end do loop over wavenumbers
  end % end do loop over frequencies
end

%profile report
