program main
implicit none
integer,parameter::m=216,n=516
real,parameter::default_val=-999.0,eps=1e-6
integer::nx=18,ny=12
real::a(m,m),v(m,m),x(m,n),tcf(m,n),eig(m,4)
integer::i,j,k,l
real::temp(m,m)
open(1,file="/home/QQF/sstpx.grd",form="unformatted")
do i=1,n
  l=1
  do j=1,nx
    do k=1,ny
      read(1)x(l,i)
      l=l+1
    end do
  end do
end do
a=0
do i=1,m
  do j=1,n
    do k=1,m
      a(i,j)=a(i,j)+x(i,k)*x(k,j)
    end do
  end do
end do
call change_default(m,n,x,default_val)
call jacobi(a,m,eps,v)
call arrange(m,a,v,eig)
call time_coeff(n,m,v,x,tcf)
end program main





subroutine jacobi(a,m,eps,v)
implicit none
integer::m
integer::p,flag,i,j
real::a(m,m),v(m,m),eps
real::g,u,u1,v1,v2,v3,sintheta,costheta,s,sn
v=0
do i=1,m
  v(i,i)=1
end do
g=0.
do i=2,m
  do j=1,i-1
    g=g+2*a(i,j)**2
  end do
end do
s=sqrt(g)
sn=eps/m*s
flag=0
100 s=s/m
200 do j=2,m
      do i=1,j-1
        if(abs(a(i,j))<=sn) goto 300
        flag=1
        v1=a(i,i)
        v2=a(i,j)
        v3=a(j,j)
        u=0.5*(v1-v3)
        u1=u/v2
        if(abs(u)<=1e-10) then
          g=1
        else 
          g=sign(1.,u1)/(abs(u1)+sqrt(1+u1**2))
        end if
        sintheta=g/sqrt(1+g**2)
        costheta=1./sqrt(1+g**2)
        do p=1,m
          g=a(i,p)*costheta+a(j,p)*sintheta
          a(j,p)=a(j,p)*costheta-a(i,p)*sintheta
          a(i,p)=g
          g=v(i,p)*costheta+v(j,p)*sintheta
          v(j,p)=v(j,p)*costheta-v(i,p)*sintheta
          v(i,p)=g
        end do
        do p=1,m
          a(p,i)=a(i,p)
          a(p,j)=a(j,p)
        end do
        g=2.*v2*sintheta*costheta
        a(i,i)=v1*costheta**2+v3*sintheta**2+g
        a(j,j)=v1*sintheta**2+v3*costheta**2-g
        a(i,j)=-u*2.*sintheta*costheta+v2*(costheta**2-sintheta**2)
        a(j,i)=a(i,j)
300     if(flag==1) then
          flag=0   
          goto 200
        end if
        if(s>sn) goto 100
      end do
    end do
end subroutine jacobi


subroutine arrange(m,a,v,eig)
implicit none
integer::m
real::a(m,m),v(m,m),eig(m,4)
real::temp,lam_sum
integer::i,j,k,l
lam_sum=0
do i=1,m
  lam_sum=lam_sum+a(i,i)
  eig(i,1)=a(i,i)
end do
do i=1,m-1
  do j=i+1,m
    if(eig(i,1)<eig(j,1)) then
      temp=eig(i,1)
      eig(i,1)=eig(j,1)
      eig(j,1)=temp
      do k=1,m
        temp=v(k,j)
        v(k,j)=v(k,i)
        v(k,i)=temp
      end do
    end if
  end do
end do
eig(1,2)=eig(1,1)
do i=2,m
  eig(i,2)=eig(i-1,2)+eig(i,1)
end do
do i=1,m
  eig(i,3)=eig(i,1)/lam_sum
  eig(i,4)=eig(i,2)/lam_sum
end do
write(*,'("Total Square Error:",f10.3)')lam_sum
end subroutine arrange


subroutine time_coeff(n,m,v,x,tcf)
implicit none
integer::n,m
real::v(m,m),tcf(m,n),x(m,n)
integer::i,j,k
real::v_trans(m,m)
v_trans=0
do i=1,m
  do j=1,m
    v_trans(i,j)=v(j,i)
  end do
end do
do i=1,m
  do j=1,n
    do k=1,m
      tcf(i,j)=tcf(i,j)+v(i,k)*x(k,j)
    end do
  end do
end do
end subroutine time_coeff


subroutine change_default(m,n,x,default_val)
implicit none
integer::m,n
real::x(m,n),default_val
integer::i,j
do i=1,m
  do j=1,n
    if(x(m,n)==default_val) x(m,n)=0.
  end do
end do
end subroutine change_default