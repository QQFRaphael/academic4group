import os
import numpy as np

ncols = 321
nrows = 161
years_start = 1979
years_end = 2017    # please use the year after true end year, if this year is 2016, please use 2017
years = years_end - years_start

days_of_month = [31,28,31,30,31,30,31,31,30,31,30,31]

filedir = []
for ii in range(years_start,years_end):
    filedir.append("./snowdepth-%s" % str(ii))

data = np.zeros([years,12,31,nrows,ncols],np.float)
data = np.where(data==0.,-99999,data)

filelist = []
year_count = 0
for ii in filedir:
    filelist = os.listdir(ii)
    filelist.sort()
    for eachfile in filelist:
        print("reading %s/%s......" % (ii, eachfile))
        date = int(eachfile[4:7])
        with open("./%s/%s" % (ii, eachfile), "r") as snowfile:
            nl = 0
            for line in snowfile:
                nc = 0
                for each in line.split():
                    if nc < ncols:
                        if 1<=date<= 31:
                            data[year_count,0,date-1,nl,nc] = np.float(each)
                        elif 32<=date<=59:
                            data[year_count,1,date-32,nl,nc] = np.float(each)
                        elif 60<=date<=90:
                            data[year_count,2,date-60,nl,nc] = np.float(each)
                        elif 91<=date<=120:
                            data[year_count,3,date-91,nl,nc] = np.float(each)
                        elif 121<=date<=151:
                            data[year_count,4,date-121,nl,nc] = np.float(each)
                        elif 152<=date<=181:
                            data[year_count,5,date-152,nl,nc] = np.float(each)
                        elif 182<=date<=212:
                            data[year_count,6,date-182,nl,nc] = np.float(each)
                        elif 213<=date<=243:
                            data[year_count,7,date-213,nl,nc] = np.float(each)
                        elif 244<=date<=273:
                            data[year_count,8,date-244,nl,nc] = np.float(each)
                        elif 274<=date<=304:
                            data[year_count,9,date-274,nl,nc] = np.float(each)
                        elif 305<=date<=334:
                            data[year_count,10,date-305,nl,nc] = np.float(each)
                        elif 335<=date<=365:
                            data[year_count,11,date-335,nl,nc] = np.float(each)
                        nc = nc + 1
                nl = nl + 1
    year_count = year_count + 1


# index of each day
# 01    02    03    04     05      06      07      08      09      10      11      12
# 31    28    31    30     31      30      31      31      30      31      30      31
# 1-31  32-59 60-90 91-120 121-151 152-181 182-212 213-243 244-273 274-304 305-334 335-365

#print(data)
#print(data[0,1,27,0,:])
#print(data[0,1,28,0,:])
#print(data[0,0,0,0,:])
#print(data[0,11,30,95,:])
#print(data[1,11,30,95,:])
#print(data[0,1,28,95,:])
#print(data[2,11,30,95,:])

lats = np.linspace(55,15,161)
lons = np.linspace(60,140,321)
mons = np.linspace(1,12,12)
days = np.linspace(1,31,31)

from netCDF4 import Dataset

dataset = Dataset('snowdepth.nc', 'w')
lat = dataset.createDimension('lat', 161)
lon = dataset.createDimension('lon', 321)
year = dataset.createDimension('year', years)
mon = dataset.createDimension('month', 12)
day = dataset.createDimension('day', 31)

ncdata = dataset.createVariable('snowdepth', np.float64, ('year','month','day','lat','lon'), fill_value=-99999)
ncyear = dataset.createVariable('year', np.float64, ('year',))
ncmonth = dataset.createVariable('month', np.float64, ('month',))
ncday = dataset.createVariable('day', np.float64, ('day',))
nclatitudes = dataset.createVariable('lat', np.float64, ('lat',))
nclongitudes = dataset.createVariable('lon', np.float64, ('lon',))

nclatitudes.units = 'degree_north'
nclongitudes.units = 'degree_east'
ncyear.description = 'year from 1979 to %s' % str(years_end-1)
ncmonth.description = "month from Jan to Dec, each month has 31 days"
ncday.description = "days from 1st to 31th"
ncdata.description = "snowdepth of each day in China since 1979-01-01 to %s-12-31" % str(years_end-1)
ncdata.units= "cm"
ncdata.missing_value = -99999

dataset.description = 'daily snowdepth of China from 1979 to %s' % str(years_end-1)

ncdata[:] = data
ncyear[:] = np.linspace(years_start,years_end-1,years)
ncmonth[:] = mons
ncday[:] = days
nclatitudes[:] = lats
nclongitudes[:] = lons

