!预先估计出零点区间，区间内仅一个零点
module bisecsolve
  implicit none
  real,parameter::precision=0.00000001
  contains
  !求解的代码
  subroutine bisec(a,b,s)
    implicit none
    real::a,b,c,s
	real::fa,fb,fc
	c=(a+b)/2
	fa=func(a)
	fb=func(b)
	fc=func(c)
	do while(abs(fc)>precision)
	   if(fa*fc<0)then
	      b=c
		  c=(a+b)/2
		  fb=func(b)
		  fc=func(c)
		else
		  a=c
		  c=(a+b)/2
		  fa=func(a)
		  fc=func(c)
		end if
	end do
	s=c
	return 
  end subroutine bisec
  !已知函数，形式为f(x)=0
  real function func(x)
    implicit none
	real::x
	func=(x-2)*(x-4)
  end function
end module bisecsolve

program main
use bisecsolve
implicit none
real::m,n,s,tm,tn,tz
open(1,file='data.dat')
open(2,file='output.dat')
print*,"输入求解区间"
read(1,*)m,n
print*,m,n
call bisec(m,n,s)
write(*,'("x=",f)')s
write(2,'("x=",f)')s
close(1)
close(2)
end program main