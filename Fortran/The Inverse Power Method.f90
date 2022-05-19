!矩阵求逆
subroutine inv(a,n)
implicit none
integer::n
real::a(n,n)
real::b(n,2*n)
integer::i,row,col
b=0
do i=1,n
  b(i,1:n)=a(i,1:n)
  b(i,n+i)=1
end do
do col=1,n
  do row=1,n
    if(row==col)cycle
    b(row,1:2*n)=b(row,1:2*n)-b(row,col)/b(col,col)*b(col,1:2*n)
  end do
end do
do i=1,n
  b(i,1:2*n)=b(i,1:2*n)/b(i,i)
end do
do i=1,n
  a(i,1:n)=b(i,n+1:2*n)
end do
end subroutine

!矩阵乘法
subroutine mul(a,v,vk,n)
implicit none
integer::n
real::a(n,n),v(n),vk(n)
integer::i,j
do i=1,n
  do j=1,n
    vk(i)=vk(i)+a(i,j)*v(j)
  end do
end do
end subroutine

!标准化
subroutine stand(vk,n,t)
implicit none
integer::n
real::vk(n),t
integer::i,j,max
max=1
do i=2,n
  if(vk(i)>vk(max))max=i
end do
t=vk(max)
vk(1:n)=vk(1:n)/t
end subroutine

program main
implicit none
integer,parameter::n=3
real,parameter::eps=1e-4
real::a(n,n),v(n),vk(n)
integer::i
real::max
open(1,file='dat.dat')
open(2,file='out.dat')
do i=1,n
  read(1,*)a(i,1:n)
end do
read(1,*)v(1:n)
call inv(a,n)
call mul(a,v,vk,n)
do i=1,n
  do while(abs(v(i)-vk(i))>eps)
    v=vk
	vk=0
	call mul(a,v,vk,n)
	call stand(vk,n,max)
  end do
end do
write(*,'("the smallest eigenvalue is:",f)')1.0/max
write(2,'("the smallest eigenvalue is:",f)')1.0/max
end