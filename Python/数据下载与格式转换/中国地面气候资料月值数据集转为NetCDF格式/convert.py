import os
import numpy as np

provinces = os.listdir("./precip")
provinces.sort()

year_start = 1979
year_end = 2016

nyear = year_end - year_start + 1
nstation = 756

data = np.zeros([nyear,12,nstation])
data = np.where(data==0.,-99999,data)

station_info = []
station_count = -1
station_previous_record = ""

# get station location

import xlrd

ExcelFile = xlrd.open_workbook(r'station.xlsx')
sheet = ExcelFile.sheet_by_name('Sheet1')

num = sheet.col_values(0)[3:]
lat = sheet.col_values(3)[3:]
lon = sheet.col_values(4)[3:]
print(len(lat))
print(len(lon))
lat_info = []
lon_info = []

# reading...

for each_province in provinces:
    print("reading %s......" % each_province)
    with open("./precip/%s" % each_province, "r") as precipfile:
        for line in precipfile:
            str_data = line.split()
            mon = int(str_data[0])
            station = int(str_data[1])
            year = int(str_data[2])
            pre = float(str_data[3])

            if station != station_previous_record and float(station) in num:
                station_info.append(station)
                idx = num.index(float(station))
                lat_info.append(lat[idx])
                lon_info.append(lon[idx])
                station_count = station_count + 1

            data[year-1979,mon-1,station_count] = pre

            station_previous_record = station

# remove duplicate station numbers

l2 = []
l3 = []
l4 = []
[l2.append(i) for i in station_info if not i in l2] 
[l3.append(lat[num.index(i)]) for i in station_info]
[l4.append(lon[num.index(i)]) for i in station_info]
#print(len(l2))
#print(len(l3))
#print(len(l4))

# convert unit

data = data * 0.1
l3 = np.array(l3) / 100.
l4 = np.array(l4) / 100.

# write to nc file...

from netCDF4 import Dataset

dataset = Dataset('monthly_precipitation.nc', 'w')
dlat = dataset.createDimension('lat', nstation)
dlon = dataset.createDimension('lon', nstation)
dyear = dataset.createDimension('year', nyear)
dmon = dataset.createDimension('month', 12) 
dsta = dataset.createDimension('station', nstation)

ncdata = dataset.createVariable('precipitation', np.float64, ('year','month','station'))
ncyear = dataset.createVariable('year', np.float64, ('year',))
ncmonth = dataset.createVariable('month', np.float64, ('month',))
nclatitudes = dataset.createVariable('lat', np.float64, ('lat',))
nclongitudes = dataset.createVariable('lon', np.float64, ('lon',))
ncstation = dataset.createVariable('station', np.float64, ('station',))

nclatitudes.units = 'degree_north'
nclongitudes.units = 'degree_east'
ncyear.description = 'year from 1979 to %s' % str(year_end)
ncmonth.description = "month from Jan to Dec, each month has 31 days"
ncstation.description = "location of weather stations"

ncdata.description = "precipitation of each month in 756 Chinese weather stations since 1979 to %s" % str(year_end)
ncdata.units= "mm"

dataset.description = 'monthly precipitation of 756 Chinese weather stations from 1979 to %s' % str(year_end)
dataset.FillValue = -99999

ncdata[:] = data
ncyear[:] = np.linspace(year_start,year_end,nyear)
ncmonth[:] = [1,2,3,4,5,6,7,8,9,10,11,12]
nclatitudes[:] = l3
nclongitudes[:] = l4
ncstation[:] = l2


