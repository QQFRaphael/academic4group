     module GlbVars
	
	implicit none
	
	real, parameter :: gg = 9.81,ff = 1.e-4
	integer :: x,y,z,ix,iy,iz,qx,qy,qz,day,narr,maxm,zpts,iflag
	integer, dimension(:), allocatable :: ilevs
	integer, dimension(:), allocatable :: qlevs
	
	real, dimension(2) :: ilatbounds,ilonbounds,qlatbounds,qlonbounds
	real, dimension(:,:,:), allocatable :: rh,rhmean,rhp,h,hmean,hp,u,v,ugp,vgp,uagp,vagp,qgp,tht	
!	real, dimension(:,:,:), allocatable :: umean,vmean,umeang,vmeang,umeanag,vmeanag
        real, dimension(:,:,:), allocatable :: c
	real, dimension(:), allocatable :: f,fp,fm,ap,apm,app
	real, dimension(:), allocatable :: xpi,p25,p25a,bh,bb,bl,hbb,hh,statstab
	real, dimension(:,:), allocatable :: a
	character(len=100) :: coordfile, datafile
	real :: ll,dy,fr,dlon,dlat,dpi,tho,rearth,pi
	real,dimension(:),allocatable :: lon,lat,plev,loni,lati
	
	logical :: Periodic
	contains

!**********************Initialize the Global Variables*************************	
	subroutine GlbVarInit()
	
	implicit none
	
	integer :: lonp1,latp1,lonp2,latp2
	
	call datadims()
        call entryparams()
	
	dlon = abs(lon(2)-lon(1))
	dlat = abs(lat(2)-lat(1))
	
	call findindex(lonp1,lon,ilonbounds(1))
	call findindex(latp1,lat,ilatbounds(1))
	call findindex(lonp2,lon,ilonbounds(2))
	call findindex(latp2,lat,ilatbounds(2))

        ix = abs(lonp2-lonp1) + 1
	iy = abs(latp2-latp1) + 1
	
	allocate(loni(ix),lati(iy))
	
	loni = lon(lonp1:lonp2)
	lati = lat(latp1:latp2)
	
	qx = abs(qlonbounds(2)-qlonbounds(1))/dlon + 1
	qy = abs(qlatbounds(2)-qlatbounds(1))/dlat + 1
	
	zpts = ix*iy
	
	if(ix == x) then
	   Periodic = .true.
	else
	   Periodic = .false.
	endif
	
	allocate(rh(ix,iy,iz),hp(ix,iy,iz),rhmean(ix,iy,iz),hmean(ix,iy,iz),u(ix,iy,iz), &
	      v(ix,iy,iz),ugp(ix,iy,iz),vgp(ix,iy,iz),uagp(ix,iy,iz),vagp(ix,iy,iz), &
	       rhp(ix,iy,iz),qgp(ix,iy,iz),h(ix,iy,iz),tht(ix,iy,iz))
	allocate(c(iy,iz,7))
	
!	allocate(umean(ix,iy,iz),vmean(ix,iy,iz),umeang(ix,iy,iz), &
!	        vmeang(ix,iy,iz),umeanag(ix,iy,iz),vmeanag(ix,iy,iz))
	
	allocate(f(iy),fp(iy),fm(iy),ap(iy),apm(iy),app(iy))
	allocate(a(iy,5))
	allocate(xpi(iz),p25(iz),p25a(iz),bh(iz),bb(iz),bl(iz),hbb(iz),hh(iz),statstab(iz))
	
	call InitValues() 
	
	end subroutine GlbVarInit
!********************************************************************************

!*************Get the x,y, and z coordinates for the dataset*********************
      subroutine datadims()
	
	implicit none
	
	print *, 'Please enter the filename with the dimensions for the dataset you are using: '
	read *, coordfile
	print *, ''
	
	open(10, file = trim(coordfile), status  = 'old', form = 'formatted')
	
	read(10,*) x,y,z
	
	allocate(lon(x),lat(y),plev(z))
	
	read(10,*) lon,lat,plev
	
	end subroutine datadims
!*********************************************************************************

!***********Get the horizontal and vertical boundaries for the inversion**********
      subroutine entryparams()
	
      implicit none
	
	integer :: i,m,mstart,mend
	real :: pstart,pend
	logical :: pchoice = .false.
	
	print *, 'Enter the generic datafile name for input/output: '
      read *, datafile
      print *, ''	

      print *, 'How many arrays will you be analyzing (1 or more)? '
      read *, narr
	print *, ''
	
	print *, '*********************************************************'
	print *, 'Now define the horizontal and vertical dimensions of the area' 
	print *, 'over which the inversion will take place.'
	print *, '*********************************************************'
	print *, ''
	
	do while(.not.pchoice)
         print *, 'Enter the lowest and highest vertical pressure levels over which you will be'
	   print *, 'inverting, separated by a space (in hPa)? '
	   read *, pstart, pend
	   print *, ''
	   
	   if(pend > pstart) then
	      print *, 'Invalid pressure entry.  The lower level must be a higher value than the higher level.'
         else
	      pchoice = .true.
         endif
	enddo
	
	call findindex(mstart,plev,pstart)
	call findindex(mend,plev,pend)
	
	iz = mend - mstart + 1
	
	allocate(ilevs(iz))
	
	ilevs(1) = mstart
	if (iz > 1) then
	  do i = 2,iz
	     ilevs(i) = ilevs(i-1) + 1
	  enddo
      endif
	
      print *, 'Enter the longitude bounds (i.e., the lon of the western most point and'
	print *, 'then the eastern most point), separated by a space: '
	read *, ilonbounds(1),ilonbounds(2)
      print *, ''
! Error check - make sure the longitude values are actually values in the dimensions read in.
      call findindex(m,lon,ilonbounds(1))
	call findindex(m,lon,ilonbounds(2))

      print *, 'Enter the latitude bounds (i.e., the lat of the southernmost point and'
	print *, 'then the northernmost point), separated by a space: '
	read *, ilatbounds(1),ilatbounds(2)
	print *, ''
	
! Error check - make sure the latitude values are actually values in the dimensions read in.
      call findindex(m,lat,ilatbounds(1))
	call findindex(m,lat,ilatbounds(2))
	
	print *, '*********************************************************'
	print *, 'Now we will define the areas of PV we are interested in for' 
	print *, 'use in the inversion routine.'
	print *, '*********************************************************'
	print *, ''
	
	pchoice = .false.
	do while(.not.pchoice)
         print *, 'Enter the lowest and highest vertical pressure levels containing the PV area of' 
	   print *, 'interest, separated by a space (in hPa)? '
	   read *, pstart, pend
	   print *, ''
	   
	   if(pend > pstart) then
	      print *, 'Invalid pressure entry.  The lower level must be a higher value than the higher level.'
         else
	      pchoice = .true.
         endif
	enddo
	
	call findindex(mstart,plev,pstart)
	call findindex(mend,plev,pend)
	
	qz = mend - mstart + 1
	
	allocate(qlevs(qz))
	
      qlevs(1) = mstart
      if(qz > 1) then
         do i = 2,qz
	      qlevs(i) = qlevs(i-1) + 1
         enddo
	endif
	
      print *, 'Enter the longitude bounds of the PV area of interest, separated by a space: '
	read *, qlonbounds(1), qlonbounds(2)
	print *, ''
	
	! Error check - make sure the longitude values are actually values in the dimensions read in.
      call findindex(m,lon,qlonbounds(1))
	call findindex(m,lon,qlonbounds(2))
	
      print *, 'Enter the latitude bounds of the PV area of interest, separated by a space: '
	read *, qlatbounds(1), qlatbounds(2)
	print *, ''
	
	! Error check - make sure the latitude values are actually values in the dimensions read in.
      call findindex(m,lat,qlatbounds(1))
	call findindex(m,lat,qlatbounds(2))	
	
      end subroutine entryparams
!********************************************************************************

!********Initializes the coefficients and paramaters necessary in the solver and
!********inversion calculation functions.****************************************
      subroutine InitValues()
	
	implicit none
	integer:: j,k
	real, parameter :: cp = 1004., p0 = 1000.
	real :: sig
	
	dpi = 50.
	tho = 0.1*dpi
	pi = acos(-1.0)
	rearth = 2.e7/pi
	ll = rearth*dlon*pi/180.
	sig = dlon/dlat
	fr = dpi*tho/(ff*ff*ll*ll)
	
!******* compute functions of latitude and coeffs of delsqrd operator *** 
	do j = 2,iy
	   ap(j) = cos( pi*(ilatbounds(1)+(j-1)*dlat)/180. )	
	   apm(j) = cos( pi*(ilatbounds(1)+(j-1.5)*dlat)/180. )	
	   app(j) = cos( pi*(ilatbounds(1)+(j-0.5)*dlat)/180. )	
	   f(j) = 1.458*sin(pi*(ilatbounds(1)+(j-1)*dlat)/180. )
	   fm(j) = 1.458*sin(pi*(ilatbounds(1)+(j-1.5)*dlat)/180. )
	   fp(j) = 1.458*sin(pi*(ilatbounds(1)+(j-0.5)*dlat)/180. )
	   
	   if(f(j)==0) then
	      f(j) = 0.00001
	   endif
	   
	   if(fm(j)==0) then
	      fm(j) = 0.00001
	   endif
	   
	   if(fp(j)==0) then
	      fp(j) = 0.00001
         endif
	      
	   a(j,1) = sig*sig*apm(j)/fm(j)/ap(j)
	   a(j,2) = 1./ap(j)/ap(j)/f(j)
	   a(j,4) = a(j,2)
	   a(j,5) = sig*sig*app(j)/fp(j)/ap(j)	   
	   a(j,3) = -(a(j,1)+a(j,2)+a(j,4)+a(j,5))
	enddo
	
	xpi(:) = cp*((plev(ilevs(1):ilevs(iz))/p0)**(2./7.))/dpi
	p25(:) = xpi(:)**2.5

	do k = 2,iz-1
	   p25a(k) = 0.5*( p25(k-1) + p25(k) )
	   bh(k) = 2./(xpi(k+1)-xpi(k-1))/(xpi(k+1)-xpi(k))
	   bb(k) = -2./(xpi(k)-xpi(k-1))/(xpi(k+1)-xpi(k))
	   bl(k) = 2./(xpi(k+1)-xpi(k-1))/(xpi(k)-xpi(k-1))
	enddo
	
	p25a(iz) = 0.5*( p25(iz-1) + p25(iz) )
	
      end subroutine InitValues
!**********************************************************************************	

!************Calculates the static stability parameter******************************	  
	  subroutine calcstatstab()
	 
	  implicit none
	  integer :: i,j,k
	 
	  do k = 1,iz
	     hbb(k) = sum(hmean(:,:,k))/zpts
	     hh(k) = hbb(k)
	     hbb(k) = gg*hbb(k)/(dpi*tho)
	  enddo
	
	  do k = 2,iz-1
	     statstab(k) = bl(k)*hbb(k-1) + bb(k)*hbb(k) + bh(k)*hbb(k+1)
	  enddo
	
	  statstab(1) = statstab(2)
	  statstab(iz) = 2.*statstab(iz-1) - statstab(iz-2)
	
	  do k = 2,iz
	     statstab(k) = 0.5*(statstab(k)+statstab(k-1))
	  enddo

	  end subroutine calcstatstab
!************************************************************************************

!************Release the allocated variables***************************************
       subroutine GlbVarRelease()
	 
	 implicit none
	
	 deallocate(rh,hp,rhmean,hmean,u,v,ugp,vgp,uagp,vagp,rhp,qgp,h,tht,c, &
	      f,fp,fm,ap,apm,app,a,xpi,p25,p25a,bh,bb,bl,hbb,hh,statstab,lon, &
		lat,plev,ilevs,qlevs)
!	  deallocate(umean,vmean,umeang,vmeang,umeanag,vmeanag)
	
	 end subroutine GlbVarRelease
!***********************************************************************************

!*********Auxiliary subroutine to find the starting points for lon and lat indices.*******
      subroutine findindex(startindex,coord,startpoint)
	
	implicit none
	
	integer :: m,icon,startindex
	real :: startpoint
	real, dimension(:) :: coord
	
	m = 1
	icon = 1
	do while(icon == 1)
	   if(coord(m) == startpoint) then
	      startindex = m
	      icon = 0
	   elseif(startpoint < minval(coord,1)) then
	      startindex = 1
	      icon =  0
	   elseif(startpoint > maxval(coord,1)) then
	      startindex = size(coord,1)
	      icon = 0
	   elseif((startpoint > coord(m)).and.(startpoint < coord(m+1))) then
              startindex = m
              icon = 0 
	   else
	      m = m + 1
           endif
	   
	   if(m > size(coord,1)) then
	      print *, 'Entered value is outside the domain of the dataset.'
              stop
	   endif
	enddo
	
	end subroutine findindex
!*****************************************************************************************

       end module GlbVars
