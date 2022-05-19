       program pseudo_inv
	 
	 use GlbVars
	 use FileManager
	 use InversionCalc
	 
	 implicit none
	 
	 print *, '***************************************'
	 print *, '          PV Inversion Code            '
	 print *, '***************************************'
	 print *, ''
	 
	 call GlbVarInit()
	 call openfiles()	 
	 call rdmean() 
	 call calcstatstab()
	 
	 iflag = 2
! calcs mean pv
!	 call calcq(rhmean,hmean,iflag)
! 	 print *,'mean data read in.'

	 do day = 1,narr
	    print *, 'array = ', day
	    hp(:,:,:) = 0.
	    rh(:,:,:) = 0.
	    rhp(:,:,:) = 0.
	    qgp(:,:,:) = 0.
	    
! calcs full pv field with f
!	    call calcq(rh,h,iflag)
            print *, 'calculated full PV field.'

!  calcs pert pv from mean and full pv fields
!            rhp(:,:,:) = rh(:,:,:) - rhmean(:,:,:)
	    
	     call rddata()
	     print *, 'read in data'
  
	     call calcq(rhp,h,iflag)
             print *, 'calculated q from pert field'
  
             call hinv(hp,rhp)
          
             call getgeo(hp,u,v,ugp,vgp,uagp,vagp)
	    
	     call output(hp,21)
	     call output(ugp,22)
	     call output(vgp,23)
	     call output(qgp,24)
	 enddo
	 
	 call closefiles()
	 
	 call GlbVarRelease()
	 
	 end program pseudo_inv
