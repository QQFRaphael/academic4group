"""
Created on Tue Jul 21 13:48:42 2015
forecast typhoon
@author:caiyunapp
"""
import numpy as np
from pymongo import MongoClient
from typhoon_main import forecast_typhoon

rslt_ids=[]
typhoon_locs={}

def refresh_mongo():
        global rslt_ids
        typhoon_coll=MongoClient('localhost',27017).typhoon_db.typhoon_collection
        for post in typhoon_coll.find():
            id= str(post['id'])
            rslt_ids+=[id]
            typhoon_locs[id]=np.asarray(post['data'])
        
def forecast_mongo(userlocation):
    rslts=[]
    for id in rslt_ids:
        loc=typhoon_locs[id]
        forecast=loc[:,0:7]
        wind_10_r=loc[0,7]*1.85
        wind_7_r=loc[1,7]*1.85
        if wind_10_r!=0 and wind_7_r!=0:
            rslts+=list(forecast_typhoon(userlocation,forecast,wind_10_r,wind_7_r))
    rslt_array=np.asarray(rslts)
    response=rslt_array.reshape([np.size(rslt_array)/10,10])
    if np.size(response)==0:
        return [[],[]]
    else:
        idx=np.argmin(response[:,7])
        return [response[idx,:].tolist(),rslt_ids[idx]]

refresh_mongo()
