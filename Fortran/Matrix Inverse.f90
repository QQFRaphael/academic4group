program main
implicit none
integer::n,i,row,col
real,allocatable::mat(:,:)
open(1,file='input.dat')
open(2,file='output.dat')
read(1,*),n
allocate(mat(n,2*n))
mat=0
do i=1,n
  read(1,*)mat(i,1:n)
end do
do i=1,n
  mat(i,n+i)=1
end do
do col=1,n
  do row=1,n
    if(row==col) cycle
    mat(row,1:2*n)=mat(row,1:2*n)-mat(row,col)/mat(col,col)*mat(col,1:2*n)
  end do
end do
do i=1,n
  mat(i,1:2*n)=mat(i,1:2*n)/mat(i,i)
end do
do i=1,n
  write(*,'(4f7.3,1x)')mat(i,n+1:2*n)
end do
end program main