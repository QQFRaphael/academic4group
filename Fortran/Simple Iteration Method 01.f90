program main
implicit none
real::x
real,parameter::eps=1e-5
print*,'input the start number:'
read*,x
do while(abs(x-exp(-x))>eps)
  x=exp(-x)
end do
write(*,'("the result is:",f)')x
end program main
