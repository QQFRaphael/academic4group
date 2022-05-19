program main
implicit none
external F0,F1,F2
real,external::distance
integer,parameter::m=26
integer::i,j,k,l
real::u(2,m,m),v(2,m,m),h(2,m,m),c(2),g(2),u0(2,2,m,m),v0(2,2,m,m),&
      h0(2,2,m,m),u1(2,2,m,m),v1(2,2,m,m),h1(2,2,m,m),u2(2,2,m,m),&
      v2(2,2,m,m),h2(2,2,m,m),uf(2,m,m),vf(2,m,m),hf(2,m,m)
character*11::name(78)
c(1)=50000.
c(2)=500000.
g(1)=0.35
g(2)=0.4
open(1,file='name.txt')
read(1,*)name
close(1)
open(2,file='mid.grd',form='binary')
open(3,file='c1.grd',form='binary')
open(4,file='c2.grd',form='binary')
do i=1,13
  open(i+100,file=name((i-1)*6+1))
  read(i+100,'(26f12.7)')(u(1,j,1:m),j=1,m)
  close(i+100)
  
  open(i+200,file=name((i-1)*6+2))
  read(i+200,'(26f12.7)')(u(2,j,1:m),j=1,m)
  close(i+200)
  
  
  open(i+300,file=name((i-1)*6+3))
  read(i+300,'(26f12.7)')(v(1,j,1:m),j=1,m)
  close(i+300)
  
  open(i+400,file=name((i-1)*6+4))
  read(i+400,'(26f12.7)')(v(2,j,1:m),j=1,m)
  close(i+400)
  
  
  open(i+500,file=name((i-1)*6+5))
  read(i+500,'(26f12.7)')(h(1,j,1:m),j=1,m)
  close(i+500)
 
  open(i+600,file=name((i-1)*6+6))
  read(i+600,'(26f12.7)')(h(2,j,1:m),j=1,m)
  close(i+600)

  
  
  call F0(u0,u,c,m); print*,i,1
  call F0(v0,v,c,m); print*,i,2
  call F0(h0,h,c,m); print*,i,3

  call F1(u0,u1,u,c,g,m); print*,i,4
  call F1(v0,v1,v,c,g,m); print*,i,5
  call F1(h0,h1,h,c,g,m); print*,i,6
  
  call F2(u0,u1,u2,c,m);print*,i,7
  call F2(v0,v1,v2,c,m);print*,i,8
  call F2(h0,h1,h2,c,m);print*,i,9
  
  uf(1,1:m,1:m)=u2(1,1,1:m,1:m)-u2(2,1,1:m,1:m)
  uf(2,1:m,1:m)=u2(1,2,1:m,1:m)-u2(2,2,1:m,1:m)
  
  vf(1,1:m,1:m)=v2(1,1,1:m,1:m)-v2(2,1,1:m,1:m)
  vf(2,1:m,1:m)=v2(1,2,1:m,1:m)-v2(2,2,1:m,1:m)
  
  hf(1,1:m,1:m)=h2(1,1,1:m,1:m)-h2(2,1,1:m,1:m)
  hf(2,1:m,1:m)=h2(1,2,1:m,1:m)-h2(2,2,1:m,1:m)
  
  do j=1,2
    write(2)((uf(j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(2)((vf(j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(2)((hf(j,k,l),l=1,m),k=m,1,-1)
  end do
  

  do j=1,2
    write(3)((u2(1,j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(3)((v2(1,j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(3)((h2(1,j,k,l),l=1,m),k=m,1,-1)
  end do

  do j=1,2
    write(4)((u2(2,j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(4)((v2(2,j,k,l),l=1,m),k=m,1,-1)
  end do
  do j=1,2
    write(4)((h2(2,j,k,l),l=1,m),k=m,1,-1)
  end do
  
end do
close(2)
close(3)
close(4)
end program main

subroutine F0(u0,u,c,m)
implicit none
real,external::distance
integer::m
integer::i,j,k,l,o,p
real::u0(2,2,m,m),u(2,m,m),c(2)
real::w,t,r
do o=1,2
  do p=1,2
    do i=1,m
      do j=1,m
        w=0.
        t=0.
        do k=1,m
          do l=1,m
            r=distance(53.-(i-1)*1.0,53.-(k-1)*1.0,104.+(j-1)*1.0,104.+(l-1)*1.0)
            w=w+exp(-r**2/(4.*c(o)))
            t=t+u(p,k,l)*exp(-r**2/(4.*c(o)))
          end do
        end do
       u0(o,p,i,j)=t/w
      end do
    end do
  end do
end do
end subroutine F0

subroutine F1(u0,u1,u,c,g,m)
implicit none
real,external::distance
integer::m
integer::i,j,k,l,o,p
real::u0(2,2,m,m),u1(2,2,m,m),d(2,2,m,m),u(2,m,m),c(2),g(2)
real::w,t,r  
do o=1,2
  do p=1,2
  d(o,p,1:m,1:m)=u(p,1:m,1:m)-u0(o,p,1:m,1:m)
    do i=1,m
      do j=1,m
        w=0.
        t=0.
        do k=1,m
          do l=1,m
            r=distance(53.-(i-1)*1.0,53.-(k-1)*1.0,104.+(j-1)*1.0,104.+(l-1)*1.0)
            w=w+exp(-r**2/(4*c(o)*g(o)))
            t=t+d(o,p,k,l)*exp(-r**2/(4*c(o)*g(o)))
          end do
        end do
       u1(o,p,i,j)=u0(o,p,i,j)+t/w
      end do
    end do
  end do
end do  
end subroutine F1

subroutine F2(u0,u1,u2,c,m)
implicit none
real,external::distance
integer::m
integer::i,j,k,l,o,p
real::u0(2,2,m,m),u1(2,2,m,m),e(2,2,m,m),u2(2,2,m,m),c(2)
real::w,t,r  
do o=1,2
  do p=1,2
  e(o,p,1:m,1:m)=u1(o,p,1:m,1:m)-u0(o,p,1:m,1:m)
    do i=1,m
      do j=1,m
        w=0.
        t=0.
        do k=1,m
          do l=1,m
            r=distance(53.-(i-1)*1.0,53.-(k-1)*1.0,104.+(j-1)*1.0,104.+(l-1)*1.0)
            w=w+exp(-r**2/(4*c(o)))
            t=t+e(o,p,k,l)*exp(-r**2/(4*c(o)))
          end do
        end do
       u2(o,p,i,j)=u1(o,p,i,j)+3./4.*(u1(o,p,i,j)-u0(o,p,i,j))-t/w
      end do
    end do
  end do
end do  
end subroutine F2

function distance(lat1,lat2,lon1,lon2)
 implicit none
 real,parameter::R=6371.004,pi=3.1415926
 real::lat1,lat2,lon1,lon2
 real::distance,rr
 rr=cos(lat1*pi/180)*cos(lat2*pi/180)*cos((lon1-lon2)*pi/180)+sin(lat1*pi/180)*sin(lat2*pi/180)
 distance=R*acos(rr)
 return
end function distance