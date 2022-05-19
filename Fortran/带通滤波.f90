	parameter(nm=46)

	real y(nm)
	real fx(nm)

	do kk=1,nm
	y(kk) = kk
	end do


	  call hfilter(y,fx,nm)

	  do kk=1,nm
        write(*,*)fx(kk)
	  enddo

	stop
	end
	




!CCcccccccccccccccccccccccccccccccccccccccccccccccc
!CC  Fourier Transform and reverse Transform to
!CC  retain the information with 2<period<8(7<wavenumber<26) for highfilter and period>8 for lowfilter(0<wavenumber<6)
!CC
        subroutine hfilter(x,fx,nm)
        dimension WKP(nm),WK(2,0:nm),x(nm),fx(nm)


        do 12 i=1,nm
12      wkp(i)=x(i)

        PI=3.1415926
        TOTAL=float(nm)

        !DO 103 K=6,23                  !¸ÄÕâÀï
        DO 103 K=nm/9,nm                  !¸ÄÕâÀï
          S1=0.0
          S2=0.0
        DO 104 I=1,nm
        S1=S1+WKP(I)*COS(FLOAT(K)*FLOAT(I-1)*PI*2.0/real(nm))
104     S2=S2+WKP(I)*SIN(FLOAT(K)*FLOAT(I-1)*PI*2.0/real(nm))

        WK(1,K)=2.*S1/TOTAL
        if(k.eq.0)WK(1,K)=S1/TOTAL
        WK(2,K)=2.*S2/TOTAL
103     continue

!c   Reverse transform
        do 31 i=1,nm
        ss=0.
        !do 33 k=6,23                   !¸ÄÕâÀï
        do 33 k=nm/9,nm                   !¸ÄÕâÀï
          ss=ss+WK(1,k)*COS(FLOAT(K)*FLOAT(I-1)*PI*2.0/TOTAL)+WK(2,k)*SIN(FLOAT(K)*FLOAT(I-1)*PI*2.0/TOTAL)
33      continue
        fx(i)=ss
31      continue
        return
        end


