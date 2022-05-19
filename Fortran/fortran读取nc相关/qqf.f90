program main
implicit none
integer :: version=5                                                        ! Format version (must =5 for WPS format)
integer :: nx=128, ny=64, nt=1460, nz=26,nvar=5                             ! x- and y-dimensions of 2-d array
integer :: iproj=4                                                          ! Code for projection of data in array:
                                                                            ! 4 = Gaussian (global only!)
real :: nlats=32                                                            ! Number of latitudes north of equator
                                                                            ! (for Gaussian grids)
real :: xfcst=0                                                             ! Forecast hour of data
real :: xlvl=26                                                             ! Vertical level      
real :: startlat=-87.8638, startlon=0                             ! Lat/lon of point in array indicated by
real :: deltalat=2.7673, deltalon=2.8125                          ! Grid spacing, degrees
real :: dx=1.181168, dy=1.125966                                            ! Grid spacing, km
real :: xlonc=0                                                             ! Standard longitude of projection
real :: earth_radius=6367.470                                               ! Earth radius, km
logical :: is_wind_grid_rel=.false.                                         ! Flag indicating whether winds are
                                                                            ! relative to source grid (TRUE) or
                                                                            ! relative to earth (FALSE)
character (len=8) :: startloc="SWCORNER"                                    ! Which point in array is given by
                                                                            ! startlat/startlon; set either
                                                                            ! to 'SWCORNER' or 'CENTER '
character (len=9) :: field(5)                                               ! Name of the field in the netcdf file
character (len=24) :: hdate                                                 ! Valid date for data YYYY:MM:DD_HH:00:00
character (len=25) :: units(5)                                              ! Units of data
character (len=32) :: map_source="Arpege"                                   ! Source model / originating center
character (len=46) :: desc(5)                                               ! Short description of data

real,allocatable :: T(:,:,:,:),P(:,:,:),RH(:,:,:,:),U(:,:,:,:),V(:,:,:,:)
character*100 :: filepath
integer :: year,mon,day,hour,mon_day(12),lev,time
character*4 :: iyear
character*2 :: imon(12),iday(31),ihour(4)
character (len=9) :: fieldname(5)
character*100 :: filetimename
integer :: ounit=1

allocate(T(nx,ny,nz,nt))
allocate(P(nx,ny,nt))
allocate(RH(nx,ny,nz,nt))
allocate(U(nx,ny,nz,nt))
allocate(V(nx,ny,nz,nt))

field(1)="ta" ; units(1)="K"  ; desc(1)="Air Temperature"
field(2)="ps" ; units(2)="Pa" ; desc(2)="Surface Air Pressure"
field(3)="hus"; units(3)="%"  ; desc(3)="Specific Humidity"
field(4)="ua" ; units(4)="m s-1"; desc(4)="Eastward Wind"
field(5)="va" ; units(5)="m s-1"; desc(5)="Northward Wind"

fieldname(1)="TT"
fieldname(2)="PSFC"
fieldname(3)="RH"
fieldname(4)="UU"
fieldname(5)="VV"

imon=(/"01","02","03","04","05","06","07","08","09","10","11","12"/)
iday=(/"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15",  &
       "16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"/)
ihour=(/"00","06","12","18"/)
mon_day=(/31,28,31,30,31,30,31,31,30,31,30,31/)


do year=1950,2007
  
  write(iyear,'(I4)')year
  time=0

  call read_bcc_data(iyear,field,T,P,RH,U,V,nx,ny,nz,nt,nvar)

  do mon=1,12

    do day=1,mon_day(mon)

      do hour=1,4

        hdate=iyear//"-"//imon(mon)//"-"//iday(day)//"_"//ihour(hour)//":00:00"
        filetimename=iyear//"-"//imon(mon)//"-"//iday(day)//"_"//ihour(hour)
        filepath="/home3_hn/qianqf/"//"FILE:"//filetimename
        print*,filetimename
        open(unit=ounit,file=filepath,form='unformatted',access="sequential",status="unknown")
        
        time=time+1
print*,time
          ! 1)WRITE FORMAT VERSION
               write(unit=ounit) version
          ! 2)WRITE METADATA
          ! Gaussian
               write(unit=ounit) hdate, xfcst, map_source, fieldname(2), &
                                 units(2), desc(2), 1.0, nx, ny, iproj
               write(unit=ounit) startloc, startlat, startlon, &
                                 nlats, deltalon, earth_radius
          ! 3) WRITE WIND ROTATION FLAG
               write(unit=ounit) is_wind_grid_rel
          ! 4) WRITE DATA
               write(unit=ounit) P(:,:,time)
                       
        do lev=1,26
        
          ! 1)WRITE FORMAT VERSION
               write(unit=ounit) version
          ! 2)WRITE METADATA
          ! Gaussian
               write(unit=ounit) hdate, xfcst, map_source, fieldname(1), &
                                 units(1), desc(1), xlvl, nx, ny, iproj
               write(unit=ounit) startloc, startlat, startlon, &
                                 nlats, deltalon, earth_radius
          ! 3) WRITE WIND ROTATION FLAG
               write(unit=ounit) is_wind_grid_rel
          ! 4) WRITE DATA
               write(unit=ounit) T(:,:,lev,time)
                 
                 
          

          ! 1)WRITE FORMAT VERSION
               write(unit=ounit) version
          ! 2)WRITE METADATA
          ! Gaussian
               write(unit=ounit) hdate, xfcst, map_source, fieldname(3), &
                                 units(3), desc(3), xlvl, nx, ny, iproj
               write(unit=ounit) startloc, startlat, startlon, &
                                 nlats, deltalon, earth_radius
          ! 3) WRITE WIND ROTATION FLAG
               write(unit=ounit) is_wind_grid_rel
          ! 4) WRITE DATA
               write(unit=ounit) RH(:,:,lev,time) 



          ! 1)WRITE FORMAT VERSION
               write(unit=ounit) version
          ! 2)WRITE METADATA
          ! Gaussian
               write(unit=ounit) hdate, xfcst, map_source, fieldname(4), &
                                 units(4), desc(4), xlvl, nx, ny, iproj
               write(unit=ounit) startloc, startlat, startlon, &
                                 nlats, deltalon, earth_radius
          ! 3) WRITE WIND ROTATION FLAG
               write(unit=ounit) is_wind_grid_rel
          ! 4) WRITE DATA
               write(unit=ounit) U(:,:,lev,time)
           


          ! 1)WRITE FORMAT VERSION
               write(unit=ounit) version
          ! 2)WRITE METADATA
          ! Gaussian
               write(unit=ounit) hdate, xfcst, map_source, fieldname(5), &
                                 units(5), desc(5), xlvl, nx, ny, iproj
               write(unit=ounit) startloc, startlat, startlon, &
                                 nlats, deltalon, earth_radius
          ! 3) WRITE WIND ROTATION FLAG
               write(unit=ounit) is_wind_grid_rel
          ! 4) WRITE DATA
               write(unit=ounit) V(:,:,lev,time)
             
        end do
      
	    close(unit=ounit)

	  end do

    end do

  end do

end do

end program main


subroutine read_bcc_data(iyear,field,T,P,RH,U,V,nx,ny,nz,nt,nvar)
use netcdf
implicit none

integer :: nx,ny,nz,nt,nvar
character*9 :: field(nvar)
real :: T(nx,ny,nz,nt),P(nx,ny,nt),RH(nx,ny,nz,nt),U(nx,ny,nz,nt),V(nx,ny,nz,nt)   
character*4 :: iyear

integer::ncid,ncfile,dimidvar
integer::varidvar

character*100 :: filepath(5)
integer :: i

filepath(1)="/home3_hn/climateftp/research/climate_data/global_data/BCC/historical/"//iyear//"/bcc.air."//iyear//".nc"
filepath(2)="/home3_hn/climateftp/research/climate_data/global_data/BCC/historical/"//iyear//"/bcc.pres."//iyear//".nc"
filepath(3)="/home3_hn/climateftp/research/climate_data/global_data/BCC/historical/"//iyear//"/bcc.shum."//iyear//".nc"
filepath(4)="/home3_hn/climateftp/research/climate_data/global_data/BCC/historical/"//iyear//"/bcc.uwnd."//iyear//".nc"
filepath(5)="/home3_hn/climateftp/research/climate_data/global_data/BCC/historical/"//iyear//"/bcc.vwnd."//iyear//".nc"
  
ncfile=NF90_OPEN(filepath(1),nf90_nowrite,ncid)
ncfile=NF90_INQ_DIMID(ncid,field(1),dimidvar)
ncfile=NF90_INQ_VARID(ncid,field(1),varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,T)
ncfile=NF90_CLOSE(ncid)

ncfile=NF90_OPEN(filepath(2),nf90_nowrite,ncid)
ncfile=NF90_INQ_DIMID(ncid,field(2),dimidvar)
ncfile=NF90_INQ_VARID(ncid,field(2),varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,P)
ncfile=NF90_CLOSE(ncid)

ncfile=NF90_OPEN(filepath(3),nf90_nowrite,ncid)
ncfile=NF90_INQ_DIMID(ncid,field(3),dimidvar)
ncfile=NF90_INQ_VARID(ncid,field(3),varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,RH)
ncfile=NF90_CLOSE(ncid)

ncfile=NF90_OPEN(filepath(4),nf90_nowrite,ncid)
ncfile=NF90_INQ_DIMID(ncid,field(4),dimidvar)
ncfile=NF90_INQ_VARID(ncid,field(4),varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,U)
ncfile=NF90_CLOSE(ncid)

ncfile=NF90_OPEN(filepath(5),nf90_nowrite,ncid)
ncfile=NF90_INQ_DIMID(ncid,field(5),dimidvar)
ncfile=NF90_INQ_VARID(ncid,field(5),varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,V)
ncfile=NF90_CLOSE(ncid)

end subroutine read_bcc_data

