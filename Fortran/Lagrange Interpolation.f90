program LagrangeInterpolation
implicit none
integer::n,i,j,k
real,allocatable::x(:),l1(:),y(:)
real::x1,l=0
open(1,file='input.dat')
open(2,file='output.dat')
print*,"input the amount of interpolation data"
read(1,*)n
print*,n
allocate(x(n),l1(n),y(n))
l1=1
write(*,'("input the interpolation data:x,y")')
do i=1,n
  read(1,*),x(i),y(i)
  write(*,'("x=",f,"y=",f)')x(i),y(i)
end do
print*,"input x"
read(1,*)x1
write(*,'("x=",f)')x1
do i=1,n
  do j=1,n
    if(i==j)then
   continue
 else
   l1(i)=l1(i)*(x1-x(j))/(x(i)-x(j))
 end if
 end do
  l1(i)=l1(i)*y(i)
  l=l+l1(i)
end do
write(2,'("the interpolation result is:",f)')l
write(*,'("the interpolation result is:",f)')l
close(1)
close(2)
end