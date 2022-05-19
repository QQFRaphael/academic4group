       module FileManager
	 
	 use GlbVars
	 
	 implicit none
	 
	 contains

!**************Opens the files to read in data and also the output files.**************
      subroutine openfiles()

      implicit none
	
      character(len=2), dimension(50) :: uchar
      
      data uchar/'01','02','03','04','05','06','07','08','09','10', &
                 '11','12','13','14','15','16','17','18','19','20', &
                 '21','22','23','24','25','26','27','28','29','30', &
                 '31','32','33','34','35','36','37','38','39','40', &
                 '41','42','43','44','45','46','47','48','49','50'/
	
      open(11,file='zp.'//trim(datafile)//'.dat',form='binary',status='old')
      open(12,file='hgtmean_'//trim(datafile)//'.dat',form='binary',status='old') 
      !open(11,file=  'zp.'//trim(datafile)//'.dat',form = 'unformatted')
      !open(12,file= 'z.djf.1958to1997.dat',form='unformatted')
!      open(11,file= 'up_vp.'//trim(datafile)//'.dat',form='unformatted')
!      open(12,file= 'up_vp.djf.1958to1997.dat',form='unformatted')
	
      open(21,file=  'zp.'//trim(datafile)//'.'//uchar(qlevs(1))//'-'// &
             uchar(qlevs(qz))//'.dat',form='unformatted')
      open(22,file= 'ugp.'//trim(datafile)//'.'//uchar(qlevs(1))//'-'// &
             uchar(qlevs(qz))//'.dat',form='unformatted')
      open(23,file= 'vgp.'//trim(datafile)//'.'//uchar(qlevs(1))//'-'// &
             uchar(qlevs(qz))//'.dat',form='unformatted')
      open(24,file= 'qgp.'//trim(datafile)//'.'//uchar(qlevs(1))//'-'// &
             uchar(qlevs(qz))//'.dat',form='unformatted')	     
           
	
      end subroutine openfiles
!*************************************************************************************

!****************Read in the anomaly/actual data fields********************************
      subroutine rddata()

      implicit none
	
      integer :: lonp,latp,k
      real,dimension(x,y,z) :: zall
	
      do k = 1,z
	 read(11) zall(:,:,k)
      enddo
	
      !read(11) zall
	
      call findindex(lonp,lon,ilonbounds(1))
      call findindex(latp,lat,ilatbounds(1))
	
      if(lat(2) < lat(1)) then !Latitude points go from north to south
         h(:,:,:) = zall(lonp:lonp+ix-1,latp-iy+1:latp,ilevs(1):ilevs(iz))	
      else
	 h(:,:,:) = zall(lonp:lonp+ix-1,latp:latp+iy-1,ilevs(1):ilevs(iz))
      endif
      
      !print *, h(:,10,21)
      !stop	
      end subroutine rddata
!*************************************************************************************	

!****************Read in the climo data field*****************************************
      subroutine rdmean()
	
	implicit none

	integer :: lonp,latp,k
	real,dimension(x,y,z) :: zallm
      
	do k = 1,z
	   read(12) zallm(:,:,k)
	enddo
	
	!read(12) zallm
	
      call findindex(lonp,lon,ilonbounds(1))
      call findindex(latp,lat,ilatbounds(1))
	
	if(lat(2)<lat(1)) then !Latitude points go from north to south
	   hmean(:,:,:) = zallm(lonp:lonp+ix-1,latp-iy+1:latp,ilevs(1):ilevs(iz))	
	else
	   hmean(:,:,:) = zallm(lonp:lonp+ix-1,latp:latp+iy-1,ilevs(1):ilevs(iz))
	endif
	
	end subroutine rdmean
!*************************************************************************************

!*************Write to the output files***********************************************
      subroutine output(var,filenum)

      implicit none
	
      integer :: filenum,lonp,latp
      real, dimension(ix,iy,iz) :: var
	real, dimension(x,y,z) :: var0
	
	var0(:,:,:) = -999.0
	
      call findindex(lonp,lon,ilonbounds(1))
      call findindex(latp,lat,ilatbounds(1))
	
	if(lat(2) < lat(1)) then !Latitude points go from north to south
	   var0(lonp:lonp+ix-1,latp-iy+1:latp,ilevs(1):ilevs(iz)) = var(:,:,:)
	else
	   var0(lonp:lonp+ix-1,latp:latp+iy-1,ilevs(1):ilevs(iz)) = var(:,:,:)
	endif
	
	write(filenum) var0
	
	end subroutine output
!***************************************************************************************

!****************Close all the open files***********************************************
      subroutine closefiles()
	
	implicit none
	
	close(10)
	close(11)
	close(12)
	close(21)
	close(22)
	close(23)
	close(24)
	
	end subroutine closefiles
!***************************************************************************************

      end module FileManager
