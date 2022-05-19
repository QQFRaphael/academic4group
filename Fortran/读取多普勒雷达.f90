!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                        用于读取 CINRAD SA/SB 雷达数据                                               !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

MODULE RADAR_RECORD
IMPLICIT NONE
TYPE RADAR_RECORD_TYPE
	character*14	unused01                !保留
	integer*2	Message_Type            !1-表示雷达数据
	character*12	unused02                !保留
	integer*4	radical_collect_time	!径向数据收集时间(毫秒,自 00:00 开始)
	integer*2	radical_collect_date	!儒略日(Julian)表示,自 1970 年 1 月 1 日开始
	integer*2	unambiguousRange        !不模糊距离(表示:数值/10.=千米)
	integer*2	AzimuthAngle            !方位角(编码方式:[数值/8.]*[180./4096.]=度)
	integer*2	DataNumber              !当前仰角内径向数据序号
	integer*2	DataStatus              !径向数据状态 0:该仰角的第一条
						!           1:该仰角中间的径向数据
						!           2:该仰角的最后一条径向数据
						!           3:体扫开始的第一条径向数据
						!           4:体扫结束的最后一条径向数据
	integer*2	ElevationAngle          !仰角 (编码方式:[数值/8.]*[180./4096.]=度)
	integer*2	ElevationNumber         !体扫内的仰角数
	integer*2	FirstGateRangeOfRef     !反射率数据的第一个距离库的实际距离(单位:米)
	integer*2	FirstGateRangeOfDoppler	!多普勒数据的第一个距离库的实际距离(单位:米)
	integer*2	ReflectivityGateSize	!反射率数据的距离库长(单位:米)
	integer*2	DopplerGateSize         !多普勒数据的距离库长(单位:米)
	integer*2	ReflectivityGates       !反射率的距离库数
	integer*2	DopplerGates            !多普勒的距离库数
	integer*2	radicalnumber           !扇区号
	integer*4	coefofsys               !系统订正常数
	integer*2	RefPointer              !反射率数据指针(偏离雷达数据信息头的字节数) 表示第一个反射率数据的位置
	integer*2	VelPointer              !速度数据指针(偏离雷达数据信息头的字节数),表示第一个速度数据的位置
	integer*2	SWPointer               !谱宽数据指针(偏离雷达数据信息头的字节数),表示第一个谱宽数据的位置
	integer*2	VelResolution           !多普勒速度分辨率。 2:表示 0.5 米/秒
						!                4:表示 1.0 米/秒
	integer*2	VCP                     !体扫(VCP)模式 11:降水模式,16 层仰角
						!             21:降水模式,14 层仰角
						!             31:晴空模式,8 层仰角
						!             32:晴空模式,7 层仰角
	character*8	unused03                !保留
	integer*2	RefPointerReplay        !用于回放的反射率数据指针
	integer*2	VelPointerReplay        !用于回放的速度数据指针
	integer*2	SWPointerReplay         !用于回放的谱宽数据指针
	integer*2	NyquistVelocity         !Nyquist 速度(表示:数值/100. = 米/秒)
	character*38	unused04                !保留
	integer*1	dbz(460)                !反射率
						!距离库数:0-460 编码方式:(数值-2)/2.-32 = DBZ
						!当数值为 0 时,表示无回波数 据(低于信噪比阀值)
						!当数值为 1 时,表示距离模糊
	integer*1	vel(920)                !速度 距离库数:0-920 编码方式:
						!分辨率为 0.5 米/秒时 (数值-2)/2.-63.5 = 米/秒
						!分辨率为 1.0 米/秒时 (数值-2)-127 = 米/秒
						!当数值为 0 或 1 时,意义同上
	integer*1	SpectrlaWidth(920)      !谱宽 距离库数:0-920 编码方式:
						!(数值-2)/2.-63.5 = 米/秒
						!当数值为 0 或 1 时,意义同上
	character*4	unused05                !保留
						!说明: 1.数据的存储方式
						!每个体扫存储为一个单独的文件 2.数据的排列方式
						!按照径向数据的方式顺序排列,对于 CINRAD SA/SB 雷达,体扫数据排列自
						!低仰角开始到高仰角结束。 3.径向数据的长度
						!径向数据的长度固定,为 2432 字节。 4.距离库长和库数
						!反射率距离库长为 1000 米,最大距离库数为 460;
						!速度和谱宽距离库长为 250 米,最大距离库数为 920
END TYPE RADAR_RECORD_TYPE
END MODULE RADAR_RECORD

PROGRAM MAIN
USE RADAR_RECORD
IMPLICIT NONE
TYPE(RADAR_RECORD_TYPE) radar_data
integer::i
open(1,file='/Users/QQF/Desktop/Z_RADR_I_Z9200_20140521000000_O_DOR_SA_CAP.bin',form='binary')
do i=1,4039
read(1) radar_data
print*, radar_data%ElevationAngle/8.0*180.0/4096.0
end do
end