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
real::a(n,n),vk(n),v(n)
integer::i,j
real::max
external::mul,stand
open(1,file='dat.dat')
open(2,file='out.dat')
do i=1,n
  read(1,*)a(i,1:n)
end do
read(1,*)v(1:n)
call mul(a,v,vk,n)
do i=1,n
  do while(abs(v(i)-vk(i))>eps)
    v=vk
	vk=0
	call mul(a,v,vk,n)
	call stand(vk,n,max)
  end do
end do
write(*,'("the largest eigenvalue is:",f)')max
write(2,'("the largest eigenvalue is:",f)')max
end