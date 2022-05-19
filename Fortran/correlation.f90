!get the correlation coefficient
subroutine correlation(x,y,n,r)
integer n,i
real x(n),y(n),r
real(8) sxy,sx,sy,xmean,ymean
!*********************************************
!x: array of index
!y: array of index or pattern
!n: samlpe size
!r: correlation coefficient

xmean=0.0
ymean=0.0
do i=1,n
   xmean=xmean+x(i)/real(n)
   ymean=ymean+y(i)/real(n)
end do

sxy=0.0
sx=0.0
sy=0.0
do i=1,n
   sxy=sxy+x(i)*y(i)
   sx=sx+(x(i)-xmean)**2
   sy=sy+(y(i)-ymean)**2
end do

r=(sxy-n*xmean*ymean)/sqrt(sx*sy)


return
end subroutine correlation



