!       last modified 2008-05-06
! add TMAXmean and TMINmean output in qc function
! in TN10p subroutine, add an 1e-5 term on all
! thresholds, to eliminate computational error. ( 3.5 may store like
! 3.5000001 or 3.49999999 in thresholds )
! changed TN10p subroutine, set missing value for monthly output the
! same level as R, eg. >10 days missing in a month, then set this month
! missing.
!  last modified 2008-06-15
! changed percentile funcion to calculate multi-level percentiles in a single
! routine, also changed threshold.

      MODULE COMM
      IMPLICIT NONE
      SAVE

      character(20) :: STNID
      integer(4)    :: STDSPAN, BASESYEAR, BASEEYEAR, PRCPNN, SYEAR, EYEAR, TOT, YRS, BYRS, WINSIZE, SS, MTHS
!     parameter(MAXYEAR=500)	TOT(total days) PRCPNN=1.0 MNASTAT=YNASTAT=0
      real :: LATITUDE, PRCP(500*365), TMAX(500*365),TMIN(500*365), MISSING
      integer(4) :: YMD(500*365,3), MNASTAT(500,12,3),YNASTAT(500,3),MON(12),MONLEAP(12)

      data MON/31,28,31,30,31,30,31,31,30,31,30,31/
!	noleap
      data MONLEAP/31,28,31,30,31,30,31,31,30,31,30,31/
      data WINSIZE/5/

      END MODULE COMM

!   Main program start

      use COMM

      character(80) :: ifile
      character(80) :: header
      integer(4) :: stnnum
	character(500)	:: infile
	character(500)	:: outfile
	real(4),dimension(:,:,:),allocatable	:: tasmax,tasmin,pr
	real(4),dimension(:,:,:),allocatable	:: yfd,ysu,yid,ytr,ygsl
	real(4),dimension(:,:,:),allocatable	:: ytxx,ytxn,ytnx,ytnn,ydtr
	real(4),dimension(:,:,:),allocatable	:: yr10mm,yr20mm,yrnnmm,ysdii
	real(4),dimension(:,:,:),allocatable	:: yrx1day,yrx5day,ycdd,ycwd
	real(4),dimension(:,:,:),allocatable	:: yr95p,yr99p,yprcptot
	real(4),dimension(:,:,:),allocatable	:: ytx10p,ytn10p,ytx90p,ytn90p
	real(4),dimension(:,:,:),allocatable	:: ycsdi,ywsdi
	real(4),dimension(:,:,:),allocatable	:: mdtr,mrx5day,mrx1day
	real(4),dimension(:,:,:),allocatable	:: mtn10p,mtn90p,mtx10p,mtx90p
	real(4),dimension(:,:,:),allocatable	:: mtxx,mtnx,mtxn,mtnn
	real(4),dimension(:),allocatable	:: times,lat,lon,years,months
	real(4),dimension(:,:,:),allocatable	:: txxout1
	real(4),dimension(:,:),allocatable	:: fdout,txxout2,txxout3,rnnout1,r5out1,r5out2
	real(4),dimension(:,:),allocatable	:: tx10out1,tx10out2,tx10out3,tx10out4
	real(4),dimension(:),allocatable	:: gslout,rnnout2,cddout1,cddout2
	real(4),dimension(:),allocatable	:: r95out1,r95out2,r95out3,tx10out5,tx10out6
	integer(4)	:: NX,NY,NZ

	BASESYEAR=1961
	BASEEYEAR=1990
	PRCPNN=1.0
	SYEAR=1950
	EYEAR=2005
	YRS=EYEAR-SYEAR+1
	MTHS=YRS*12
	BYRS=BASEEYEAR-BASESYEAR+1

	infile	= '../tasmax_day_CSIRO-Mk3-6-0_historical_r1i1p1_19500101-20051231.nc'
	call griddims(infile,NX,NY,NZ)
	allocate(tasmax(NX,NY,NZ))
	allocate(tasmin(NX,NY,NZ))
	allocate(pr(NX,NY,NZ))
	allocate(times(NZ))
	allocate(lat(NY))
	allocate(lon(NX))
	allocate(years(YRS))
	allocate(months(MTHS))

	allocate(yfd(NX,NY,YRS))
	allocate(ysu(NX,NY,YRS))
	allocate(yid(NX,NY,YRS))
	allocate(ytr(NX,NY,YRS))
	allocate(ygsl(NX,NY,YRS))
	allocate(ytxx(NX,NY,YRS))
	allocate(ytxn(NX,NY,YRS))
	allocate(ytnx(NX,NY,YRS))
	allocate(ytnn(NX,NY,YRS))
	allocate(ydtr(NX,NY,YRS))
	allocate(yr10mm(NX,NY,YRS))
	allocate(yr20mm(NX,NY,YRS))
	allocate(yrnnmm(NX,NY,YRS))
	allocate(ysdii(NX,NY,YRS))
	allocate(yrx1day(NX,NY,YRS))
	allocate(yrx5day(NX,NY,YRS))
	allocate(ycdd(NX,NY,YRS))
	allocate(ycwd(NX,NY,YRS))
	allocate(yr95p(NX,NY,YRS))
	allocate(yr99p(NX,NY,YRS))
	allocate(yprcptot(NX,NY,YRS))
	allocate(ytx10p(NX,NY,YRS))
	allocate(ytx90p(NX,NY,YRS))
	allocate(ytn10p(NX,NY,YRS))
	allocate(ytn90p(NX,NY,YRS))
	allocate(ycsdi(NX,NY,YRS))
	allocate(ywsdi(NX,NY,YRS))
	allocate(mdtr(NX,NY,MTHS))
	allocate(mrx5day(NX,NY,MTHS))
	allocate(mrx1day(NX,NY,MTHS))
	allocate(mtn10p(NX,NY,MTHS))
	allocate(mtx10p(NX,NY,MTHS))
	allocate(mtn90p(NX,NY,MTHS))
	allocate(mtx90p(NX,NY,MTHS))
	allocate(mtnn(NX,NY,MTHS))
	allocate(mtnx(NX,NY,MTHS))
	allocate(mtxn(NX,NY,MTHS))
	allocate(mtxx(NX,NY,MTHS))

	allocate(fdout(YRS,4))
	allocate(gslout(YRS))
	allocate(txxout1(YRS,12,4))
	allocate(txxout2(YRS,4))
	allocate(txxout3(YRS,13))
	allocate(rnnout1(YRS,3))
	allocate(rnnout2(YRS))
	allocate(r5out1(YRS,13))
	allocate(r5out2(YRS,13))
	allocate(cddout1(YRS))
	allocate(cddout2(YRS))
	allocate(r95out1(YRS))
	allocate(r95out2(YRS))
	allocate(r95out3(YRS))
	allocate(tx10out1(YRS,13))
	allocate(tx10out2(YRS,13))
	allocate(tx10out3(YRS,13))
	allocate(tx10out4(YRS,13))
	allocate(tx10out5(YRS))
	allocate(tx10out6(YRS))

!	print *,'allocate complete'

	call readgrid(infile,'tasmax',times,lat,lon,tasmax,NX,NY,NZ)
	tasmax= tasmax-273.15
	infile	= '../tasmin_day_CSIRO-Mk3-6-0_historical_r1i1p1_19500101-20051231.nc'
	call readgrid(infile,'tasmin',times,lat,lon,tasmin,NX,NY,NZ)
	tasmin= tasmin-273.15
	infile	= '../pr_day_CSIRO-Mk3-6-0_historical_r1i1p1_19500101-20051231.nc'
	call readgrid(infile,'pr',times,lat,lon,pr,NX,NY,NZ)
	pr	= pr*86400.0

	do i=1,YRS
	years(i)=times((i-1)*365+1)
	end do
	do i=1,MTHS
	months(i)=times((i-1)*30.41667+1)
	end do

      MISSING=-99.9
      SS=int(WINSIZE/2)
	TOT=NZ
	YNASTAT=0
	MNASTAT=0
	do i=YRS+1,500
		do j=1,3
			YNASTAT(i,j)=1
			do k=1,12
				MNASTAT(i,k,j)=1
			end do
		end do
	end do

	open (21,file="Y.txt")
	open (22,file="M.txt")
	open (23,file="D.txt")
	do i=1,TOT
		read(21,*) YMD(i,1)
		read(22,*) YMD(i,2)
		read(23,*) YMD(i,3)
	end do
	close(21)
	close(22)
	close(23)

	print *,'reading complete'

	do i=1,NX
	do j=1,NY
	LATITUDE=lat(j)
	do k=1,NZ
	PRCP(k)=pr(i,j,k)
	TMAX(k)=tasmax(i,j,k)
	TMIN(k)=tasmin(i,j,k)
	end do

      call FD(fdout)    ! FD, SU, ID, TR
	do k=1,YRS
	yfd(i,j,k)=fdout(k,1)
	ysu(i,j,k)=fdout(k,2)
	yid(i,j,k)=fdout(k,3)
	ytr(i,j,k)=fdout(k,4)
	end do

!	print *,'fd complete'

      call GSL(gslout)   ! GSL
	do k=1,YRS
	ygsl(i,j,k)=gslout(k)
	end do

!	print *,'gsl complete'

      call TXX(txxout1,txxout2,txxout3)   ! TXx, TXn, TNx, TNn, DTR
	do k=1,YRS
	ytxx(i,j,k)=txxout2(k,1)
	ytxn(i,j,k)=txxout2(k,2)
	ytnx(i,j,k)=txxout2(k,3)
	ytnn(i,j,k)=txxout2(k,4)
	ydtr(i,j,k)=txxout3(k,13)
	do l=1,12
	mtxx(i,j,l+k*12-12)=txxout1(k,l,1)
	mtxn(i,j,l+k*12-12)=txxout1(k,l,2)
	mtnx(i,j,l+k*12-12)=txxout1(k,l,3)
	mtnn(i,j,l+k*12-12)=txxout1(k,l,4)
	mdtr(i,j,l+k*12-12)=txxout3(k,l)
	end do
	end do
!	print *,'txx complete'

      call Rnnmm(rnnout1,rnnout2) ! R10mm, R20mm, Rnnmm, SDII
	do k=1,YRS
	yr10mm(i,j,k)=rnnout1(k,1)
	yr20mm(i,j,k)=rnnout1(k,2)
	yrnnmm(i,j,k)=rnnout1(k,3)
	ysdii(i,j,k)=rnnout2(k)
	end do
!	print *,'rnnmm complete'

      call RX5day(r5out1,r5out2)! Rx1day, Rx5day
	do k=1,YRS
	yrx1day(i,j,k)=r5out1(k,13)
	yrx5day(i,j,k)=r5out2(k,13)
	do l=1,12
	mrx1day(i,j,l+k*12-12)=r5out1(k,l)
	mrx5day(i,j,l+k*12-12)=r5out2(k,l)
	end do
	end do
!	print *,'rx5day complete'

      call CDD(cddout1,cddout2)   ! CDD, CWD
	do k=1,YRS
	ycdd(i,j,k)=cddout1(k)
	ycwd(i,j,k)=cddout2(k)
	end do
!	print *,'cdd complete'

      call R95p(r95out1,r95out2,r95out3)  ! R95p, R99p, PRCPTOT
	do k=1,YRS
	yr95p(i,j,k)=r95out1(k)
	yr99p(i,j,k)=r95out2(k)
	yprcptot(i,j,k)=r95out3(k)
	end do
!	print *,'r95p complete'

      call TX10p(tx10out1,tx10out2,tx10out3,tx10out4,tx10out5,tx10out6) ! TX10p, TN10p, TX90p, TN90p
	do k=1,YRS
	ytx10p(i,j,k)=tx10out1(k,13)
	ytx90p(i,j,k)=tx10out2(k,13)
	ytn10p(i,j,k)=tx10out3(k,13)
	ytn90p(i,j,k)=tx10out4(k,13)
	ywsdi(i,j,k)=tx10out5(k)
	ycsdi(i,j,k)=tx10out6(k)
	do l=1,12
	mtx10p(i,j,l+k*12-12)=tx10out1(k,l)
	mtx90p(i,j,l+k*12-12)=tx10out2(k,l)
 	mtn10p(i,j,l+k*12-12)=tx10out3(k,l)
	mtn90p(i,j,l+k*12-12)=tx10out4(k,l)
	end do
	end do
!	print *,'tx10p complete'

	print '(1x,F8.3,A10)',((i-1)*NY+j)*100.0/(NX*NY),'% complete'
      end do
	end do

	outfile='fd_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yfd,NX,NY,YRS,'fd')
	outfile='su_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ysu,NX,NY,YRS,'su')
	outfile='id_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yid,NX,NY,YRS,'id')
	outfile='tr_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytr,NX,NY,YRS,'tr')
	outfile='gsl_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ygsl,NX,NY,YRS,'gsl')
	outfile='txx_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytxx,NX,NY,YRS,'txx')
	outfile='txn_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytxn,NX,NY,YRS,'txn')
	outfile='tnx_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytnx,NX,NY,YRS,'tnx')
	outfile='tnn_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytnn,NX,NY,YRS,'tnn')
	outfile='dtr_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ydtr,NX,NY,YRS,'dtr')
	outfile='r10mm_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yr10mm,NX,NY,YRS,'r10mm')
	outfile='r20mm_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yr20mm,NX,NY,YRS,'r20mm')
	outfile='r1mm_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yrnnmm,NX,NY,YRS,'r1mm')
	outfile='sdii_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ysdii,NX,NY,YRS,'sdii')
	outfile='rx1day_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yrx1day,NX,NY,YRS,'rx1day')
	outfile='rx5day_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yrx5day,NX,NY,YRS,'rx5day')
	outfile='cdd_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ycdd,NX,NY,YRS,'cdd')
	outfile='cwd_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ycwd,NX,NY,YRS,'cwd')
	outfile='r95p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yr95p,NX,NY,YRS,'r95p')
	outfile='r99p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yr99p,NX,NY,YRS,'r99p')
	outfile='prcptot_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,yprcptot,NX,NY,YRS,'prcptot')
	outfile='tx10p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytx10p,NX,NY,YRS,'tx10p')
	outfile='tn10p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytn10p,NX,NY,YRS,'tn10p')
	outfile='tx90p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytx90p,NX,NY,YRS,'tx90p')
	outfile='tn90p_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ytn90p,NX,NY,YRS,'tn90p')
	outfile='wsdi_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ywsdi,NX,NY,YRS,'wsdi')
	outfile='csdi_yr_CSIRO-Mk3-6-0_historical_r1i1p1_1950-2005.nc'
	call writegrid(outfile,years,lat,lon,ycsdi,NX,NY,YRS,'csdi')

	outfile='txx_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtxx,NX,NY,MTHS,'txx')
	outfile='txn_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtxn,NX,NY,MTHS,'txn')
	outfile='tnx_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtnx,NX,NY,MTHS,'tnx')
	outfile='tnn_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtnn,NX,NY,MTHS,'tnn')
	outfile='dtr_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mdtr,NX,NY,MTHS,'dtr')
	outfile='rx1day_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mrx1day,NX,NY,MTHS,'rx1day')
	outfile='rx5day_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mrx5day,NX,NY,MTHS,'rx5day')
	outfile='tx10p_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtx10p,NX,NY,MTHS,'tx10p')
	outfile='tn10p_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtn10p,NX,NY,MTHS,'tn10p')
	outfile='tx90p_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtx90p,NX,NY,MTHS,'tx90p')
	outfile='tn90p_mon_CSIRO-Mk3-6-0_historical_r1i1p1_195001-200512.nc'
	call writegrid(outfile,months,lat,lon,mtn90p,NX,NY,MTHS,'tn90p')
	


      end

      integer function leapyear(iyear)
      integer iyear

      if(mod(iyear,400).eq.0) then
        leapyear=1
      else
        if(mod(iyear,100).eq.0) then
          leapyear=0
        else
          if(mod(iyear,4).eq.0) then
            leapyear=1
          else
            leapyear=0
          endif
        endif
      endif

      end

	subroutine griddims(infile,NX,NY,NZ)
	USE COMM
	USE netcdf
	IMPLICIT NONE
	integer(4)	::	NX,NY,NZ
	integer(4)	::	ncid
	character(500)	::	infile
	character(50)	::	xname, yname, zname
	call check(nf90_open(infile,nf90_nowrite,ncid))
	call check(nf90_inquire_dimension(ncid,1,xname,NZ))
	call check(nf90_inquire_dimension(ncid,2,yname,NY))
	call check(nf90_inquire_dimension(ncid,3,zname,NX))
	call check(nf90_close(ncid))
	end

	subroutine readgrid(infile,vname,times,lat,lon,idata,NX,NY,NZ)
	use COMM
	use netcdf
	implicit none
	real(4),dimension(NZ)	:: times
	real(4),dimension(NY)	:: lat
	real(4),dimension(NX)	:: lon
	real(4),dimension(NX,NY,NZ)	:: idata
	character(500)	::	infile
	character(50)	::	vname
	integer(4)	:: ncid,varid,NX,NY,NZ
	call check(nf90_open(infile,nf90_nowrite,ncid))
	call check(nf90_inq_varid(ncid,'time',varid))
	call check(nf90_get_var(ncid,varid,times))
	call check(nf90_inq_varid(ncid,'lat',varid))
	call check(nf90_get_var(ncid,varid,lat))
	call check(nf90_inq_varid(ncid,'lon',varid))
	call check(nf90_get_var(ncid,varid,lon))
	call check(nf90_inq_varid(ncid,vname,varid))
	call check(nf90_get_var(ncid,varid,idata))
	call check(nf90_close(ncid))
	end

	subroutine writegrid(outfile,times,lat,lon,idata,NX,NY,NZ,vname)
	use netcdf
	implicit none
	real(4),dimension(NZ)	:: times
	real(4),dimension(NY)	:: lat
	real(4),dimension(NX)	:: lon
	real(4),dimension(NX,NY,NZ)	:: idata
	integer	:: ncid,varid,xid,yid,zid,vxid,vyid,vzid
	integer	:: NX,NY,NZ
	integer,dimension(3)	:: dimids
	character(500)	:: outfile
	character(50)	:: vname
	call check(nf90_create(outfile,nf90_clobber,ncid))
	call check(nf90_def_dim(ncid,"lon",NX,xid))
	call check(nf90_def_dim(ncid,"lat",NY,yid))
	call check(nf90_def_dim(ncid,"time",NZ,zid))
	call check(nf90_def_var(ncid,"lon",nf90_real,xid,vxid))
	call check(nf90_def_var(ncid,"lat",nf90_real,yid,vyid))
	call check(nf90_def_var(ncid,"time",nf90_real,zid,vzid))
	call check(nf90_put_att(ncid,vxid,"units","degrees_east"))
	call check(nf90_put_att(ncid,vyid,"units","degrees_north"))
	call check(nf90_put_att(ncid,vzid,"units","days since 1850-01-01 00:00:00"))
	call check(nf90_put_att(ncid,vzid,"calendar","noleap"))
	dimids=(/xid,yid,zid/)
	call check(nf90_def_var(ncid,vname,nf90_float,dimids,varid))
	call check(nf90_enddef(ncid))
	call check(nf90_put_var(ncid,vxid,lon))
	call check(nf90_put_var(ncid,vyid,lat))
	call check(nf90_put_var(ncid,vzid,times))
	call check(nf90_put_var(ncid,varid,idata))
	call check(nf90_close(ncid))
	end

	subroutine check(istatus)
	use netcdf
	use COMM
	implicit none
	integer	:: istatus
	if (istatus /= nf90_noerr) then
	write(*,*) trim(adjustl(nf90_strerror(istatus)))
	end if
	end


      subroutine percentile(x, length, nl, per, oout)
      use COMM
      integer length,nl
      real x(length), per(nl)
      real xtos(length),bb,cc,oout(nl)
      integer nn
      logical ismiss,nomiss
      
      do i=1,nl
        if(per(i).gt.1.or.per(i).lt.0) then
!         print*,nl,i,per(i)
          print *, "Function percentile return error: parameter perc"
          stop
        endif
      enddo

      nn=0
      do i=1, length
        if(nomiss(x(i)))then
          nn=nn+1
          xtos(nn)=x(i)
        endif
      enddo

      if(nn.eq.0) then
        oout=MISSING
      else
        call sort(nn,xtos)
        do i=1,nl
          bb=nn*per(i)+per(i)/3.+1/3.
          cc=real(int(bb))
          if(int(cc).ge.nn) then
            oout(i)=xtos(nn)
          else
            oout(i)=xtos(int(cc))+(bb-cc)*(xtos(int(cc)+1)-xtos(int(cc)))
          endif
        enddo
      endif

      end

!---Sorts an array arr(1:n) into ascending numerical order using the Quicksort
!   algorithm. n is inpu; arr is replace on output by its sorted rearrangement.
!   Parameters: M is the size of subarrays sorted by straight insertion
!   and NSTACK is the required auxiliary.
      SUBROUTINE sort(n,arr)
      INTEGER n,M,NSTACK
      REAL arr(n)
      PARAMETER (M=7,NSTACK=50)
      INTEGER i,ir,j,jstack,k,l,istack(NSTACK)
      REAL a,temp
      jstack=0
      l=1
      ir=n
1     if(ir-l.lt.M)then
        do 12 j=l+1,ir
          a=arr(j)
          do 11 i=j-1,1,-1
            if(arr(i).le.a)goto 2
            arr(i+1)=arr(i)
11        continue
          i=0
2         arr(i+1)=a
12      continue
        if(jstack.eq.0)return
        ir=istack(jstack)
        l=istack(jstack-1)
        jstack=jstack-2
      else
        k=(l+ir)/2
        temp=arr(k)
        arr(k)=arr(l+1)
        arr(l+1)=temp
        if(arr(l+1).gt.arr(ir))then
          temp=arr(l+1)
          arr(l+1)=arr(ir)
          arr(ir)=temp
        endif
        if(arr(l).gt.arr(ir))then
          temp=arr(l)
          arr(l)=arr(ir)
          arr(ir)=temp
        endif
        if(arr(l+1).gt.arr(l))then
          temp=arr(l+1)
          arr(l+1)=arr(l)
          arr(l)=temp
        endif
        i=l+1
        j=ir
        a=arr(l)
3       continue
          i=i+1
        if(arr(i).lt.a)goto 3
4       continue
          j=j-1
        if(arr(j).gt.a)goto 4
        if(j.lt.i)goto 5
        temp=arr(i)
        arr(i)=arr(j)
        arr(j)=temp
        goto 3
5       arr(l)=arr(j)
        arr(j)=a
        jstack=jstack+2
        if(jstack.gt.NSTACK)pause 'NSTACK too small in sort'
        if(ir-i+1.ge.j-l)then
          istack(jstack)=ir
          istack(jstack-1)=i
          ir=j-1
        else
          istack(jstack)=j-1
          istack(jstack-1)=l
          l=i
        endif
      endif
      goto 1
      END


      subroutine FD(oout)
      use COMM

      integer year, trno, kth, month 
      real oout(YRS,4)
! oout(,1)--FD, oout(,2)--SU, oout(,3)--ID, oout(,4)--TR      
      logical ismiss,nomiss

      trno=0
      oout=0
      do i=1,YRS
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year)==1) then
                  kth=MONLEAP(month)
          else
                  kth=MON(month)
          endif
          do day=1,kth
            trno=trno+1
            if(YMD(trno,3).ne.day) then
              print *, 'ERROR1 at FD!!!'
              stop
            endif
            if(nomiss(TMIN(trno)).and.TMIN(trno).lt.0) oout(i,1)=oout(i,1)+1
            if(nomiss(TMAX(trno)).and.TMAX(trno).gt.25) oout(i,2)=oout(i,2)+1
            if(nomiss(TMAX(trno)).and.TMAX(trno).lt.0) oout(i,3)=oout(i,3)+1
            if(nomiss(TMIN(trno)).and.TMIN(trno).gt.20) oout(i,4)=oout(i,4)+1
          enddo
        enddo
      enddo

      do i=1,YRS
        if(YNASTAT(i,2)==1) then
                oout(i,2)=MISSING  ! SU
                oout(i,3)=MISSING  ! ID
        endif
        if(YNASTAT(i,3)==1) then
                oout(i,1)=MISSING  ! FD
                oout(i,4)=MISSING  ! TR
        endif
      enddo

      end

      subroutine GSL(oout2)
      use COMM

      integer year,cnt,kth,month,day,marks,marke

      real TG,oout,strt(YRS),ee(YRS),oout2(YRS)
      logical ismiss,nomiss


      strt=MISSING
      ee=MISSING
      cnt=0
      do i=1,YRS
        year=i+SYEAR-1
        marks=0
        marke=0
        do month=1,6
          if(leapyear(year).eq.1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(YMD(cnt,1)*10000+YMD(cnt,2)*100+YMD(cnt,3).ne.year*10000+month*100+day) then
              print*, 'date count ERROR in GSL!'
              print*, YMD(cnt,1)*10000+YMD(cnt,2)*100+YMD(cnt,3),year*10000+month*100+day
              stop
            endif
            if(nomiss(TMAX(cnt)).and.nomiss(TMIN(cnt))) then
              TG=(TMAX(cnt)+TMIN(cnt))/2.
            else
              TG=MISSING
            endif
            if(LATITUDE.lt.0) then
              if(nomiss(TG).and.TG.lt.5.)then
                marke=marke+1
              else
                marke=0
              endif
              if(marke.ge.6.and.i.gt.1.and.ismiss(ee(i-1)))then
                ee(i-1)=cnt-5
              endif
            else
              if(nomiss(TG).and.TG.gt.5.)then
                marks=marks+1
              else
                marks=0
              endif
              if(marks.ge.6.and.ismiss(strt(i)))then
                strt(i)=cnt-5
              endif
            endif
          enddo
        enddo 
        if(LATITUDE.lt.0.and.i.gt.1) then
          if(ismiss(ee(i-1)).and.nomiss(strt(i-1))) then
            ee(i-1)=cnt
          endif
        endif
        marks=0
        marke=0
        do month=7,12
          do day=1,MON(month)
            cnt=cnt+1
            if(nomiss(TMAX(cnt)).and.nomiss(TMIN(cnt))) then
              TG=(TMAX(cnt)+TMIN(cnt))/2.
            else
              TG=MISSING
            endif
            if(LATITUDE.lt.0) then
              if(nomiss(TG).and.TG.gt.5.)then
                marks=marks+1
              else
                marks=0
              endif
              if(marks.ge.6.and.ismiss(strt(i)))then
                strt(i)=cnt-5
              endif
            else
              if(nomiss(TG).and.TG.lt.5.)then
                marke=marke+1
              else
                marke=0
              endif
              if(marke.ge.6.and.ismiss(ee(i)))then
                ee(i)=cnt-5
              endif
            endif
          enddo
        enddo
        if(ismiss(ee(i)).and.nomiss(strt(i))) then
          ee(i)=cnt
        endif
      enddo

      do i=1,YRS
        year=i+SYEAR-1
        if(nomiss(strt(i)).and.nomiss(ee(i)).and.YNASTAT(i,2).ne.1.and.YNASTAT(i,3).ne.1)then
          oout=ee(i)-strt(i)
        elseif(ismiss(strt(i)).or.ismiss(ee(i))) then
          oout=0.
        endif
        if(YNASTAT(i,2).eq.1.or.YNASTAT(i,3).eq.1) oout=MISSING
	   oout2(i)=oout
      enddo

      end

      subroutine TXX(oout,yout,dtr)
      use COMM
      character*80 ifile
      character*80 ofile
      character*3 chrtmp(4)

      integer year,month,day,kth,cnt,nn
      real oout(YRS,12,4),yout(YRS,4), dtr(YRS,13)
      logical ismiss,nomiss

      data chrtmp/"TXx","TXn","TNx","TNn"/

      oout=MISSING
      dtr=0.
      cnt=0
      do i=1,YRS
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year)==1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          nn=0
          do day=1,kth
            cnt=cnt+1
            if(nomiss(TMAX(cnt)).and.nomiss(TMIN(cnt))) then
              dtr(i,month)=dtr(i,month)+(TMAX(cnt)-TMIN(cnt))
              nn=nn+1
            endif
            if(nomiss(TMAX(cnt)).and.(ismiss(oout(i,month,1)).or.TMAX(cnt).gt.oout(i,month,1))) then
              oout(i,month,1)=TMAX(cnt) ! TXX
            endif
            if(nomiss(TMAX(cnt)).and.(ismiss(oout(i,month,2)).or.TMAX(cnt).lt.oout(i,month,2))) then
              oout(i,month,2)=TMAX(cnt) ! TXN
            endif
            if(nomiss(TMIN(cnt)).and.(ismiss(oout(i,month,3)).or.TMIN(cnt).gt.oout(i,month,3))) then
              oout(i,month,3)=TMIN(cnt) ! TNX
            endif
            if(nomiss(TMIN(cnt)).and.(ismiss(oout(i,month,4)).or.TMIN(cnt).lt.oout(i,month,4))) then
              oout(i,month,4)=TMIN(cnt) ! TNN
            endif
          enddo 
          if(nn.gt.0.and.MNASTAT(i,month,2).eq.0.and.MNASTAT(i,month,3).eq.0) then
            dtr(i,month)=dtr(i,month)/nn
          else
            dtr(i,month)=MISSING
          endif
          if(MNASTAT(i,month,2).eq.1)then
            oout(i,month,1)=MISSING
            oout(i,month,2)=MISSING
          endif
          if(MNASTAT(i,month,3).eq.1)then
            oout(i,month,3)=MISSING
            oout(i,month,4)=MISSING
          endif
        enddo
      enddo

      yout=MISSING
      do i=1,YRS
        nn=0
        do month=1,12
          if(nomiss(oout(i,month,1)).and.(ismiss(yout(i,1)).or.oout(i,month,1).gt.yout(i,1))) then
            yout(i,1)=oout(i,month,1)
          endif
          if(nomiss(oout(i,month,2)).and.(ismiss(yout(i,2)).or.oout(i,month,2).lt.yout(i,2))) then
            yout(i,2)=oout(i,month,2)
          endif
          if(nomiss(oout(i,month,3)).and.(ismiss(yout(i,3)).or.oout(i,month,3).gt.yout(i,3))) then
            yout(i,3)=oout(i,month,3)
          endif
          if(nomiss(oout(i,month,4)).and.(ismiss(yout(i,4)).or.oout(i,month,4).lt.yout(i,4))) then
            yout(i,4)=oout(i,month,4)
          endif
          if(nomiss(dtr(i,month))) then
            dtr(i,13)=dtr(i,13)+dtr(i,month)
            nn=nn+1
          endif
        enddo
        if(nn.gt.0.and.YNASTAT(i,2).eq.0.and.YNASTAT(i,3).eq.0) then
          dtr(i,13)=dtr(i,13)/nn
        else
          dtr(i,13)=MISSING
        endif
        if(YNASTAT(i,2).eq.1) then
          yout(i,1)=MISSING
          yout(i,2)=MISSING
        endif
        if(YNASTAT(i,3).eq.1) then
          yout(i,3)=MISSING
          yout(i,4)=MISSING
        endif
      enddo

      end

      subroutine Rnnmm(oout,sdii)
      use COMM
      character*80 ifile

      character*80 ofile
      character*5 chrtmp(3)
      integer year,month,day,kth,cnt,nn

      real oout(YRS,3),sdii(YRS)
      logical ismiss,nomiss

      data chrtmp/"R10mm","R20mm","Rnnmm"/
      cnt=0
      oout=0.
      sdii=0.
      do i=1,YRS
        nn=0
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(PRCP(cnt).ge.1.) then
              sdii(i)=sdii(i)+PRCP(cnt)
              nn=nn+1
            endif
            if(PRCP(cnt).ge.10.) oout(i,1)=oout(i,1)+1.
            if(PRCP(cnt).ge.20.) oout(i,2)=oout(i,2)+1.
            if(PRCP(cnt).ge.PRCPNN) oout(i,3)=oout(i,3)+1.
          enddo
        enddo
        if(nn.gt.0) then
          sdii(i)=sdii(i)/nn
        endif
      enddo

      do i=1,YRS
        if(YNASTAT(i,1).eq.1) then
          do k=1,3
            oout(i,k)=MISSING
          enddo
          sdii(i)=MISSING
        endif
      enddo

      end

      subroutine RX5day(r1,r5)
      use COMM
      character*80 ifile

      character*80 ofile

      integer year, month, day,cnt

      real r1(YRS,13), r5(YRS,13), r5prcp
      logical ismiss,nomiss

      cnt=0
      r1=MISSING
      r5=MISSING
      do i=1,YRS
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(cnt.gt.5)then
              r5prcp=0.
              do k=cnt-4,cnt
                if(nomiss(PRCP(k)))then
                  r5prcp=r5prcp+PRCP(k)
                endif
              enddo
            else
              r5prcp=MISSING
            endif
            if(nomiss(PRCP(cnt)).and.(ismiss(r1(i,month)).or.PRCP(cnt).gt.r1(i,month))) then
              r1(i,month)=PRCP(cnt)
            endif
            if(nomiss(PRCP(cnt)).and.r5prcp.gt.r5(i,month)) then
              r5(i,month)=r5prcp
            endif
          enddo
          if(MNASTAT(i,month,1).eq.1) then
            r1(i,month)=MISSING
            r5(i,month)=MISSING
          endif
          if(nomiss(r1(i,month)).and.(ismiss(r1(i,13)).or.r1(i,month).gt.r1(i,13))) then
            r1(i,13)=r1(i,month)
          endif
          if(nomiss(r5(i,month)).and.(ismiss(r5(i,13)).or.r5(i,month).gt.r5(i,13))) then
            r5(i,13)=r5(i,month)
          endif
        enddo
        if(YNASTAT(i,1).eq.1) then
          r1(i,13)=MISSING
          r5(i,13)=MISSING
        endif
      enddo

      end

      subroutine CDD(ocdd,ocwd)
      use COMM
      character*80 ifile

      character*80 ofile

      integer year, month, day, kth, cnt

      real ocdd(YRS), ocwd(YRS), nncdd, nncwd
      logical ismiss,nomiss

      cnt=0
      ocdd=0.
      ocwd=0.
      do i=1,YRS
        if(i==1)nncdd=0.
        if(i==1)nncwd=0.
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(ismiss(PRCP(cnt))) then
              nncdd=0.
              nncwd=0.
            elseif(PRCP(cnt).lt.1) then
              nncdd=nncdd+1.
              if(nncwd.gt.ocwd(i)) ocwd(i)=nncwd
              nncwd=0.
            else
              nncwd=nncwd+1.
              if(nncdd.gt.ocdd(i)) ocdd(i)=nncdd
              nncdd=0.
            endif
          enddo
        enddo

        if(ocwd(i).lt.nncwd) then
          if(year.eq.EYEAR) then
                  ocwd(i)=nncwd
          elseif(PRCP(cnt+1).lt.1..or.ismiss(PRCP(cnt+1)))then
                  ocwd(i)=nncwd
          endif
        endif

        if(ocdd(i).lt.nncdd) then
          if(year.eq.EYEAR) then
                  ocdd(i)=nncdd
          elseif(PRCP(cnt+1).ge.1..or.ismiss(PRCP(cnt+1)))then
                  ocdd(i)=nncdd
          endif
          if(ocdd(i).eq.0) ocdd(i)=MISSING
        endif

        if(YNASTAT(i,1).eq.1) then
          ocdd(i)=MISSING
          ocwd(i)=MISSING
        endif
      enddo

      end

      subroutine R95p(r95out,r99out,prcpout)
      use COMM
      character*80 ifile
      character*80 ofile
      integer year, month, day, kth,cnt,leng

      real r95out(YRS), prcptmp(TOT),r99out(YRS), prcpout(YRS), p95, p99,rlev(2),rtmp(2)
      logical ismiss,nomiss

      cnt=0
      leng=0
      prcptmp=MISSING
      do i=1,YRS
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1)then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(year.ge.BASESYEAR.and.year.le.BASEEYEAR.and.nomiss(PRCP(cnt)).and.PRCP(cnt).ge.1.)then
              leng=leng+1
              prcptmp(leng)=PRCP(cnt)
            endif
          enddo
        enddo
      enddo
      rlev(1)=0.95
      rlev(2)=0.99
      call percentile(prcptmp,leng,2,rlev,rtmp)
      p95=rtmp(1)
      p99=rtmp(2)

      cnt=0
      r95out=0.
      r99out=0.
      prcpout=0.
      do i=1,YRS
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1)then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(PRCP(cnt).ge.1..and.nomiss(PRCP(cnt)))then
              prcpout(i)=prcpout(i)+PRCP(cnt)
              if(PRCP(cnt).gt.p95) r95out(i)=r95out(i)+PRCP(cnt)
              if(PRCP(cnt).gt.p99) r99out(i)=r99out(i)+PRCP(cnt)
            endif
          enddo
        enddo
        if(YNASTAT(i,1).eq.1) then
          prcpout(i)=MISSING
          r95out(i)=MISSING
          r99out(i)=MISSING
        endif
      enddo

      end

      subroutine TX10p(tx10out,tx90out,tn10out,tn90out,wsdi,csdi)
      use COMM
      character*80 ifile
      character*80 ofile

      integer year, month, day, kth, cnt, nn,  missxcnt, missncnt,iter, cntx, cntn,byear,flgtn,flgtx,flg,idum

      real tmaxbase(TOT),tminbase(TOT),txdata(BYRS,365+2*SS),tndata(BYRS,365+2*SS),thresan10(365),txdtmp(BYRS,365),tndtmp(BYRS,365),tnboot(BYRS,365+2*SS),txboot(BYRS,365+2*SS),thresan90(365),thresax10(365),thresax90(365),tx10out(YRS,13),tx90out(YRS,13),thresax50(365),thresan50(365),tx50out(YRS,13),tn50out(YRS,13),thresbx50(365,BYRS,BYRS-1),thresbn50(365,BYRS,BYRS-1),threstmp(365,3),rlevs(3),tn10out(YRS,13),tn90out(YRS,13),thresbn90(365,BYRS,BYRS-1),thresbn10(365,BYRS,BYRS-1),thresbx90(365,BYRS,BYRS-1),thresbx10(365,BYRS,BYRS-1),wsdi(YRS),csdi(YRS)
      logical ismiss,nomiss

      data rlevs/0.1,0.5,0.9/

      cnt=0
      nn=0
      txdtmp=MISSING
      tndtmp=MISSING
      do i=1,YRS
        year=i+SYEAR-1
        nn=0
        do month=1,12
          if(leapyear(year).eq.1) then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            cnt=cnt+1
            if(year.ge.BASESYEAR.and.year.le.BASEEYEAR.and.(month.ne.2.or.day.ne.29))then
              nn=nn+1
              txdtmp(i+SYEAR-BASESYEAR,nn)=TMAX(cnt)
              tndtmp(i+SYEAR-BASESYEAR,nn)=TMIN(cnt)
            endif
          enddo
        enddo
        if(year.ge.BASESYEAR.and.year.le.BASEEYEAR.and.nn.ne.365)then
          print *,"date count error in TX10p!", nn
          stop
        endif
      enddo
      
      do i=1,BYRS
        do j=1,SS
          if(i.eq.1) then
            tndata(i,j)=tndtmp(i,1)
            txdata(i,j)=txdtmp(i,1)
          else 
            tndata(i,j)=tndtmp(i-1,365+j-SS)
            txdata(i,j)=txdtmp(i-1,365+j-SS)
          endif
        enddo
        do j=1,365
          tndata(i,j+SS)=tndtmp(i,j)
          txdata(i,j+SS)=txdtmp(i,j)
        enddo
        do j=1,SS
          if(i.eq.BYRS)then
            tndata(i,j+365+SS)=tndtmp(i,365)
            txdata(i,j+365+SS)=txdtmp(i,365)
          else
            tndata(i,j+365+SS)=tndtmp(i+1,j)
            txdata(i,j+365+SS)=txdtmp(i+1,j)
          endif
        enddo
      enddo


      flgtn=0
      flgtx=0
      call threshold(tndata,rlevs,3,threstmp,flgtn)

!	print *,'threshold for tmin calculated'

      do i=1,365
        thresan10(i)=threstmp(i,1)-1e-5
        thresan50(i)=threstmp(i,2)+1e-5
        thresan90(i)=threstmp(i,3)+1e-5
      enddo
      if(flgtn.eq.1) then
        write(6,*) "TMIN Missing value overflow in exceedance rate"
        tn10out=MISSING
        tn50out=MISSING
        tn90out=MISSING
      endif

      call threshold(txdata,rlevs,3,threstmp,flgtx)
!	print *,'threshold for tmax calculated'

      do i=1,365
        thresax10(i)=threstmp(i,1)-1e-5
        thresax50(i)=threstmp(i,2)+1e-5
        thresax90(i)=threstmp(i,3)+1e-5
      enddo
      if(flgtx.eq.1) then
        write(6,*) "TMAX Missing value overflow in exceedance rate"
        tx10out=MISSING
        tx50out=MISSING
        tx90out=MISSING
      endif

      do ib=1,BYRS
!	print *,'i=',ib
        txboot=txdata
        tnboot=tndata
        nn=0
        do iter=1,BYRS
          if(iter.ne.ib) then
            nn=nn+1
            do day=1,365+2*SS
              if(flgtx.eq.0) txboot(ib,day)=txboot(iter,day)
              if(flgtn.eq.0) tnboot(ib,day)=tnboot(iter,day)
            enddo
            if(flgtx.eq.0)then
              call threshold(txboot,rlevs,3,threstmp,flg)
              do day=1,365
                thresbx90(day,ib,nn)=threstmp(day,3)+1e-5
                thresbx50(day,ib,nn)=threstmp(day,2)+1e-5
                thresbx10(day,ib,nn)=threstmp(day,1)-1e-5
              enddo
            endif

            if(flgtn.eq.0) then
              call threshold(tnboot,rlevs,3,threstmp,flg)
              do day=1,365
                thresbn90(day,ib,nn)=threstmp(day,3)+1e-5
                thresbn50(day,ib,nn)=threstmp(day,2)+1e-5
                thresbn10(day,ib,nn)=threstmp(day,1)-1e-5
              enddo
            endif
          endif
        enddo
      enddo

!	print *,'boot finished'

      if(flgtx.eq.0)then
        tx10out=0.
        tx50out=0.
        tx90out=0.
      endif
      if(flgtn.eq.0)then
        tn10out=0.
        tn50out=0.
        tn90out=0.
      endif
      cnt=0
      do i=1,YRS
        year=i+SYEAR-1
        byear=year-BASESYEAR+1
        nn=0
        do month=1,12
          missncnt=0
          missxcnt=0
          if(leapyear(year).eq.1)then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            if(month.ne.2.or.day.ne.29) nn=nn+1
            cnt=cnt+1
            if(nomiss(TMAX(cnt)))then
              if(year.lt.BASESYEAR.or.year.gt.BASEEYEAR) then
                if(TMAX(cnt).gt.thresax90(nn)) tx90out(i,month)=tx90out(i,month)+1
                if(TMAX(cnt).gt.thresax50(nn)) tx50out(i,month)=tx50out(i,month)+1
                if(TMAX(cnt).lt.thresax10(nn)) tx10out(i,month)=tx10out(i,month)+1
              else
                do iter=1,BYRS-1
                  if(TMAX(cnt).gt.thresbx90(nn,byear,iter))then
                    tx90out(i,month)=tx90out(i,month)+1
                  endif
                  if(TMAX(cnt).gt.thresbx50(nn,byear,iter))then
                    tx50out(i,month)=tx50out(i,month)+1
                  endif
                  if(TMAX(cnt).lt.thresbx10(nn,byear,iter)) tx10out(i,month)=tx10out(i,month)+1
                enddo
              endif
            else
              missxcnt=missxcnt+1
            endif
            if(nomiss(TMIN(cnt)))then
              if(year.lt.BASESYEAR.or.year.gt.BASEEYEAR) then
                if(TMIN(cnt).gt.thresan90(nn)) tn90out(i,month)=tn90out(i,month)+1
                if(TMIN(cnt).gt.thresan50(nn)) tn50out(i,month)=tn50out(i,month)+1
                if(TMIN(cnt).lt.thresan10(nn)) tn10out(i,month)=tn10out(i,month)+1
              else
                do iter=1,BYRS-1
                  if(TMIN(cnt).gt.thresbn90(nn,byear,iter)) tn90out(i,month)=tn90out(i,month)+1
                  if(TMIN(cnt).gt.thresbn50(nn,byear,iter)) tn50out(i,month)=tn50out(i,month)+1
                  if(TMIN(cnt).lt.thresbn10(nn,byear,iter)) tn10out(i,month)=tn10out(i,month)+1
                enddo
              endif
            else
              missncnt=missncnt+1
            endif
          enddo ! do day=1,kth


          if(year.ge.BASESYEAR.and.year.le.BASEEYEAR)then
            tn90out(i,month)=tn90out(i,month)/(BYRS-1.)
            tn50out(i,month)=tn50out(i,month)/(BYRS-1.)
            tn10out(i,month)=tn10out(i,month)/(BYRS-1.)
            tx90out(i,month)=tx90out(i,month)/(BYRS-1.)
            tx50out(i,month)=tx50out(i,month)/(BYRS-1.)
            tx10out(i,month)=tx10out(i,month)/(BYRS-1.)
          endif


          if(missxcnt.le.10.and.flgtx.eq.0)then
            tx90out(i,13)=tx90out(i,13)+tx90out(i,month)
            tx90out(i,month)=tx90out(i,month)*100./(kth-missxcnt)
            tx50out(i,13)=tx50out(i,13)+tx50out(i,month)
            tx50out(i,month)=tx50out(i,month)*100./(kth-missxcnt)
            tx10out(i,13)=tx10out(i,13)+tx10out(i,month)
            tx10out(i,month)=tx10out(i,month)*100./(kth-missxcnt)
          else
            tx90out(i,month)=MISSING
            tx50out(i,month)=MISSING
            tx10out(i,month)=MISSING
          endif
          if(missncnt.le.10.and.flgtn.eq.0)then
            tn90out(i,13)=tn90out(i,13)+tn90out(i,month)
            tn90out(i,month)=tn90out(i,month)*100./(kth-missncnt)
            tn50out(i,13)=tn50out(i,13)+tn50out(i,month)
            tn50out(i,month)=tn50out(i,month)*100./(kth-missncnt)
            tn10out(i,13)=tn10out(i,13)+tn10out(i,month)
            tn10out(i,month)=tn10out(i,month)*100./(kth-missncnt)
          else
            tn90out(i,month)=MISSING
            tn50out(i,month)=MISSING
            tn10out(i,month)=MISSING
          endif
        enddo ! do month=1,12
        if(YNASTAT(i,3).eq.1.or.flgtn.eq.1) then
          tn10out(i,13)=MISSING
          tn50out(i,13)=MISSING
          tn90out(i,13)=MISSING
        else
          tn10out(i,13)=tn10out(i,13)*100/365.
          tn50out(i,13)=tn50out(i,13)*100/365.
          tn90out(i,13)=tn90out(i,13)*100/365.
        endif
        if(YNASTAT(i,2).eq.1.or.flgtx.eq.1) then
          tx10out(i,13)=MISSING
          tx50out(i,13)=MISSING
          tx90out(i,13)=MISSING
        else
          tx10out(i,13)=tx10out(i,13)*100/365.
          tx50out(i,13)=tx50out(i,13)*100/365.
          tx90out(i,13)=tx90out(i,13)*100/365.
        endif
      enddo


      cnt=0
      wsdi=0.
      csdi=0.

      do i=1,YRS
        cntx=0
        cntn=0
        nn=0
        year=i+SYEAR-1
        do month=1,12
          if(leapyear(year).eq.1)then
            kth=MONLEAP(month)
          else
            kth=MON(month)
          endif
          do day=1,kth
            if(month.ne.2.or.day.ne.29) nn=nn+1
            cnt=cnt+1
            if(TMAX(cnt).gt.thresax90(nn).and.nomiss(TMAX(cnt))) then
              cntx=cntx+1
              if(month.eq.12.and.day.eq.31.and.cntx.ge.6) wsdi(i)=wsdi(i)+cntx
            elseif(cntx.ge.6)then
              wsdi(i)=wsdi(i)+cntx
              cntx=0
            else
              cntx=0
            endif
            if(TMIN(cnt).lt.thresan10(nn).and.nomiss(TMIN(cnt))) then
              cntn=cntn+1
              if(month.eq.12.and.day.eq.31.and.cntn.ge.6) csdi(i)=csdi(i)+cntn
            elseif(cntn.ge.6)then
              csdi(i)=csdi(i)+cntn
              cntn=0
            else
              cntn=0
            endif
          enddo  ! day
        enddo    ! month
        if(YNASTAT(i,3).eq.1) csdi(i)=MISSING
        if(YNASTAT(i,2).eq.1) wsdi(i)=MISSING
      enddo      ! year

      end

      subroutine threshold(idata, lev, nl, odata, flg)
      use COMM
      integer flg,nl
      real idata(BYRS,365+2*SS),odata(365,nl), lev(nl)

      real tosort(BYRS*WINSIZE),rtmp(nl)
      integer nn
      logical ismiss,nomiss

      do ii=1,365
!	print *,'i=',ii
        nn=0
        do j=1,BYRS
          do k=ii,ii+2*SS
            if(nomiss(idata(j,k))) then
              nn=nn+1
              tosort(nn)=idata(j,k)
            endif
          enddo
        enddo
        if(nn.lt.int(BYRS*WINSIZE*.85)) then
!	print*,"##1##",nn
          flg=1
          return
        endif
        call percentile(tosort,nn,nl,lev,rtmp)
!	print *,'nl=',nl
        do j=1,nl
          odata(ii,j)=rtmp(j)
        enddo
      enddo

      end

      logical function ismiss(a)
      use COMM
      real a, rmiss
      rmiss=MISSING+1.
      if(a.gt.rmiss) then
        ismiss=.FALSE.
      else
        ismiss=.TRUE.
      endif
      end

      logical function nomiss(a)
      use COMM
      real a, rmiss
      rmiss=MISSING+1.
      if(a.lt.rmiss) then
        nomiss=.FALSE.
      else
        nomiss=.TRUE.
      endif
      end

      FUNCTION ran2(idum)
      INTEGER idum,IM1,IM2,IMM1,IA1,IA2,IQ1,IQ2,IR1,IR2,NTAB,NDIV
      REAL ran2,AM,EPS,RNMX
      PARAMETER (IM1=2147483563,IM2=2147483399,AM=1./IM1,IMM1=IM1-1,IA1=40014,IA2=40692,IQ1=53668,IQ2=52774,IR1=12211,IR2=3791,NTAB=32,NDIV=1+IMM1/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER idum2,j,k,iv(NTAB),iy
      SAVE iv,iy,idum2
      DATA idum2/123456789/, iv/NTAB*0/, iy/0/
      if (idum.le.0) then
        idum=max(-idum,1)
        idum2=idum
        do 11 j=NTAB+8,1,-1
          k=idum/IQ1
          idum=IA1*(idum-k*IQ1)-k*IR1
          if (idum.lt.0) idum=idum+IM1
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ1
      idum=IA1*(idum-k*IQ1)-k*IR1
      if (idum.lt.0) idum=idum+IM1
      k=idum2/IQ2
      idum2=IA2*(idum2-k*IQ2)-k*IR2
      if (idum2.lt.0) idum2=idum2+IM2
      j=1+iy/NDIV
      iy=iv(j)-idum2
      iv(j)=idum
      if(iy.lt.1)iy=iy+IMM1
      ran2=min(AM*iy,RNMX)
      return
      END
