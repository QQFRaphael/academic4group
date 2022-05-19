2019.11.13

在Manjaro/Arch的系统上，用gfortran、gcc版本9.2.0编译WRF报错。主要是rcp目录下的xdr.h等文件没找到

解决办法：gfortran编译选项增加一个-ltirpc

```shell
SFC             =       gfortran -ltirpc
SCC             =       gcc
CCOMP           =       gcc
DM_FC           =       mpif90
DM_CC           =       mpicc
```

