program main
implicit none
integer::i
real,parameter::eps=1e-5
real::n,m       !区间
real::x0,x1     !起始点
real::k         !控制运算次数
real::x
real::l         !输入区间上最大一阶导数值
print*,"input the interval (n,m):"
read*,n,m
write(*,'("input the start number x:")')
read*,x0
print*,"input the largest value of the first derivative in the interval:"
read*,l
x1=exp(-x0)
x=x1
k=log(eps*(1-l))/(log(abs(x0-x1))+log(l))+1
do i=1,k
  x=exp(-x)
end do
write(*,'("the result is:",f)')x
end program main