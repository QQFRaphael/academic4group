# -*- coding: utf-8 -*-
"""
Created on Thu Jul 16 16:45:19 2015
grab typhoon path
@author:caiyunapp
"""
import os
import time
import string
import numpy as np
from datetime import datetime
from pymongo import MongoClient

typhoon_client=MongoClient('localhost', 27017)
typhoon_db=typhoon_client['typhoon_db']
typhoon_collection=typhoon_db['typhoon_collection']

def grab_typhoon_data(typhoon_id):
    time_str = time.strftime("%Y%m%d%H")
    filename_report = "/home/qzhang/typhoon/" + typhoon_id + "_" + time_str
    filename_kmz = "/home/qzhang/typhoon/" + typhoon_id + "_" + time_str+".kmz"
    url_report = "http://www.usno.navy.mil/NOOC/nmfc-ph/RSS/jtwc/warnings/" + typhoon_id + "web.txt"
    url_kmz = "http://www.usno.navy.mil/NOOC/nmfc-ph/RSS/jtwc/warnings/" + typhoon_id + ".kmz"
    os.system('wget -T 10 -t 2 -O '+filename_report+' "'+url_report+'" --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"')
    os.system('wget -T 10 -t 2 -O '+filename_kmz+' "'+url_kmz+'" --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"')    
    f=open(filename_report,'r')
    read_data = f.read()
    lines = read_data.split("\r\n")
    wind_10_r=0
    wind_7_r=0
    forecast=np.zeros([3,8])
    count=0
    for line in lines:
        if "Z ---" in line and line[12] !="N":
            recrod=line.split(" ")
            date=recrod[3]
            day = date[0:2]
            hour = date[2:4]
            predict_time = int(datetime.strptime('7 ' + day + ' 2015 ' + hour, '%m %d %Y %H').strftime("%s")) + 3600*8
            lat = string.atof(recrod[-2][:-1])
            lon = string.atof(recrod[-1][:-1])
            forecast[:,count]=[predict_time,lat,lon]
            count=count+1
        if wind_10_r==0 and "RADIUS OF 050 KT WINDS" in line:
            recrod=line.split(" ")
            wind_10_r=string.atof(recrod[9])*1.85
        if wind_7_r==0 and "RADIUS OF 034 KT WINDS" in line:
            recrod=line.split(" ")
            wind_7_r=string.atof(recrod[9])*1.85
    forecast[:,7]=[wind_10_r,wind_7_r,0]
    if forecast[0,0]!=0:
        try:
            np.save(filename_report,forecast)
            typhoon_db.typhoon_collection.insert_one({"id":typhoon_id,"data":forecast.tolist()})
        except OSError:
            pass
