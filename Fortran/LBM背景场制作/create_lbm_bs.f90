program main
implicit none

! this is the ncep grid settings
integer :: nx=144, ny=73, nt=12, nz=17,nz1=8,nz2=12

! this is the T21 grid settings
integer :: nxo=64, nyo=32

integer :: k,l

character*100 :: filepath
character*20 :: field
real,allocatable :: HGT(:,:,:,:),AIR(:,:,:,:),UWND(:,:,:,:),VWND(:,:,:,:), &
        RHUM(:,:,:,:),OMEGA(:,:,:,:),Q(:,:,:,:),PRES(:,:,:,:)
real,allocatable :: HGTO(:,:,:,:),AIRO(:,:,:,:),UWNDO(:,:,:,:),VWNDO(:,:,:,:), &
        RHUMO(:,:,:,:),OMEGAO(:,:,:,:),QO(:,:,:,:),PRESO(:,:,:,:)
real,allocatable :: level(:),lat(:),lon(:)
real,allocatable :: lat_out(:), lon_out(:), level1(:), level2(:)


allocate(HGT(nx,ny,nz,nt))
allocate(AIR(nx,ny,nz,nt))
allocate(UWND(nx,ny,nz,nt))
allocate(VWND(nx,ny,nz,nt))

allocate(Q(nx,ny,nz1,nt))
allocate(RHUM(nx,ny,nz1,nt))

allocate(OMEGA(nx,ny,nz2,nt))

allocate(PRES(nx,ny,1,nt))

allocate(HGTO(nxo,nyo,nz,nt))
allocate(AIRO(nxo,nyo,nz,nt))
allocate(UWNDO(nxo,nyo,nz,nt))
allocate(VWNDO(nxo,nyo,nz,nt))

allocate(RHUMO(nxo,nyo,nz1,nt))
allocate(QO(nxo,nyo,nz1,nt))

allocate(OMEGAO(nxo,nyo,nz2,nt))

allocate(PRESO(nxo,nyo,1,nt))

allocate(level(nz))
allocate(lat(ny))
allocate(lon(nx))

allocate(lat_out(nyo))
allocate(lon_out(nxo))

allocate(level1(nz1))
allocate(level2(nz2))

filepath="./ncep.nc"

field="hgt"
call readfield(filepath,field,HGT,nx,ny,nz,nt)

field="air"
call readfield(filepath,field,AIR,nx,ny,nz,nt)

field="rhum"
call readfield(filepath,field,RHUM,nx,ny,nz1,nt)

field="omega"
call readfield(filepath,field,OMEGA,nx,ny,nz2,nt)

field="uwnd"
call readfield(filepath,field,UWND,nx,ny,nz,nt)

field="vwnd"
call readfield(filepath,field,VWND,nx,ny,nz,nt)

field="q"
call readfield(filepath,field,Q,nx,ny,nz1,nt)

field="pres"
call readfield(filepath,field,PRES,nx,ny,1,nt)

field="level"
call readoned(filepath,field,level,nz)

field="lat"
call readoned(filepath,field,lat,ny)

field="lon"
call readoned(filepath,field,lon,nx)

field="level1"
call readoned(filepath,field,level1,nz1)

field="level2"
call readoned(filepath,field,level2,nz2)

lat_out = & 
(/-85.761,-80.269,-74.745,-69.213,-63.679,-58.143, & 
-52.607,-47.070,-41.532,-35.995,-30.458,-24.920,  &
-19.382,-13.844,-8.3067,-2.7689,2.7689,8.3067, & 
13.844,19.382,24.920,30.458,35.995,41.532,47.070, & 
52.607,58.143,63.679,69.213,74.745,80.269,85.761/)

lon_out = &
(/0.0, 5.625, 11.25, 16.875, 22.5, 28.125, 33.75, & 
39.375, 45.0, 50.625, 56.25, 61.875, 67.5, 73.125, &
78.75, 84.375,90.0, 95.625, 101.25, 106.875, 112.5, &
118.125, 123.75, 129.375, 135.0, 140.625, 146.25, &
151.875, 157.5, 163.125, 168.75, 174.375,180.0, &
185.625, 191.25, 196.875, 202.5, 208.125, 213.75, &
219.375, 225.0, 230.625, 236.25, 241.875, 247.5, &
253.125, 258.75, 264.375,270.0, 275.625, 281.25, &
286.875, 292.5, 298.125, 303.75, 309.375, 315.0, &
320.625, 326.25, 331.875, 337.5, 343.125, 348.75, 354.375/)

open(unit=1,file='ncep.clim.y79-14.t21.grd',form='unformatted',convert='big_endian')
open(unit=2,file='ncep.clim.y79-14.ps.t21.grd',form='unformatted',convert='big_endian')


do k=1,nt
        call INTP(nx,ny,nz,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,HGT(:,:,:,k),HGTO(:,:,:,k))
        call INTP(nx,ny,nz,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,AIR(:,:,:,k),AIRO(:,:,:,k))
        call INTP(nx,ny,nz1,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,RHUM(:,:,:,k),RHUMO(:,:,:,k))
        call INTP(nx,ny,nz,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,UWND(:,:,:,k),UWNDO(:,:,:,k))
        call INTP(nx,ny,nz,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,VWND(:,:,:,k),VWNDO(:,:,:,k))
        call INTP(nx,ny,nz1,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,Q(:,:,:,k),QO(:,:,:,k))
        call INTP(nx,ny,nz2,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,OMEGA(:,:,:,k),OMEGAO(:,:,:,k))
        call INTP(nx,ny,1,nxo,nyo,lon,lat,lon_out,lat_out,-9.9e8,PRES(:,:,:,k),PRESO(:,:,:,k))
end do

PRESO = PRESO / 100.0

do k=1,nt
   do l=1,nz
      write(1) HGTO(:,:,l,k)
   end do
   do l=1,nz1
      write(1) RHUMO(:,:,l,k)
   end do
   do l=1,nz1
      write(1) QO(:,:,l,k)
   end do
   do l=1,nz
      write(1) AIRO(:,:,l,k)
   end do
   do l=1,nz
      write(1) UWNDO(:,:,l,k)
   end do
   do l=1,nz
      write(1) VWNDO(:,:,l,k)
   end do
   do l=1,nz2
      write(1) OMEGAO(:,:,l,k)
   end do
   write(2) PRESO(:,:,1,k)
end do
end program main


subroutine readoned(filepath,field,VAR,nd)
use netcdf
implicit none
integer :: nd
character*20 :: field
real :: VAR(nd)
integer::ncid,ncfile,dimidvar
integer::varidvar
character*100 :: filepath
ncfile=NF90_OPEN(filepath,nf90_nowrite,ncid)
ncfile=NF90_INQ_VARID(ncid,field,varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,VAR)
ncfile=NF90_CLOSE(ncid)
end subroutine readoned


subroutine readfield(filepath,field,VAR,nx,ny,nz,nt)
use netcdf
implicit none
integer :: nx,ny,nz,nt
character*20 :: field
real :: VAR(nx,ny,nz,nt)
integer::ncid,ncfile,dimidvar
integer::varidvar
character*100 :: filepath
ncfile=NF90_OPEN(filepath,nf90_nowrite,ncid)
ncfile=NF90_INQ_VARID(ncid,field,varidvar)
ncfile=NF90_GET_VAR(ncid,varidvar,VAR)
ncfile=NF90_CLOSE(ncid)
end subroutine readfield

!==============below is from intp.f of LBM, in ln_solver/solver/custom==============


!* SUPPLEMENT ROUTINE IN LBM2.0 on 2001/10/22
!*=============================================================
      SUBROUTINE INTP(IMAX,JMAX,KMAX,IDIM,JDIM,ALONI,COLRAI,ALONO,COLRAO,DMS,DIN,DOUT)
!*
!*     spatial interporation
!*
!C     USAGE:
!C        IMAX: x-dimension for input data
!C        JMAX: y-dimension for input data
!C        KMAX: z-dimension for input data
!C        IDIM: x-dimension for output data
!C        JDIM: y-dimension for output data
!C        ALONI : array of longitude (0 - 360  deg.) for input
!C        COLRAI: array of latitude  (-90 - 90 deg.) for input
!C        ALONO : array of longitude (0 - 360  deg.) for output
!C        COLRAO: array of latitude  (-90 - 90 deg.) for output
!C        DMS   : value for missing grid
!C        DIN   : input array, DIN=DIN(IMAX,JMAX,KMAX)
!C        DOUT  : output array, DOUT=DOUT(IDIM,JDIM,KMAX)
!C
!*
      INTEGER   IMAX, JMAX, KMAX
      INTEGER   IDIM, JDIM
      REAL*4    DMS
      REAL*4    DIN(IMAX,JMAX,KMAX),DOUT(IDIM,JDIM,KMAX)
      REAL*4    ALONI(IMAX),ALONO(IDIM)
      REAL*4    COLRAO(JDIM),COLRAI(JMAX)
!*
      INTEGER   I, J, K
!*
      CALL LINTPMS(IMAX,JMAX,KMAX,IDIM,JDIM,ALONI,COLRAI,ALONO,COLRAO,DMS,DIN,DOUT)
!*
      DO K = 1, KMAX
         DO J = 1, JDIM
            IF( COLRAO( J ) .LT. COLRAI( 1    ) .OR. COLRAO( J ) .GT. COLRAI( JMAX )      ) THEN
               DO I = 1, IDIM
                  DOUT( I,J,K ) = DMS
               ENDDO    
            ENDIF
         ENDDO
      ENDDO
!*
      RETURN
      END SUBROUTINE INTP
!*=============================================================
      SUBROUTINE LINTPMS(IMAX,JMAX,KMAX,IDIM,JDIM,ALONI,COLRAI,ALONO,COLRAO,DMS,DIN,DOUT)
!*
      INTEGER   MAXDM
      PARAMETER ( MAXDM = 1000 )
!*
      INTEGER   IMAX, JMAX, KMAX
      INTEGER   IDIM, JDIM
      REAL*4    DMS
      REAL*4    DIN(IMAX,JMAX,KMAX),DOUT(IDIM,JDIM,KMAX)
      REAL*4    DX(MAXDM),DY(MAXDM),LX(MAXDM),LY(MAXDM),LXP(MAXDM)
      REAL*4    ALONI(IMAX),ALONO(IDIM)
      REAL*4    COLRAO(JDIM),COLRAI(JMAX),WEI(4)

      REAL*4    DLON, FLON, FX, FY, WSUM
      INTEGER   ID, JD, IP, JP, IDP, K
      LOGICAL   FIRST/.TRUE./
      DATA      LY/MAXDM*0/                 ! 1/10/95
!*
      IF(FIRST) THEN
         FIRST=.FALSE.
         DLON=ALONI(2)-ALONI(1)
         DO 100 JP=1,JDIM
            DO 120 JD=2,JMAX
               IF(COLRAI(JD).GE.COLRAO(JP)) THEN
                  LY(JP)=JD
                  DY(JP)=(COLRAO(JP)-COLRAI(JD-1))/(COLRAI(JD)-COLRAI(JD-1))
                  GO TO 100
               ENDIF
  120       CONTINUE
  100    CONTINUE
         DO 140 IP=1,IDIM
            FLON=ALONO(IP)
            IF(ALONO(IP) .GT. 360.) FLON=ALONO(IP)-360.
            DO 141 ID=1,IMAX-1
               IF(ALONI(ID).LE.FLON .AND. ALONI(ID+1).GT.FLON) GO TO 142
  141       CONTINUE
            ID=IMAX
  142       LX(IP)=ID
            IF(LX(IP) .GT. IMAX) LX(IP)=LX(IP)-IMAX
            IDP=MOD(ID,IMAX)+1
            LXP(IP)=IDP
            DX(IP)=(FLON-ALONI(ID))/DLON
            IF(DX(IP) .LT. 0.0) DX(IP)=DX(IP)+360./DLON 
  140    CONTINUE
      ENDIF
!*
      DO 200  K=1,KMAX
         DO 220 JP=1,JDIM
         JD=LY(JP)
         FY=DY(JP)
         DO 220 IP=1,IDIM
         ID=LX(IP)
         IDP=LXP(IP)
         FX=DX(IP)
         WEI(1)=FX*FY
         WEI(2)=(1.0-FX)*FY
         WEI(3)=FX*(1.0-FY)
         WEI(4)=(1.0-FX)*(1.0-FY)
         IF(DIN(IDP ,JD  ,K) .EQ. DMS) WEI(1)=0.0
         IF(DIN(ID  ,JD  ,K) .EQ. DMS) WEI(2)=0.0
         IF(DIN(IDP ,JD-1,K) .EQ. DMS) WEI(3)=0.0
         IF(DIN(ID  ,JD-1,K) .EQ. DMS) WEI(4)=0.0
         WSUM=WEI(1)+WEI(2)+WEI(3)+WEI(4)
         IF(WSUM .LE. 0.0 .OR. JD .LE. 1) THEN
            DOUT(IP,JP,K)=DMS
         ELSE
            DOUT(IP,JP,K)=WEI(1)*DIN(IDP ,JD  ,K)+WEI(2)*DIN(ID  ,JD  ,K)+WEI(3)*DIN(IDP ,JD-1,K)+WEI(4)*DIN(ID  ,JD-1,K)
            DOUT(IP,JP,K)=DOUT(IP,JP,K)/WSUM
         ENDIF
  220    CONTINUE
  200 CONTINUE
!*
      RETURN
      END SUBROUTINE LINTPMS


