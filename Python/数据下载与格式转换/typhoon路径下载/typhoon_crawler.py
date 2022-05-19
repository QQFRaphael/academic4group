# -*- coding: utf-8 -*-
"""
Created on Fri Jul 17 18:06:36 2015
acquire report data from JTWC
@author:caiyunapp
"""

import time
from typhoon_grab import grab_typhoon_data
from datetime import date
from typhoon_grab import typhoon_db
today=date.today()
time_str = time.strftime("%Y%m%d%H")
count_grab=0
while True:
    seq_typhoon=1
    count_grab=count_grab+1
    if count_grab==48:
        typhoon_db.drop_collection('typhoon_collection')
        count_grab=0
    while seq_typhoon<=30:
        seq_wp = "wp%02d%02d" % (seq_typhoon, today.year%100)
        seq_ep = "ep%02d%02d" % (seq_typhoon, today.year%100)
        seq_cp = "cp%02d%02d" % (seq_typhoon, today.year%100)
        seq_sh = "sh%02d%02d" % (seq_typhoon, today.year%100)
        rslt_wp=grab_typhoon_data(seq_wp)
        rslt_ep=grab_typhoon_data(seq_ep)
        rslt_cp=grab_typhoon_data(seq_cp)
        rslt_sh=grab_typhoon_data(seq_sh)
        seq_typhoon=seq_typhoon+1
    print typhoon_db.typhoon_collection.count()
    time.sleep(1800)
