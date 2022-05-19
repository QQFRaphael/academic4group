# -*- coding: utf-8 -*-
"""
Created on Wed Jul 22 12:19:20 2015
API
@author: caiyunapp
"""
from profilehooks import profile
import time
from typhoon_global_forecast_mongo import forecast_mongo
@profile
def typhoon_api(userlocation):
        response=forecast_mongo(userlocation)
        if response==[[],[]]:
            flag='False'
            return {"status":flag}
        else:
            typhoon_id=response[1]
            dist=round(response[0][7],2)
            if response[0][8]>0:
                flag10='no'
                wind10_dist=abs(round(response[0][8],2))
                blowup10=[]
                touchdown10=[]
            else:
                flag10='yse'
                wind10_dist=abs(round(response[0][8],2))
                if response[0][0]!=0 and response[0][1]!=0:
                    tmgin10=list(time.gmtime(response[0][0]))
                    blowup10=tmgin10[0:6]
                    tmgout10=list(time.gmtime(response[0][1]-response[0][0]))
                    touchdown10=tmgout10[0:6]
            if response[0][9]>0:
                flag7='no'
                wind7_dist=abs(round(response[0][9],2))
                blowup7=[]
                touchdown7=[]
            else:
                flag7='yes'
                wind7_dist=abs(round(response[0][9],2))
                if response[0][2]!=0 and response[0][3]!=0:
                    tmgin7=list(time.gmtime(response[0][2]))
                    blowup7=tmgin7[0:6]
                    tmgout7=list(time.gmtime(response[0][3]-response[0][2]))
                    touchdown7=tmgout7[0:6]
            tmn=list(time.gmtime(response[0][6]))[0:6]
            #print typhoon_title
            #print tmn
            #print dist
            #print wind10_dist
            #print blowup10
            #print touchdown10
            #print wind7_dist
            #print blowup7
            #print touchdown7
            if tmn[0]==1970:
                flag='False'
            else:
                flag='True'
        return {"status":flag,"id":typhoon_id,"wind10":{"status":flag10,"entertime":blowup10,"staytime":touchdown10[2:],"distance":wind10_dist},"wind7":{"status":flag7,"entertime":blowup7,"stayttime":touchdown7[2:],"distance":wind7_dist},"neartime":tmn,"neardist":dist}
