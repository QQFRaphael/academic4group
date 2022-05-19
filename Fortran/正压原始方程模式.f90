!This is the code of the baroclinic model
!By QQF, November 4th,2012, at NUIST
!Instruction:
!       A.Variable and Constant: m=20              total zonal points
!                                n=16              total meridional points
!                                nt2=72            to judge whether we have already integerated
!                                                  12 hours, when we should do inner smoothing
!                                nt4=6             to determine the step applying boundary smoothing
!                                nt5=36            to control the circumstance we need to use time smoothing
!                                day=2             the day we want to forcast, day=2 means the next day(24 hours later)
!                                d=300000.0        the grid spacing
!                                center_lat=51.0   the center latitude
!                                center_lon=118.0  the center longitude
!                                dt=600.0          the time step
!                                zo=2500.0         a constant used for slowing down the external gravity wave
!                                                  and also increasing the stability of our differencial form
!                                s=0.5             the smoothing coefficient,s=0.5 can filter these high frequency waves
!                                na                a counter in order to control our forecast
!                                nb                a counter of time integration steps
!                                nn                a counter of time integration steps, in this case, we use it to recognize
!                                                  the time we have already integrated for 12 hours
!                                ua,va,za          zonal and meridional component of wind, za is geopotential height
!                                ub,vb,zb          a,b,c means our meteorological elements at differnet time
!                                uc,va,zc          in this model, we use a at the input field, and the c is our result
!                                MEC               short for map enlargement coefficient
!                                f                 the Coriolis parameter
!                                work              a space array, use in calculation 
!                                k                 Conic constant, Lambert project
!                                le                distance between tropical and north pole in projection plane
!                                r                 radius of the earth
!                                theta             standard colatitude
!                                phi               colatitude of the center
!                                l1                distance from the center to north pole
!                                l2=d*(n-1)/2.     distance from the center to south boundary
!       B.Subroutines:           cal_MEC_f         calculate map enlargement coefficient and Coriolis parameter
!                                cal_geoWind       calculate geostropical wind
!                                IBV               fix the initiation boundary value            
!                                time_integration  time integrate
!                                smooth_boundary   smooth the boundary
!                                smooth_time       time smoothing
!                                smooth_inner      smooth the inner realm
!       C.Files:                 ua,va,za,uc       ua,va,za,uc,vc,zc,MEC,f are input and output files    
!                                vc,zc,MEC         notice for_grads is used for grads,all data write in 
!                                f,for_grads       this sequence:za,ua,va,zc,uc,vc

program main
implicit none
external cal_MEC_f,cal_geoWind,IBV,time_integration,smooth_boundary,&
         smooth_time,smooth_inner
integer::na,nb,nn
integer,parameter::m=20,n=16,nt2=72,nt4=6,nt5=36,day=2
real,parameter::d=300000.0,center_lat=51.0,center_lon=118.0,&
                dt=600.0,zo=2500.0,s=0.5,c1=dt/2.0,c2=dt*2.0
real,dimension(m,n)::ua,va,za,ub,vb,zb,uc,vc,zc,MEC,f,work

10 format(20f10.5)                    !u,v format
20 format(20f6.0)                     !z   format
30 format("na=",i3,3x,"nb=",i3)       !format for print na,nb

call cal_MEC_f(MEC,f,d,center_lat,m,n)!calculate map enlargement coefficient and Coriolis parameter
open(1,file="MEC.dat")
write(1,10)MEC
close(1)
open(2,file="f.dat")
write(2,10)f
close(2)

open(3,file="za.dat")
read(3,20)za
close(3)

open(100,file="for_grads.grd",form='binary')
write(100)za

call cal_geoWind(ua,va,za,MEC,f,d,m,n)

open(4,file="ua.dat")
write(4,10)ua
close(4)
write(100)ua

open(5,file="va.dat")
write(5,10)va
close(5)
write(100)va

call IBV(ua,va,za,ub,vb,zb,m,n)
call IBV(ua,va,za,uc,vc,zc,m,n)

!forcast begin
do na=1,day

  nb=0
  !integrate 1 hour , Euler backward form
  do nn=1,6
    call time_integration(ua,va,za,ua,va,za,ub,vb,zb,MEC,f,d,dt,zo,m,n)
    call time_integration(ua,va,za,ub,vb,zb,ua,va,za,MEC,f,d,dt,zo,m,n)
    nb=nb+1
  end do
  !smooth the boundary once an hour
  call smooth_boundary(za,work,s,m,n)
  call smooth_boundary(ua,work,s,m,n)
  call smooth_boundary(va,work,s,m,n)
  !forward integration, half time step
  call time_integration(ua,va,za,ua,va,za,ub,vb,zb,MEC,f,d,c1,zo,m,n)
  !central integration, half time step
  call time_integration(ua,va,za,ub,vb,zb,uc,vc,zc,MEC,f,d,dt,zo,m,n)
  nb=nb+1

  ub=uc; vb=vc; zb=zc
  !central integration, one time step, 12 hours in all
  do nn=1,66
  
    call time_integration(ua,va,za,ub,vb,zb,uc,vc,zc,MEC,f,d,c2,zo,m,n)
    nb=nb+1
    write(*,30)na,nb
  
    if(nb/nt4*nt4==nb) then
      call smooth_boundary(zc,work,s,m,n)
      call smooth_boundary(uc,work,s,m,n)
      call smooth_boundary(vc,work,s,m,n)
    end if
    !time smoothing, every 6 hours
    if(nb==nt5.OR.nb==nt5+1) then
      call smooth_time(ua,va,za,ub,vb,zb,uc,vc,zc,s,m,n)
    end if

    ua=ub; va=vb; za=zb
    ub=uc; vb=vc; zb=zc

  end do
  !smooth inner area, every 12 hours
  call smooth_inner(zc,work,s,m,n)
  call smooth_inner(uc,work,s,m,n)
  call smooth_inner(vc,work,s,m,n)

  write(*,30)na,nb
  !for next 12 hours
  uc=ua; vc=va; zc=za

end do

open(6,file="zc.dat")
write(6,20)zc
close(6)

open(7,file="uc.dat")
write(7,10)uc
close(7)

open(8,file="vc.dat")
write(8,10)vc
close(8)

write(100)zc
write(100)uc
write(100)vc
close(100)

end program main    


subroutine cal_MEC_f(MEC,f,d,center_lat,m,n)
implicit none
integer::m,n
integer::i,j
real::MEC(m,n),f(m,n)
real::d,center_lat,k,le,r,theta,phi,d2r,l,l1,l2,x0,y0,xi,yi,w,sinl
k=0.7156                    !Conic constant, Lambert project
le=11423370.0               !distance between tropical and north pole in projection plane
r=6371000.0                 !radius of the earth
d2r=180./3.1415926          !degree to radian
theta=30./d2r               !standard colatitude
phi=(90-center_lat)/d2r     !colatitude of the center
w=2./k
l1=r*sin(theta)/k*(tan(phi/2.)/tan(theta/2.))**k  !distance from the center to north pole
l2=d*(n-1)/2.                                     !distance from the center to south boundary
x0=-(m-1)/2.
y0=(l1+l2)/d
forall(i=1:m:1,j=1:n:1)
  xi=(i-1)+x0
  yi=y0-(j-1)
  l=d*sqrt(xi**2+yi**2)
  sinl=(1.0-(l/le)**w)/(1.0+(l/le)**w)
  MEC(i,j)=k*l/(r*sqrt(1-sinl**2))
  f(i,j)=1.4584e-4*sinl
end forall
end subroutine cal_MEC_f


subroutine cal_geoWind(ua,va,za,MEC,f,d,m,n)
implicit none
integer::m,n
real,dimension(m,n)::ua,va,za,MEC,f
real::d
integer::i,j
forall(i=1:m-1:1,j=1:n-1:1)
  ua(i,j)=-MEC(i,j)*9.8/f(i,j)*(za(i,j+1)-za(i,j))/d
  va(i,j)=-MEC(i,j)*9.8/f(i,j)*(za(i+1,j)-za(i,j))/d
end forall
end subroutine cal_geoWind


subroutine IBV(ua,va,za,ub,vb,zb,m,n)
implicit none
integer::m,n
real,dimension(m,n)::ua,va,za,ub,vb,zb
integer::i,j
forall(i=1:m:1,j=1:n:n-1)
  ub(i,j)=ua(i,j)
  vb(i,j)=va(i,j)
  zb(i,j)=za(i,j)
end forall
forall(i=1:m:m-1,j=1:n:1)
  ub(i,j)=ua(i,j)
  vb(i,j)=va(i,j)
  zb(i,j)=za(i,j)
end forall
end subroutine IBV


subroutine time_integration(ua,va,za,ub,vb,zb,uc,vc,zc,MEC,f,d,dt,zo,m,n)
implicit none
integer::m,n
integer::i,j
real,dimension(m,n)::ua,va,za,ub,vb,zb,uc,vc,zc,MEC,f
real::d,dt,zo,const,E,G,H
const=0.25/d
forall(i=2:m-1:1,j=2:n-1:1)
  E=-const*MEC(i,j)*((ub(i+1,j)+ub(i,j))*(ub(i+1,j)-ub(i,j))+&
    (ub(i,j)+ub(i-1,j))*(ub(i,j)-ub(i,j))+&
    (vb(I,j-1)+vb(i,j))*(ub(i,j)-ub(i,j-1))+&
    (vb(I,j)+vb(i,j+1))*(ub(i,j+1)-ub(i,j))+&
    19.6*(zb(i+1,j)-zb(i-1,j)))+f(i,j)*vb(i,j)
  G=-const*MEC(i,j)*((ub(i+1,j)+ub(i,j))*(vb(i+1,j)-vb(i,j))+&
    (ub(i,j)+ub(i-1,j))*(vb(i,j)-vb(i-1,j))+&
    (vb(i,j-1)+vb(i,j))*(vb(i,j)-vb(i,j-1))+&
    (vb(i,j)+vb(i,j+1))*(vb(i,j+1)-vb(i,j))+&
    19.6*(zb(i,j+1)-zb(i,j-1)))-f(i,j)*ub(i,j)
  H=-const*MEC(i,j)*((ub(i+1,j)+ub(i,j))*(zb(i+1,j)-zb(i,j))+&
    (ub(i,j)+ub(i-1,j))*(zb(i,j)-zb(i-1,j))+&
    (vb(i,j-1)+vb(i,j))*(zb(i,j)-zb(i,j-1))+&
    (vb(i,j)+vb(i,j+1))*(zb(i,j+1)-zb(i,j))+&
    2.0*(zb(i,j)-zo)*(ub(i+1,j)-ub(i-1,j)+vb(i,j+1)-vb(i,j-1)))
  uc(i,j)=ua(i,j)+dt*E
  vc(i,j)=va(i,j)+dt*G
  zc(i,j)=za(i,j)+dt*H
end forall
end subroutine time_integration


subroutine smooth_boundary(zc,work,s,m,n)
implicit none
integer::m,n
real,dimension(m,n)::zc,work
real::s
integer::i,j
work=zc
forall(i=2:m-1:m-3,j=2:n-1:1)
  zc(i,j)=work(i,j)+s*(1-s)/2.*(work(i-1,j)+work(i+1,j)+work(i,j-1)+work(i,j+1)-4.*work(i,j))+&
          s*s/4.*(work(i-1,j-1)+work(i-1,j+1)+work(i+1,j-1)+work(i+1,j+1)-4.*work(i,j))
end forall
forall(i=2:m-1:1,j=2:n-1:n-3)
  zc(i,j)=work(i,j)+s*(1-s)/2.*(work(i-1,j)+work(i+1,j)+work(i,j-1)+work(i,j+1)-4.*work(i,j))+&
          s*s/4.*(work(i-1,j-1)+work(i-1,j+1)+work(i+1,j-1)+work(i+1,j+1)-4.*work(i,j))
end forall
end subroutine smooth_boundary


subroutine smooth_time(ua,va,za,ub,vb,zb,uc,vc,zc,s,m,n)
implicit none
integer::m,n,i,j
real,dimension(m,n)::ua,va,za,ub,vb,zb,uc,vc,zc
real::s
forall(i=2:m-1:1,j=2:n-1:1)
  ub(i,j)=ub(i,j)+s*(ua(i,j)+uc(i,j)-2.0*ub(i,j))/2.0
  vb(i,j)=vb(i,j)+s*(va(i,j)+vc(i,j)-2.0*vb(i,j))/2.0
  zb(i,j)=zb(i,j)+s*(za(i,j)+zc(i,j)-2.0*zb(i,j))/2.0
end forall
end subroutine smooth_time


subroutine smooth_inner(zc,work,s,m,n)
implicit none
integer::m,n
real,dimension(m,n)::zc,work
real::s,rs
integer::i,j
rs=-s     !we also do the inverse smoothing
work=zc
forall(i=2:m-1:1,j=2:n-1:1)
  zc(i,j)=work(i,j)+s/4.*(work(i-1,j)+work(i+1,j)+work(i,j-1)+work(i,j+1)-4.*work(i,j))
end forall
work=zc
forall(i=2:m-1:1,j=2:n-1:1)
  zc(i,j)=work(i,j)+rs/4.*(work(i-1,j)+work(i+1,j)+work(i,j-1)+work(i,j+1)-4.*work(i,j))
end forall
end subroutine smooth_inner