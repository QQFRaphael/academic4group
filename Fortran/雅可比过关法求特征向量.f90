program main
implicit none
real::a(5,5),eps,v(5,5)
integer::i,j
data a/10,1,2,3,4,1,9,-1,2,3,2,-1,7,3,-5,3,2,3,12,-1,4,-3,-5,-1,15/
eps=1e-6
call jaco(a,5,eps,v)
write(*,20)((v(i,j),i=1,5),j=1,5)
20 format(1x,5d15.6)
end program main

subroutine jaco(a,n,eps,v)
implicit none
integer::n
integer::p,flag,i,j
real::a(n,n),v(n,n),eps
real::g,u,u1,v1,v2,v3,sintheta,costheta,s,sn
v=0
do i=1,n
  v(i,i)=1
end do
g=0.
do i=2,n
  do j=1,i-1
    g=g+2*a(i,j)**2
  end do
end do
s=sqrt(g)
sn=eps/n*s
flag=0
100 s=s/n
200 do j=2,n
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
        do p=1,n
          g=a(i,p)*costheta+a(j,p)*sintheta
          a(j,p)=a(j,p)*costheta-a(i,p)*sintheta
          a(i,p)=g
          g=v(i,p)*costheta+v(j,p)*sintheta
          v(j,p)=v(j,p)*costheta-v(i,p)*sintheta
          v(i,p)=g
        end do
        do p=1,n
          a(p,i)=a(i,p)
          a(p,j)=a(j,p)
        end do
        g=2.*v2*sintheta*costheta
        a(i,i)=v1*costheta**2+v3*sintheta**2+g
        a(j,j)=v1*sintheta**2+v3*costheta**2-g
        a(i,j)=-u*2.*sintheta*costheta+v2*(costheta**2-sintheta**2)
        a(j,i)=a(i,j)
        !print*,"aa"
300     if(flag==1) then
          flag=0   
          goto 200
        end if
        if(s>sn) goto 100
      end do
    end do
end subroutine