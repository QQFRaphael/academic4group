program main
implicit none
real,allocatable::A(:,:),x(:),xk(:)
real::eps=1e-5
integer::n,i,j,k,l
open(1,file='input.dat')
open(2,file='output.dat')
read(1,*)n
allocate(A(n,n+1),x(n),xk(n))
xk=0
do i=1,n
  read(1,*)A(i,1:n+1)
end do
read(1,*)x(1:n)
do i=1,n
  A(i,1:n+1)=A(i,1:n+1)/A(i,i)
end do
do i=1,n
  A(i,i)=0
  A(i,1:n)=-A(i,1:n)
end do
do i=2,n
  xk(1)=xk(1)+x(i)*A(1,i)
end do
xk(1)=xk(1)+A(1,n+1)
do i=2,n
  do j=1,i
    xk(i)=xk(i)+xk(j)*A(i,j)
  end do
  do j=i,n
    xk(i)=xk(i)+x(j)*A(i,j)
  end do
  xk(i)=xk(i)+A(i,n+1)
end do
do i=1,n
  do while(abs(xk(i)-x(i))>eps)
    x=xk
	xk=0
	do l=2,n
      xk(1)=xk(1)+x(l)*A(1,l)
    end do
    xk(1)=xk(1)+A(1,n+1)
	do k=2,n
      do j=1,k
        xk(k)=xk(k)+xk(j)*A(k,j)
      end do
      do j=k,n
        xk(k)=xk(k)+x(j)*A(k,j)
      end do
      xk(k)=xk(k)+A(k,n+1)
    end do
  end do
end do
write(2,*)xk
write(*,*)xk
end