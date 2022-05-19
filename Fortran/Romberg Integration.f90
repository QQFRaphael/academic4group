double precision function f(x)
implicit none
double precision::x
if(x==0) then
  f=1
else 
  f=sin(x)/x
end if
end function

program main
implicit none
double precision::n,m        
double precision::tk,t2k     
double precision,external::f
double precision,parameter::eps=5e-6
integer::k,i
print*,"input the interval(m,n):"
read*,m,n
tk=(n-m)/2*(f(n)+f(m))
t2k=tk/2+(n-m)/2*f((n+m)/2)
k=1
do while(abs(tk-t2k)>=eps)
  k=k+1
  tk=0
  do i=1,2**(k-1)
    tk=tk+f(m+(2*i-1)*(n-m)/(2**k))
  end do
  tk=t2k/2+(n-m)/(2**k)*tk
  k=k+1
  t2k=0
  do i=1,2**(k-1)
    t2k=t2k+f(m+(2*i-1)*(n-m)/(2**k))
  end do
  t2k=tk/2+(n-m)/(2**k)*t2k
end do
write(*,'("the result is:",f)')t2k
end program main