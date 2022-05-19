function f(x)
implicit none
real::x,f
f=x*x-9
end function

function f_d(x)
implicit none
real::x,f_d
f_d=2*x
end function

program main
implicit none
real::x
real,parameter::eps=1e-10
real,external::f,f_d
print*,"input the start number x:"
read*,x
do while(abs(f(x)/f_d(x))>eps)
  x=x-f(x)/f_d(x)
end do
write(*,'("the result is:",f)')x
end program main