        module InversionCalc
	  
	  use GlbVars
	  
	  implicit none
	  
	  contains

!***************Calculate the PV distribution from the given height field.**********
        subroutine calcq(rhs,hfield,icon)
	
	  implicit none
	
	  integer :: icon,i,j,k,lonp,latp
	  real, dimension(:,:,:) :: rhs, hfield
	  real, dimension(ix,iy,iz) :: hs

	  hs(:,:,:) = hfield(:,:,:)
	  
	  if(icon == 2) then
	     hs(:,:,:) = gg*hs(:,:,:)/(dpi*tho)
	  else
	     do k = 1,iz  
	        hs(:,:,k) = gg*(hs(:,:,k)-hh(k))/(dpi*tho)
	     enddo
	  endif
	  
        do k = 2,iz
	     tht(:,:,k) = -(hs(:,:,k)-hs(:,:,k-1))/(xpi(k)-xpi(k-1))
	  enddo
	 
!	if (flagg.eq.2) then
!
!       RXB change 5/25/99 (comment following statement)
!
!	  hs(1,j,k)=0.
!	  hs(y,j,k)=0.
!	end if
	
	  do k = 2,iz-1
	     c(:,k,1) = f(:)*p25a(k+1)*bh(k)/(statstab(k+1)*p25(k))
           c(:,k,2) = fr*a(:,1)
	     c(:,k,3) = fr*a(:,2)
	     c(:,k,5) = c(:,k,3)
	     c(:,k,6) = fr*a(:,5)
	     c(:,k,7) = f(:)*p25a(k)*bl(k)/(statstab(k)*p25(k))
	     c(:,k,4) = fr*a(:,3) - c(:,k,1) - c(:,k,7)
	  enddo	
	  
	  do k = 2,iz-1
	     do j = 2,iy-1
	        do i = 1,ix
                 if (i == 1) then
                     if(Periodic) then
                        qgp(i,j,k)=c(j,k,1)*hs(i,j,k+1) + c(j,k,2)*hs(i,j-1,k) +     &
      	                c(j,k,3)*hs(ix,j,k) + c(j,k,4)*hs(i,j,k) + c(j,k,5)*      &
       	                hs(i+1,j,k) + c(j,k,6)*hs(i,j+1,k) + c(j,k,7)*hs(i,j,k-1)
                     else
			      qgp(i,j,k) = 0.
		         endif
                 elseif (i == ix) then
                      if(Periodic) then
                        qgp(i,j,k)=c(j,k,1)*hs(i,j,k+1) + c(j,k,2)*hs(i,j-1,k) +     &
      	                c(j,k,3)*hs(i-1,j,k) + c(j,k,4)*hs(i,j,k) + c(j,k,5)*     &
      	                hs(1,j,k) + c(j,k,6)*hs(i,j+1,k) + c(j,k,7)*hs(i,j,k-1)
                      else
			       qgp(i,j,k) = 0.
			    endif 
                 else 
                    qgp(i,j,k)=c(j,k,1)*hs(i,j,k+1) + c(j,k,2)*hs(i,j-1,k) +     &
      	          c(j,k,3)*hs(i-1,j,k) + c(j,k,4)*hs(i,j,k) + c(j,k,5)*      &
      	          hs(i+1,j,k) + c(j,k,6)*hs(i,j+1,k) + c(j,k,7)*hs(i,j,k-1)
                 endif
	        enddo
	      enddo
	
	      if (k == 2) then
	         c(:,k,4) = c(:,k,4) + c(:,k,7)
	      elseif (k == (iz-1)) then
	         c(:,k,4) = c(:,k,4) + c(:,k,1)
	      endif	    
	  enddo
	
	  if (icon == 1) then
	     do j = 2,iy-1
	        qgp(:,j,:) = qgp(:,j,:) + f(j)
	     enddo 
	  endif
	  
!   90N value of q	
! 	 qgp(y,j,k)=qgp(y-1,1,k)	 
!
!       RXB change 5/25/99
!
	  qgp(:,iy,:) = qgp(:,iy-1,:)

!********* determine the pv and thta levels to be used *****************
!rhs will only be filled with non-zero values within the PV area of interest

        call findindex(lonp,loni,qlonbounds(1))
	  call findindex(latp,lati,qlatbounds(1))
	  
	  do k = qlevs(1),qlevs(qz)
	     if (k == 1) then
	        do j = latp,latp+qy-1
	           do i = lonp,lonp+qx-1
	              rhs(i,j,2) = rhs(i,j,2) - tht(i,j,2)*(xpi(2)-xpi(1))*c(j,2,7)
		     enddo
		  enddo
		  
	     elseif (k == iz) then
	        do j = latp,latp+qy-1
		     do i = lonp,lonp+qx-1
                    rhs(i,j,k-1) = rhs(i,j,k-1) + tht(i,j,k)* &
			         (xpi(k) - xpi(k-1))*c(j,k-1,1)
		     enddo
		  enddo

           else
	        do j = latp,latp+qy-1
		     do i = lonp,lonp+qx-1 
                    rhs(i,j,k) = rhs(i,j,k) + qgp(i,j,k)
		     enddo
		  enddo
     	     endif
	  enddo
	  
	  c(:,2,7) = 0.
	  c(:,iz-1,1) = 0.
	  
	  end subroutine calcq
!************	  

!************Inverts the q field to get height.  Calls a solver.**********
        subroutine hinv(hfield,rhs) 
	
	  implicit none
	  
	  real, dimension(ix,iy,iz) :: hfield,rhs
	  
!*********** solve for hght perts **************************************
	  call solver(hfield,rhs,c)
!********** calculate boundary values *****************

        hfield(:,:,1) = hfield(:,:,2)
	  hfield(:,:,iz) = hfield(:,:,iz-1);
	   	
	  if(qlevs(1) == 1) then
	     hfield(:,:,1) = hfield(:,:,2) + tht(:,:,2)*(xpi(2)-xpi(1))
	  elseif(qlevs(qz) == iz) then
	     hfield(:,:,iz) = hfield(:,:,iz-1) - tht(:,:,iz)*(xpi(iz)-xpi(iz-1))
	  endif

!	  do k = 1,il
!	     if (rlev(k).eq.1) then
!	        hfield(:,:,1) = hfield(:,:,2) + tht(:,:,2)*(xpi(2)-xpi(1))
!	     elseif (rlev(k).eq.il) then
!	        hfield(:,:,il) = hfield(:,:,il-1) - tht(:,:,il)*(xpi(il)-xpi(il-1))
!	     endif
!	  enddo
	  
	  hfield(:,:,:) = tho*dpi*hfield(:,:,:)/gg

	  end subroutine hinv
!*****************************************************************************

!*************Solver for the Laplacian****************************************
	  subroutine solver(hgt,rhs,co)
	
	  implicit none
	  
	  real :: omg,trs,zmrs,rs,dz	  
	  integer :: i,j,k,max,itc,gpts
        real, dimension(ix,iy,iz) :: hgt,rhs
        real, dimension(iy,iz,7) :: co
	  logical :: icon, NorthPole
	  
	  omg = 1.8
	  trs = 0.0002
	  max = 20000
	
	  gpts=(iy-2)*(ix-2)*(iz-2)
!*********** iterate for solution *****************************
	  itc = 0
	  zmrs = 0
	  icon = .false.
	  NorthPole = ilatbounds(2) == 90.
	  do while((.not.icon).and.(itc <= max))
	     icon = .true.
	     do k = 2,iz-1
	        do j = 2,iy
	           do i = 1,ix
                    if((i == 1)) then
			     if(Periodic) then
	                    rs = co(j,k,1)*hgt(i,j,k+1) + co(j,k,2)*hgt(i,j-1,k) +  &
      	                   co(j,k,3)*hgt(ix,j,k)  + co(j,k,4)*hgt(i,j,k)   +  &
      	                   co(j,k,5)*hgt(i+1,j,k) + co(j,k,6)*hgt(i,j+1,k) +  &
      	                   co(j,k,7)*hgt(i,j,k-1) - rhs(i,j,k)
				else
				   rs = 0.
				endif

                     elseif(i == ix) then
			      if(Periodic) then
	                     rs = co(j,k,1)*hgt(i,j,k+1) + co(j,k,2)*hgt(i,j-1,k) + &
      	                    co(j,k,3)*hgt(i-1,j,k) + co(j,k,4)*hgt(i,j,k)   + &
      	                    co(j,k,5)*hgt(1,j,k)   + co(j,k,6)*hgt(i,j+1,k) + &
      	                    co(j,k,7)*hgt(i,j,k-1) - rhs(i,j,k)
				else
				    rs = 0.
				endif
                     elseif (j == iy.and.NorthPole) then
! this part makes it polar continuous
                        if((i >= 1).and.(i <= 36)) then
	                     rs = co(j,k,1)*hgt(i,j,k+1)     + co(j,k,2)*hgt(i+72,j-1,k)+ &
                                co(j,k,3)*hgt(i+36,j-1,k)  + co(j,k,4)*hgt(i,j,k)     + &
      	                    co(j,k,5)*hgt(i+108,j-1,k) + co(j,k,6)*hgt(i,j-1,k)   + &
      	                    co(j,k,7)*hgt(i,j,k-1)     - rhs(i,j,k)
	     
                         elseif ((i >= 37).and.(i <= 72)) then
	                      rs = co(j,k,1)*hgt(i,j,k+1)    + co(j,k,2)*hgt(i+72,j-1,k)+ &
      	                     co(j,k,3)*hgt(i+36,j-1,k) + co(j,k,4)*hgt(i,j,k)     + &
      	                     co(j,k,5)*hgt(i-36,j-1,k) + co(j,k,6)*hgt(i,j-1,k)   + &
      	                     co(j,k,7)*hgt(i,j,k-1)    - rhs(i,j,k)
 
                         elseif ((i >= 73).and.(i <= 108)) then
	                      rs = co(j,k,1)*hgt(i,j,k+1)    + co(j,k,2)*hgt(i-72,j-1,k)+ &
      	                     co(j,k,3)*hgt(i+36,j-1,k) + co(j,k,4)*hgt(i,j,k)     + &
      	                     co(j,k,5)*hgt(i-36,j-1,k) + co(j,k,6)*hgt(i,j-1,k)   + &
      	                     co(j,k,7)*hgt(i,j,k-1)    - rhs(i,j,k)
	     
                        elseif ((i >= 109).and.(i <= 144)) then
	                       rs = co(j,k,1)*hgt(i,j,k+1)     + co(j,k,2)*hgt(i-72,j-1,k)+ &
      	                      co(j,k,3)*hgt(i-108,j-1,k) + co(j,k,4)*hgt(i,j,k)     + &
      	                      co(j,k,5)*hgt(i-36,j-1,k)  + co(j,k,6)*hgt(i,j-1,k)   + &
      	                      co(j,k,7)*hgt(i,j,k-1)     - rhs(i,j,k)
                         endif
       
	               else
	                  rs = co(j,k,1)*hgt(i,j,k+1) + co(j,k,2)*hgt(i,j-1,k) + &
                             co(j,k,3)*hgt(i-1,j,k) + co(j,k,4)*hgt(i,j,k)   + &
                             co(j,k,5)*hgt(i+1,j,k) + co(j,k,6)*hgt(i,j+1,k) + &
                             co(j,k,7)*hgt(i,j,k-1) - rhs(i,j,k)
                     endif
			   
	               dz = -omg*rs/co(j,k,4) 
	               hgt(i,j,k) = hgt(i,j,k) + dz
	               zmrs = zmrs + abs(dz)
	    
	               if (abs(dz) > trs) then
	                  icon = .false.
	               endif
			enddo	
	         enddo	
	      enddo

! zmrs is the avg dz	 
	     zmrs = zmrs/gpts
 
           if (mod(itc,100) == 0) then
              print *, zmrs,itc
           endif
	     
	     if(.not.icon) then
              itc = itc + 1
	     endif
	     
           zmrs = 0.
       enddo
	    
	 if (itc > max) then
	    print *,'no convergence.'
!	    print*, itc
	    print *, 'abort'
          stop   
       else
          print *,'field converged.'
          print *, itc
	 endif

       end subroutine solver
!*************************************************************************

!**************Get the geostrophic winds from the new inverted height field.********
       subroutine getgeo(hgt,u1,v1,ug1,vg1,uag1,vag1)
        
	 implicit none

       integer :: i,j
	 real :: dy,omega
	 real, dimension(iy) :: fcor,dx
	 real, dimension(ix,iy,iz) :: hgt,u1,v1,ug1,vg1,uag1,vag1
	
	 omega = 7.29e-5
       dy = rearth*dlat*pi/180.

       fcor(:) = 2*omega*sin(lati(:)*(pi/180.))
       dx(:) = rearth*cos(lati(:)*(pi/180.))*(dlon*(pi/180.))

       do j = 2,iy-1
	    ug1(:,j,:) =  -gg*(hgt(:,j+1,:)-hgt(:,j-1,:))/      &
                     (fcor(j)*2.*dy)	
          do i = 1,ix
             if(i == 1) then
                vg1(i,j,:) =  gg*(hgt(2,j,:)-hgt(x,j,:))/     &
                          (fcor(j)*2.*dx(j))
             elseif(i == ix) then
                vg1(i,j,:) =  gg*(hgt(1,j,:)-hgt(x-1,j,:))/   &
                          (fcor(j)*2.*dx(j))  
	       else
                vg1(i,j,:) =  gg*(hgt(i+1,j,:)-hgt(i-1,j,:))/ &
                           (fcor(j)*2.*dx(j))
             endif
	     enddo
	  enddo
	
        j = iy
! option 1, fill in with actual winds at boundary
!	 ug1(:,j,:) = u1(:,j,:)
!	 vg1(:,j,:) = v1(:,j,:)
! option 2, set this value equal to adjacent geo winds 
        ug1(:,j,:) = ug1(:,j-1,:)	
        vg1(:,j,:) = vg1(:,j-1,:)	
		 
! for j=1 special case
        j = 1  
! option 1, fill in with actual winds at boundary
!	 ug1(:,j,:) = u1(:,j,:)
!	 vg1(:,j,:) = v1(:,j,:)

! option 2, set this value equal to adjacent geo winds 
       ug1(:,j,:) = ug1(:,j+1,:)	
	 vg1(:,j,:) = vg1(:,j+1,:)	

! Ageostrophic winds.
! uag1(:,:,:) = u1(:,:,:) - ug1(:,:,:)
! vag1(:,:,:) = v1(:,:,:) - vg1(:,:,:)	  
	  
	 end subroutine getgeo
	     
	 end module InversionCalc
