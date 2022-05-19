# -*- coding: utf-8 -*-
"""
Created on Sun Jul 12 10:37:54 2015
typhoon nearest position , nearest time , wind influence time wind deinfluence time 
@author: caiyunapp
"""
import numpy as np
import sympy as smy
def forecast_typhoon(userlocation,forecast,wind_7_r,wind_10_r):
    nearlocation=np.empty([2,2])
    time_goin_10=0
    time_goout_10=0
    time_goin_10_first=0
    time_goout_10_first=0
    time_goin_10_second=0
    time_goout_10_second=0
    time_goin_7=np.zeros([2])
    time_goout_7=np.zeros([2])
    time_goin_7_first=0
    time_goout_7_first=0
    time_goin_7_second=0
    time_goout_7_second=0 
    nearlat=0
    nearlon=0
    neartm=0
    dist=np.sqrt((forecast[1,:]-userlocation[0])**2+(forecast[2,:]-userlocation[1])**2)
    idx_near=np.argmin(dist)
    ###
    ###
    if idx_near==0:
        idx_near_after=idx_near+1
        a2=(forecast[2,idx_near]-forecast[2,idx_near_after])/(forecast[1,idx_near]-forecast[1,idx_near_after])
        b2=forecast[2,idx_near]-a2*forecast[1,idx_near]
        dist2=abs(a2*userlocation[0]+b2-userlocation[1])*np.sqrt(a2**2+1)
        nearlocation[0,0]=-(a2*b2-a2*userlocation[1]-userlocation[0])/(a2*a2+1)
        nearlocation[0,1]=a2*nearlocation[0,0]+b2
        neardist=dist2
        if nearlocation[1,0]<min(forecast[1,idx_near],forecast[1,idx_near_after]) or nearlocation[1,0]>max(forecast[1,idx_near],forecast[1,idx_near_after]):
            time_near=(forecast[0,idx_near_after]-forecast[0,idx_near])*(dist2-dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
        else:
            time_near=(forecast[0,idx_near_after]-forecast[0,idx_near])*(dist[idx_near]-dist2)/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
        if dist2<=wind_10_r/111:
            if time_near<forecast[0,idx_near] and dist[idx_near]<=wind_10_r/111:
                #print('10 level wind influence me11')
                time_goout_10=(forecast[0,idx_near_after]-forecast[0,idx_near])*(wind_10_r/111-dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goin_10=-(time_goout_10-time_near)+time_near
                nearlat=forecast[1,idx_near]
                nearlon=forecast[2,idx_near]
                neartm=forecast[0,idx_near]
            if time_near<forecast[0,idx_near] and dist[idx_near]>wind_10_r/111:
                pass                
                #print('10 level wind not influence me11')
            if time_near>=forecast[0,idx_near] and dist[idx_near]<=wind_10_r/111:
                pass
                #print('10 level wind influence me12')
                time_goout_10=(forecast[0,idx_near_after]-forecast[0,idx_near])*(wind_10_r/111-dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goin_10=-(time_goout_10-time_near)+time_near
                nearlat=nearlocation[0,0]
                nearlon=nearlocation[0,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]>wind_10_r/111:
                #print('10 level wind influence me13')
                time_goin_10=(forecast[0,idx_near_after]-forecast[0,idx_near])*(-wind_10_r/111+dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goout_10=(time_near-time_goin_10)+time_near
                nearlat=nearlocation[0,0]
                nearlon=nearlocation[0,1]
                neartm=time_near
        else:
            pass
            #print('10 level wind not influence me12')
        if dist2<=wind_7_r/111:
            if time_near<forecast[0,idx_near] and dist[idx_near]<=wind_7_r/111:
                #print('7 level wind influence me11')
                time_goout_7=(forecast[0,idx_near_after]-forecast[0,idx_near])*(wind_7_r/111-dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goin_7=(time_goout_7-time_near)+time_near
                nearlat=forecast[1,idx_near]
                nearlon=forecast[2,idx_near]
                neartm=forecast[0,idx_near]
            if time_near<forecast[0,idx_near] and dist[idx_near]>wind_7_r/111:
                pass
                #print('7 level wind not influence me11')
            if time_near>=forecast[0,idx_near] and dist[idx_near]<=wind_7_r/111:
                #print('7 level wind influence me12')
                time_goout_7=(forecast[0,idx_near_after]-forecast[0,idx_near])*(wind_7_r/111-dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goin_7=(time_goout_7-time_near)+time_near
                nearlat=nearlocation[0,0]
                nearlon=nearlocation[0,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]>wind_7_r/111:
                #print('7 level wind influence me13')
                time_goin_7=(forecast[0,idx_near_after]-forecast[0,idx_near])*(-wind_7_r/111+dist[idx_near])/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
                time_goout_7=(time_near-time_goin_7)+time_near
                nearlat=nearlocation[0,0]
                nearlon=nearlocation[0,1]
                neartm=time_near
        else:
            pass
            #print('7 level wind not influence me12')
        time_goin_10=time_goin_10_first
        time_goout_10=time_goout_10_first
        time_goin_7=time_goin_7_first
        time_goout_7=time_goout_7_first        
    ###
    ###
    if idx_near==np.size(dist)-1:
        idx_near_before=idx_near-1
        a1=(forecast[2,idx_near]-forecast[2,idx_near_before])/(forecast[1,idx_near]-forecast[1,idx_near_before])
        b1=forecast[2,idx_near]-a1*forecast[1,idx_near]
        dist1=abs(a1*userlocation[0]+b1-userlocation[1])*np.sqrt(a1**2+1)
        nearlocation[1,0]=-(a1*b1-a1*userlocation[1]-userlocation[0])/(a1*a1+1)
        nearlocation[1,1]=a1*nearlocation[1,0]+b1
        neardist=dist1
        if nearlocation[1,0]<min(forecast[1,idx_near],forecast[1,idx_near_before]) or nearlocation[1,0]>max(forecast[1,idx_near],forecast[1,idx_near_before]):
            time_near=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-dist1)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
        else:
            time_near=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist1-dist[idx_near])/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
        if dist1<=wind_10_r/111:
            if time_near<forecast[0,idx_near] and dist[idx_near]<=wind_10_r/111:
                #print('10 level wind influence me21')
                time_goout_10_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(wind_10_r/111-dist[idx_near])/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goin_10_first=(time_goout_10_first-time_near)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near<forecast[0,idx_near] and dist[idx_near]>wind_10_r/111:
                #print('10 level wind influence me22')
                time_goout_10_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_10_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goin_10_first=(time_goout_10_first-time_near)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]<=wind_10_r/111:
                #print('10 level wind influence me23')
                time_goin_10_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_10_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goout_10_first=(time_near-time_goin_10_first)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]>wind_10_r/111:
                #print('10 level wind influence me24')
                time_goin_10_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_10_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goout_10_first=(time_near-time_goin_10_first)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
        else:
            pass
            #print('10 level wind not influence me21')
        if dist1<=wind_7_r/111:
            if time_near<forecast[0,idx_near] and dist[idx_near]<=wind_7_r/111:
                #print('7 level wind influence me21')
                time_goout_7_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(wind_7_r/111-dist[idx_near])/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goin_7_first=(time_goout_7_first-time_near)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near<forecast[0,idx_near] and dist[idx_near]>wind_7_r/111:
                #print('7 level wind influence me22')
                time_goout_7_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_7_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goin_7_first=(time_goout_7_first-time_near)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]<=wind_7_r/111:
                #print('7 level wind influence me23')
                time_goin_7_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_7_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goout_7_first=(time_near-time_goin_7_first)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
            if time_near>=forecast[0,idx_near] and dist[idx_near]>wind_7_r/111:
                #print('7 level wind influence me24')
                time_goin_7_first=(forecast[0,idx_near]-forecast[0,idx_near_before])*(dist[idx_near]-wind_7_r/111)/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
                time_goout_7_first=(time_near-time_goin_7_first)+time_near
                nearlat=nearlocation[1,0]
                nearlon=nearlocation[1,1]
                neartm=time_near
        else:
            pass
            #print('7 level wind not influence me22')
        time_goin_10=time_goin_10_first
        time_goout_10=time_goout_10_first
        time_goin_7=time_goin_7_first
        time_goout_7=time_goout_7_first
        nearlat=nearlocation[1,0]
        nearlon=nearlocation[1,1]
        neartm=time_near
    ###
    ###
    if idx_near<np.size(dist)-1 and idx_near>0:
        idx_near_before=idx_near-1
        idx_near_after=idx_near+1
        xf=np.empty([3,3])
        xf[0,0]=forecast[1,idx_near]**2
        xf[1,0]=forecast[1,idx_near_before]**2
        xf[2,0]=forecast[1,idx_near_after]**2
        xf[0,1]=forecast[1,idx_near]
        xf[1,1]=forecast[1,idx_near_before]
        xf[2,1]=forecast[1,idx_near_after]
        xf[0,2]=1
        xf[1,2]=1
        xf[2,2]=1
        y=[forecast[2,idx_near],forecast[2,idx_near_before],forecast[2,idx_near_after]]
        bounds_lat_min=min(forecast[1,idx_near_before:idx_near_after+1])
        bounds_lat_max=max(forecast[1,idx_near_before:idx_near_after+1])
        fac=np.linalg.solve(xf,y)
        from scipy.optimize import minimize_scalar
        f=lambda x: np.sqrt((x-userlocation[0])**2+(fac[0]*x**2+fac[1]*x+fac[2]-userlocation[1])**2)
        rslt=minimize_scalar(f,bounds=(bounds_lat_min,bounds_lat_max))
        nearlat=rslt.x
        nearlon=fac[0]*nearlat**2+fac[1]*nearlat+fac[2]
        neardist=f(nearlat)
        if nearlat<max(forecast[1,idx_near],forecast[1,idx_near_before]) and nearlat>min(forecast[1,idx_near],forecast[1,idx_near_before]):
            neartm=(forecast[0,idx_near]-forecast[0,idx_near_before])*(neardist-dist[idx_near])/(dist[idx_near_before]-dist[idx_near])+forecast[0,idx_near]
        else:
            neartm=(forecast[0,idx_near_after]-forecast[0,idx_near])*(dist[idx_near]-neardist)/(dist[idx_near_after]-dist[idx_near])+forecast[0,idx_near]
        lat=smy.Symbol('lat')
        lat_goinout_10raw=smy.nroots((lat-userlocation[0])**2+(fac[0]*lat**2+fac[1]*lat+fac[1]-userlocation[1])**2-(wind_10_r/111)**2,n=6)
        lat_goinout_7raw=smy.nroots((lat-userlocation[0])**2+(fac[0]*lat**2+fac[1]*lat+fac[1]-userlocation[1])**2-(wind_10_r/111)**2,n=6)
        lat_goinout_10=[complex(flag).real for flag in lat_goinout_10raw ]
        lat_goinout_7=[complex(flag).real for flag in lat_goinout_7raw ]
        lon_goinout_10=[fac[0]*complex(flag).real**2+fac[1]*complex(flag).real+fac[2] for flag in lat_goinout_10raw ]
        lon_goinout_7=[fac[0]*complex(flag).real**2+fac[1]*complex(flag).real+fac[2] for flag in lat_goinout_7raw ]
        if dist[idx_near]<=wind_10_r/111:
            #print('10 level wind influence me31')
            if dist[idx_near_before]>=wind_10_r/111:
                idx_in=idx_near_before
            else:
                idx_in=0
            if dist[idx_near_after]>=wind_10_r/111:
                idx_out=idx_near_after
            else:
                idx_out=np.size(dist)-1
            a2=(forecast[2,idx_near]-forecast[2,idx_out])/(forecast[1,idx_near]-forecast[1,idx_out])
            b2=forecast[2,idx_near]-a2*forecast[1,idx_near]
            dist2=abs(a2*userlocation[0]+b2-userlocation[1])*np.sqrt(a2**2+1)
            nearlocation[1,0]=-(a2*b2-a2*userlocation[1]-userlocation[0])/(a2*a2+1)
            nearlocation[1,1]=a2*nearlocation[1,0]+b2
            a1=(forecast[2,idx_near]-forecast[2,idx_in])/(forecast[1,idx_near]-forecast[1,idx_in])
            b1=forecast[2,idx_near]-a1*forecast[1,idx_near]
            dist1=abs(a1*userlocation[0]+b1-userlocation[1])*np.sqrt(a1**2+1)
            nearlocation[0,0]=-(a1*b1-a1*userlocation[1]-userlocation[0])/(a1*a1+1)
            nearlocation[0,1]=a1*nearlocation[0,0]+b1
            neardist=min(dist1,dist2)
            if dist[idx_in]>wind_10_r/111 and dist[idx_in+1]<=wind_10_r/111:
                time_goin_10_first=(forecast[0,idx_near]-forecast[0,idx_in])*(dist[idx_in]-(wind_10_r/111))/(dist[idx_in]-dist[idx_near])+forecast[0,idx_in]
            else:
                time_goin_10_first=(forecast[0,idx_near]-forecast[0,idx_in])*(dist[idx_in]-(wind_10_r/111))/(dist[idx_in]-dist[idx_near])+forecast[0,idx_in]
            if dist[idx_out]<wind_10_r/111 and dist[idx_out+1]>=wind_10_r/111:
                time_goout_10_first=(-forecast[0,idx_near]+forecast[0,idx_out])*(-dist[idx_out]+(wind_10_r/111))/(dist[idx_out]-dist[idx_near])+forecast[0,idx_out]
                #print "311"
            else:
                time_goout_10_first=(-forecast[0,idx_near]+forecast[0,idx_out])*(-dist[idx_out]+(wind_10_r/111))/(dist[idx_out]-dist[idx_near])+forecast[0,idx_out]
                #print "312"
                time_goin_10_second=0
                time_goout_10_second=0
        else:
            if neardist>wind_10_r/111:
                pass
                #print('10 level wind not influence me31')
            else:
                #print('10 level wind influence me32')
                dist_from_before=min(np.sqrt((lat_goinout_10-forecast[1,idx_near_before])**2+(lon_goinout_10-forecast[2,idx_near_before])**2))
                dist_from_after=min(np.sqrt((lat_goinout_10-forecast[1,idx_near_after])**2+(lon_goinout_10-forecast[2,idx_near_after])**2))
                dist_near_from_before=np.sqrt((nearlat-forecast[1,idx_near_before])**2+(nearlon-forecast[2,idx_near_before])**2)
                dist_near_from_after=np.sqrt((nearlat-forecast[1,idx_near_after])**2+(nearlon-forecast[2,idx_near_after])**2)
                time_goin_10_first=(neartm-forecast[0,idx_near_before])*dist_from_before/dist_near_from_before+forecast[0,idx_near_before]
                time_goout_10_first=neartm-time_goin_10_first+neartm
                time_goout_10_second=(neartm-forecast[0,idx_near_after])*dist_from_after/dist_near_from_after+forecast[0,idx_near_after]
                time_goin_10_second=-time_goout_10_second+neartm+neartm
        if time_goin_10_first!=0 and time_goin_10_second!=0:
            time_goin_10=min(time_goin_10_first,time_goin_10_second)
        else:
            if time_goin_10_first==0:
                time_goin_10=time_goin_10_second
            if time_goin_10_second==0:
                time_goin_10=time_goin_10_first
        if time_goout_10_first!=0 and time_goout_10_second!=0:
            time_goin_10=max(time_goout_10_first,time_goout_10_second)
        else:
            if time_goout_10_first==0:
                time_goout_10=time_goout_10_second
            if time_goout_10_second==0:
                time_goout_10=time_goout_10_first
        if dist[idx_near]<=wind_7_r/111:
            #print('7 level wind influence me31')
            if dist[idx_near_before]>=wind_7_r/111:
                idx_in=idx_near_before
            else:
                idx_in=0
            if dist[idx_near_after]>=wind_7_r/111:
                idx_out=idx_near_after
            else:
                idx_out=np.size(dist)-1
            a2=(forecast[2,idx_near]-forecast[2,idx_out])/(forecast[1,idx_near]-forecast[1,idx_out])
            b2=forecast[2,idx_near]-a2*forecast[1,idx_near]
            dist2=abs(a2*userlocation[0]+b2-userlocation[1])*np.sqrt(a2**2+1)
            nearlocation[1,0]=-(a2*b2-a2*userlocation[1]-userlocation[0])/(a2*a2+1)
            nearlocation[1,1]=a2*nearlocation[1,0]+b2
            a1=(forecast[2,idx_near]-forecast[2,idx_in])/(forecast[1,idx_near]-forecast[1,idx_in])
            b1=forecast[2,idx_near]-a1*forecast[1,idx_near]
            dist1=abs(a1*userlocation[0]+b1-userlocation[1])*np.sqrt(a1**2+1)
            nearlocation[0,0]=-(a1*b1-a1*userlocation[1]-userlocation[0])/(a1*a1+1)
            nearlocation[0,1]=a1*nearlocation[0,0]+b1
            neardist=min(dist1,dist2)
            if dist[idx_in]>wind_7_r/111 and dist[idx_in+1]<=wind_7_r/111:
                time_goin_7_first=(forecast[0,idx_near]-forecast[0,idx_in])*(dist[idx_in]-(wind_7_r/111))/(dist[idx_in]-dist[idx_near])+forecast[0,idx_in]
            else:
                time_goin_7_first=(forecast[0,idx_near]-forecast[0,idx_in])*(dist[idx_in]-(wind_7_r/111))/(dist[idx_in]-dist[idx_near])+forecast[0,idx_in]
            if dist[idx_out]<wind_7_r/111 and dist[idx_out+1]>=wind_7_r/111:
                time_goout_7_first=(-forecast[0,idx_near]+forecast[0,idx_out])*(-dist[idx_out]+(wind_7_r/111))/(dist[idx_out]-dist[idx_near])+forecast[0,idx_out]
            else:
                time_goout_7_first=(-forecast[0,idx_near]+forecast[0,idx_out])*(-dist[idx_out]+(wind_7_r/111))/(dist[idx_out]-dist[idx_near])+forecast[0,idx_out]
                time_goin_7_second=0
                time_goout_7_second=0
        else:
            if neardist>wind_7_r/111:
                pass
                #print('7 level wind not influence me31')
            else:
                #print('7 level wind influence me32')
                dist_from_before=min(np.sqrt((lat_goinout_7-forecast[1,idx_near_before])**2+(lon_goinout_7-forecast[2,idx_near_before])**2))
                dist_from_after=min(np.sqrt((lat_goinout_7-forecast[1,idx_near_after])**2+(lon_goinout_7-forecast[2,idx_near_after])**2))
                dist_near_from_before=np.sqrt((nearlat-forecast[1,idx_near_before])**2+(nearlon-forecast[2,idx_near_before])**2)
                dist_near_from_after=np.sqrt((nearlat-forecast[1,idx_near_after])**2+(nearlon-forecast[2,idx_near_after])**2)
                time_goin_7_first=(neartm-forecast[0,idx_near_before])*dist_from_before/dist_near_from_before+forecast[0,idx_near_before]
                time_goout_7_first=neartm-time_goin_7_first+neartm
                time_goout_7_second=(neartm-forecast[0,idx_near_after])*dist_from_after/dist_near_from_after+forecast[0,idx_near_after]
                time_goin_7_second=-time_goout_7_second+neartm+neartm
        if time_goin_7_first!=0 and time_goin_7_second!=0:
            time_goin_7=min(time_goin_7_first,time_goin_7_second)
        else:
            if time_goin_7_first==0:
                time_goin_7=time_goin_7_second
            if time_goin_7_second==0:
                time_goin_7=time_goin_7_first
        if time_goout_7_first!=0 and time_goout_7_second!=0:
            time_goin_7=max(time_goout_7_first,time_goout_7_second)
        else:
            if time_goout_7_first==0:
                time_goout_7=time_goout_7_second
            if time_goout_7_second==0:
                time_goout_7=time_goout_7_first
        #print time_goin_7_first,time_goin_10_first,time_goin_7_second,time_goin_10_second
        #print time_goout_7_first,time_goout_10_first,time_goout_7_second,time_goout_10_second
    return(time_goin_10,time_goout_10,time_goin_7,time_goout_7,nearlat,nearlon,neartm,neardist*111,neardist*111-wind_10_r,neardist*111-wind_7_r)
