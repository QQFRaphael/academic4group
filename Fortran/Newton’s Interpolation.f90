program NewtonsInterpolation
implicit none
integer::n,i,col,row,j
real,allocatable::x(:),y(:),table(:,:)
real::x1,s,l
open(1,file='data.dat')
open(2,file='output.dat')
print*,"input the amounts of datas:"
read(1,*)n
print*,n
allocate(x(n),y(n),table(n,n))
write(*,'("input the interpolation data x,y")')
do i=1,n
  read(1,*)x(i),y(i)
  write(*,'("x=",f,"y=",f)')x(i),y(i)
end do
print*,"input x:"
read(1,*)x1
print*,x1
table=0
do i=1,n
  table(i,1)=y(i)
end do
do col=2,n
  do row=col,n
    table(row,col)=(table(row,col-1)-table(row-1,col-1))/(x(row)-x(row-col+1))
  end do
end do
s=table(1,1)
do i=2,n
  l=1
  do j=1,i-1
    l=l*(x1-x(j))
  end do
  l=l*table(i,i)
  s=s+l
end do
write(2,'("the interpolation result is:",f)')s
write(*,'("the interpolation result is:",f)')s
close(1)
close(2)
end program