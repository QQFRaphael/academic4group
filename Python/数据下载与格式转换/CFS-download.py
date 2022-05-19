#!/bin/python3

import os

with open("filelist.txt","r") as f:
    for line in f:
        filename = "https://nomads.ncdc.noaa.gov/data/cfsr-rfl-mmda/" + line[2:-1]
        savedir = "/home/qqf/CFSv2/" + line[2:23]
        os.system("wget "+filename+" -P "+savedir)
        #print("wget "+filename+" -P "+savedir)
