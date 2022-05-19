!get the coefficient of regression
subroutine regression(x,y,n,a)
integer n,i
real s1,s2,x(n),y(n),a
real(8) xmean,ymean
!*********************************************
!x: array of index
!y: array of index or pattern
!n: samlpe size
!a: coefficient of regression

xmean=0.0
ymean=0.0
do i=1,n
   xmean=xmean+x(i)/real(n)
   ymean=ymean+y(i)/real(n)
end do

s1=0.0
s2=0.0
do i=1,n
   s1=s1+x(i)*y(i)
   s2=s2+(x(i)-xmean)**2
end do
a=(s1-n*xmean*ymean)/s2
return
end subroutine regression
