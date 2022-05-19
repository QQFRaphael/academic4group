# coding=utf-8
# ========================================================================
# ========================================================================
#       Script Usage: 
#         Created by: ---------- Xianglin DAI ----------- 
#                              Ph.D. Candidate 
#                     School of Atmospheric Sciences 
#                     Email: lyniedairce@smail.nju.edu.cn 
#                     ----- Nanjing University ----- 
#                                                    
#  Records of Revisions:                             
#     Date      Programmer    Description of change    
#  ==========   ==========    =====================    
#  23/02/2022   Xianglin DAI        V.1.0                    
# ========================================================================
# |---------------------File Name: Skylar.py------------------------| 
import os
import numpy as np
import scipy as sp
import pandas as pd
import time
import sys
from cma.music.DataQueryClient import DataQueryClient
import netCDF4 as nc
from datetime import datetime,timedelta



class sky_request():
    def __init__(self, starttime, endtime, lcdir, sect):


        # CAUTIONS: THE `space` SHOULD NOT BE USED AS PREVIOUS
        # ESPECIALLY IN `params` WILL RISE THE ERROR:
        # 'ZeroDivisionError: integer division or modulo by zero'


        """
        An object that deals with sky_request 

        :param  starttime:  Longitude array in degree with dimension (*nlon*).
        :type   starttime:  sequence of array_like

        :param  endtime:    Latitutde array in degree, monotonically increasing with dimension (*nlat*)
        :type   endtime:    sequence of array_like

        :param  staids:     Pseudoheight array in meters, monotonically increasing with dimension (*nlev*)
        :type   staids:     sequence of array_like

        :param  lcdir:      Zonal wind field in meters, with dimension (*nlev*,*nlat*,*nlon*).
        :type   lcdir:      sequence of array_like

        """

        self.userId     = "USR_SUTAO"
        self.pwd        = "Qks123456"
        self.starttime  = starttime
        self.endtime    = endtime
        self.lcdir      = lcdir
        self.client     = DataQueryClient()
        self.minlat, self.minlon, self.maxlat, self.maxlon  = sect




    def get_radar_FileByTimeRange(self):

        self.staids = input()

        # 1. 定义client对象
        client      = DataQueryClient()
        #2. 调用方法的参数定义，并赋值
        # 2.1 用户名&密码
        userId      = self.userId
        pwd         = self.pwd
        # 2.2  接口ID
        interfaceId = "getRadaFileByTimeRangeAndStaId"
        # 2.3 服务节点ID
        serverId    = "NMIC_MUSIC_CMADAAS"
        #  2.4  接口参数，多个参数间无顺序
        # 必选参数(1)资料：质控前标准格式多普勒雷达基数据;(2)时间点;(3)下载文件数限制。
        params      = {'dataCode':"RADA_L2_FMT",\
                        'elements':"Datetime,DATA_ID,FILE_SIZE,File_URL",\
                        'timeRange':"[" + self.starttime + "," + self.endtime + ")",\
                        'staIds':self.staids,\
                        'limitCnt':"1000"
                        }
        # 可选参数
        #  2.5 文件的本地保持目录
        fileDir     = lcdir
        # 3. 调用接口
        #result = client.callAPI_to_fileList(userId, pwd, interfaceId,params,serverId)
        result      = client.callAPI_to_downFile(userId, pwd, interfaceId,params,fileDir)
        # 4. 输出结果
        print(result.request)
   


    
    def SURF_CHN_MUL_HOR_v1(self, elements):
    
        elements_           = [_.split(' ')[0] for _ in elements.split(',')]
        nc_names            = list([_.split(' ')[1] for _ in elements.split(',')])
        elements            = ','.join(elements_)
        #2. 调用方法的参数定义，并赋值
        # 2.1 用户名&密码 
        userId      = self.userId
        pwd         = self.pwd
        
        # 2.2  接口ID 
        interfaceId = "getSurfEleInRectByTime"
        
        # 2.3 服务节点ID
        serverId    = "NMIC_MUSIC_CMADAAS"
        
        #  2.4  接口参数，多个参数间无顺序 
        # 必选参数(1)资料：质控前原始格式多普勒雷达基数据;(2)时间点;(3)下载文件数限制
        
        # SURF_CHN_PRE_MIN: 中国地面分钟降水资料
        # SURF_CHN_MUL_MIN: 中国地面分钟数据
        starttime_      = self.starttime.strftime('%Y%m%d%H') + '0000'
        params      = { 'dataCode':     "SURF_CHN_MUL_HOR",\
                        'elements':     elements,\
                        'minLat':       self.minlat,\
                        'minLon':       self.minlon,\
                        'maxLat':       self.maxlat,\
                        'maxLon':       self.maxlon,\
                        'times':        starttime_ ,\
                        # 'limitCnt':     "10"
                        }
    
        # 可选参数
        #  2.5 文件的本地保持目录 
        #fileDir = "./"   
           
        # 3. 调用接口 
        result      = self.client.callAPI_to_array2D(userId, pwd, interfaceId,params,serverId) 
        
        # 4. 输出结果
        print(result.request)
        names   = nc_names + ['ww']
        if result.request.errorCode == 0:
#             return [nc_names, result.data]
            for i in range(len(result.data)):
                for j in range(len(names)):
                    try:
                        if result.data[i][j].isdigit():
                            if result.data[i][j] > u'9000':
                                result.data[i][j] = u'99999' 
                        else:
                            pass
                    except:
                        result.data[i].append(u'99999')
            return [names, result.data]
        else:
            return



    def SURF_CHN_MUL_HOR_v2(self):
    
        from collections import defaultdict
        #2. 调用方法的参数定义，并赋值
        # 2.1 用户名&密码 
        userId      = self.userId
        pwd         = self.pwd
        
        # 2.2  接口ID 
        interfaceId = "getSurfEleInRectByTimeRange"
        
        # 2.3 服务节点ID
        serverId    = "NMIC_MUSIC_CMADAAS"
        
        #  2.4  接口参数，多个参数间无顺序 
        # 必选参数(1)资料：质控前原始格式多普勒雷达基数据;(2)时间点;(3)下载文件数限制
        
        # SURF_CHN_PRE_MIN: 中国地面分钟降水资料
        # SURF_CHN_MUL_MIN: 中国地面分钟数据
        _           = self.starttime.strftime('%Y%m%d%H%M%S')
        starttime_  = (self.starttime - timedelta(hours=1)).strftime('%Y%m%d%H') + '0000' if _[-4:] == '0000' else self.starttime.strftime('%Y%m%d%H') + '0000'
        _           = self.starttime.strftime('%Y%m%d%H%M%S')
	print(starttime_, _)
        params      = { 'dataCode':     "SURF_CHN_MUL_MIN",\
                        'elements':     "Station_Id_C,PRE",\
                        'timeRange':    "(" + starttime_ + ',' + _ + "]",\
                        'minLat':       self.minlat,\
                        'minLon':       self.minlon,\
                        'maxLat':       self.maxlat,\
                        'maxLon':       self.maxlon,\
                        # 'limitCnt':     "10"
                        }
        # 3. 调用接口 
        result      = self.client.callAPI_to_array2D(userId, pwd, interfaceId,params,serverId) 

        names   = ['stid','pr1','ww']
        tstamp      = list([result.data[_][0] for _ in range(np.shape(result.data)[0])])
        r_tstamp    = sorted(tstamp)
        # serial      = list([result.data[_][1] for _ in range(np.shape(result.data)[0])]).replace(u'999999',np.nan)
        # serial      = np.array(serial)
        serial      = np.array(list([result.data[_][1] for _ in range(np.shape(result.data)[0])]), dtype=float)
        r_serial    = [x for _, x in sorted(zip(tstamp, serial), key=lambda pair: pair[0])]
        r_serial    = np.array([np.nan if _ >= 9999 else _ for _ in r_serial])
        # list([result.data[_][0] for _ in range(np.shape(result.data)[0])]))
        ts          = sorted(list(set(r_tstamp)))
        data        = [[],[],[]]
        flag        = 0
        for t in ts:
            data[0].append(t)
            i       = r_tstamp.count(t)
            _       = r_serial[flag:flag+i]
            if len(_[np.isnan(_)]) == len(_):
                data[1].append(u'9999')
            else:
                data[1].append(np.nansum(_))
            # print(_, np.nansum(_), np.nanprod(_))
            # try:
            #     data[1].append(np.nansum(_))
            # except:
            #     data[1].append(u'9999')
            data[2].append(u'9999')
            flag    = flag + i
        # for astation in astations:
        # print(data)
        return [names, list(map(list,zip(*data)))]


            



    def get_SurfEle_InRectByTimeRange(self,elements):

        elements_           = [_.split(' ')[0] for _ in elements.split(',')]
        nc_names            = list([_.split(' ')[1] for _ in elements.split(',')])
        elements            = ','.join(elements_)
        '''
        格点场要素获取（切块），返回RetGridArray2D对象
        '''
        
        # 2. 调用方法的参数定义，并赋值
        # 2.1 用户名&密码 
        userId      = self.userId
        pwd         = self.pwd
        
        # 2.2  接口ID 
        interfaceId = "getSurfEleInRectByTimeRange"
        
        # 2.3 服务节点ID
        serverId    = "NMIC_MUSIC_CMADAAS" 
        
        # 2.4  接口参数，多个参数间无顺序 
        # 必选参数(1)资料:中国地面逐小时资料; (2)检索要素：站号、站名、小时降水、气压、相对湿度、能见度、2分钟平均风速、2分钟风向; 
        #  (3)检索时间;(4)排序：按照站号从小到大;(5)返回最多记录数：10。
        starttime_      = self.starttime.strftime('%Y%m%d%H%M%S')
        _               = (self.starttime + timedelta(minutes = 1)).strftime('%Y%m%d%H%M%S')
        # sky.get_SurfEle_ByTime()
        params      = { 'dataCode':     "SURF_CHN_MUL_MIN",\
                        'elements':     elements, 
                        # "Lon,Lat,Datetime,Station_Id_C,",\
                        'timeRange':    "[" + starttime_ + "," + _ + ")",\
                        # 'timeRange':    "[20210601000000,20210601000100)",\
                        'minLat':       self.minlat,
                        'minLon':       self.minlon,
                        'maxLat':       self.maxlat,
                        'maxLon':       self.maxlon,
                        # 'orderby':      "Station_ID_C:ASC",\
                        'orderby':      "Datetime:ASC",\
                        # 'limitCnt':     "10",
                        }
        
        # 3. 调用接口
        #result = client.callAPI_to_array2D(userId, pwd, interfaceId, params)
        result      = self.client.callAPI_to_array2D(userId, pwd, interfaceId, params,serverId)
        
        # 4. 输出接口
        print ("return code: ",     result.request.errorCode)
        print ("return message: ",  result.request.errorMessage)
        # print ("return data: ",     result.data)
        if result.request.errorCode == 0:
#             return [nc_names, result.data]
            for i in range(len(result.data)):
                for j in range(len(nc_names)):
                    if result.data[i][j].isdigit():
                        if result.data[i][j] > u'9000':
                            result.data[i][j] = u'99999' 
                    else:
                        pass
            return [nc_names, result.data]
        else:
            return








    def combine(self, data1, data2):
        stations = []
        with open('/public/home/rmaps/data/zhejiang/Downloader/AWSDownloader/ZJ_StationInfo.txt','r') as f:
            while True:
                line = f.readline()
                if not line:
                    break
                stations.append(line.split()[0])
        name1, name2        = data1[0], data2[0]
        name                = list(set(name2) - set(name1))
        names               = name1 + name
        data1, data2        = data1[1], data2[1]
        n1,n2               = name1.index('stid'), name2.index('stid')
        stid1, stid2        = [data1[_][n1] for _ in range(len(data1))], [data2[_][n2] for _ in range(len(data2))]
        self.stations       = stations
        data                = []
        for i, station in enumerate(stations):
            line            = []
            if station in stid1:
                _   = data1[stid1.index(station)]
                line += _
            else:
                _               = ['99999'] * len(name1)
                _[n1]    = station
                line +=_

            if station in stid2:
                # print([name2.index(name[__]) for __ in range(len(name))])
                _   = [data2[stid2.index(station)][_] for _ in [name2.index(__) for __ in name]]
                line += _
            else:
                _               = ['99999'] * len(name)
                line += _
                # _[name.index('stid')]    = station
            data.append(line)
        return [names, data]










    def data2files(self, namelists, data, format):
        savedir = self.lcdir + '/' + self.starttime.strftime('%Y%m%d')
        if not os.path.exists(savedir):
            os.makedirs(savedir,mode=511)
        stations    = self.stations
        if format == 'txt':
            # save_file   = savedir + '/' + (self.starttime - timedelta(hours=8)).strftime('%Y%m%d%H%M%S') + '.txt'
            save_file   = savedir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.txt'
            save_file   = savedir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.txt' # DATATIME
            with open(save_file, 'w') as f:
                for namelist in namelists:
                    f.write(namelist)
                    f.write('  ')
                f.write('\n')
                for i in range(len(data)):
                    jointsFrame = data[i] #每行
                    for j in range(len(namelists)):
                        strNum  = str(jointsFrame[j].encode('utf-8')) # MODIFIED BY XLDAI IN 2022.02.28 9:48
                        f.write(strNum)
                        f.write('  ')
                    f.write('\n')
        elif format == 'nc':
            strlen      = 30
            # save_file   = savedir + '/' + (self.starttime - timedelta(hours=8)).strftime('%Y%m%d%H%M%S') + '.nc'
            save_file   = savedir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.nc'
            # save_file   = self.lcdir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.nc' # DATATIME
            ncfile      = nc.Dataset(save_file, 'w', format='NETCDF4')
            ncfile.createDimension('station',   len(data))
            ncfile.createDimension('time',      1)
            ncfile.createDimension('strlen',    strlen)
            for i,namelist in enumerate(namelists):
                print(namelist)
                # print(nc_names[i])
                # if namelists[i] == 'obs_time':
                #     continue
                if namelist in ['obs_time', 'wsxt','wsmt','taxt','tamt','rhmt','paxt','pamt']:
                    if namelist == 'obs_time':
                        # ncfile.createVariable(namelist, 'S1', ('time','strlen'))
                        ncfile.createVariable(namelist, 'S1', ('strlen'))
                        ncfile.variables[namelist][:]    = nc.stringtoarr(str(str(self.starttime.strftime('%Y-%m-%d %H:%M:%S') + ' UTC').ljust(strlen).encode('utf-8')), strlen, dtype='S') 
                    else:
                        # ncfile.createVariable(namelist, 'S1', ('station','time','strlen'))
                        ncfile.createVariable(namelist, 'S1', ('station','strlen'))
                        tmp = [nc.stringtoarr(str(str(data[_][i]).replace('.','').rjust(4,'0').encode('utf-8')), strlen, dtype='S') for _ in range(len(data))]
                        ncfile.variables[namelist][:]   = tmp[:]
                        
                elif namelist == 'sname':
                    # ncfile.createVariable(namelist, 'S1', ('station','time','strlen'))
                    ncfile.createVariable(namelist, 'S1', ('station','strlen'))
                    tmp     = [nc.stringtoarr(str('  '.encode('utf-8')), strlen, dtype='S') for _ in range(len(data))]
                    ncfile.variables[namelist][:]    = tmp[:]
                elif namelist in ['stid']:
                    # ncfile.createVariable(namelist, 'S1', ('station','time','strlen'))
                    ncfile.createVariable(namelist, 'S1', ('station','strlen'))
                    if namelist == 'stid':
                        O   = ['K','I','J','M','F']
                        R   = ['A','B','C','D','E']
                        tmp = [str(data[_][i]) for _ in range(len(data))]
                        tmp = [stations[_].replace(stations[_][0],R[O.index(stations[_][0])]) if stations[_][0] in O else stations[_] for _ in range(len(stations))]
                        tmp = [nc.stringtoarr(str(tmp[_].encode('utf-8')), strlen, dtype='S') for _ in range(len(data))]
                    else:

                        tmp = [nc.stringtoarr(str(data[_][i].encode('utf-8')), strlen, dtype='S') for _ in range(len(data))]
                    ncfile.variables[namelist][:]    = tmp[:]
                elif namelist in ['lat','lon','elev']:
                    ncfile.createVariable(namelist,np.float32,('station'))
                    tmp     = np.array([str(data[_][i].encode('utf-8')) for _ in range(len(data))],dtype=np.float32)
                    ncfile.variables[namelist][:]   = tmp[:].squeeze()
                else:
                    # ncfile.createVariable(namelist,np.float32,('station','time'))
                    ncfile.createVariable(namelist,np.float32,('station'))
                    try:
                        tmp     = np.array([str(data[_][i].encode('utf-8')) for _ in range(len(data))],dtype=np.float32)
                    except:
                        tmp     = np.array([data[_][i] for _ in range(len(data))],dtype=np.float32)
                    ncfile.variables[namelist][:]   = tmp[:]
            ncfile.close()

        elif format in ['csv','xlsx']:
            # data        = [list(data[i]) for i in range(len(data))]
            # save_file   = savedir + '/' + (self.starttime - timedelta(hours=8)).strftime('%Y%m%d%H%M%S') + '.' + format
            save_file   = savedir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.' + format
            # save_file   = self.lcdir + '/' + self.starttime.strftime('%Y%m%d%H%M%S') + '.' + format# DATATIME
            df          = pd.DataFrame(data, index=None, columns=namelists)
            print(df.head(5))
            df.to_csv(save_file, encoding='utf_8_sig') if format=='csv' else df.to_excel(save_file)

#             start           = start + timedelta(minutes=5)



        
    
   



def main():

    # string variables
    format              = str(raw_input('INPUT THE OUTFILE FORMAT (txt,nc,csv,xlsx):\n'))
    starttime,endtime   = map(str,input('INPUT THE START TIME AND END TIME WITH `,` SPLITTING: \n'))
    lcdir               = str(raw_input('INPUT THE SAVE PATH: \n'))
    minlat, minlon, maxlat, maxlon  = map(str, input('THE RECT BY `south`,`west`,`north`,`east`: \n'))
    elements_minuts     = str(raw_input('INPUT THE MINUTS ELEMENTS YOU WANT TO DOWNLOAD: \n'))
    elements_hours      = str(raw_input('INPUT THE HOURLY ELEMENTS YOU WANT TO DOWNLOAD: \n'))
    if not os.path.exists(lcdir):
        os.makedirs(lcdir,mode=511)

    # print(starttime,endtime,lcdir)
    sect                = [minlat, minlon, maxlat, maxlon]

    start               = datetime.strptime(starttime,'%Y%m%d%H%M%S')
    end                 = datetime.strptime(endtime,'%Y%m%d%H%M%S')
    while start < end:
        sky             = sky_request(starttime=start, endtime=end, lcdir=lcdir, sect=sect)
        data1           = sky.get_SurfEle_InRectByTimeRange(elements=elements_minuts)
        # data2           = sky.SURF_CHN_MUL_HOR_v(elements=elements_hours)
        data2           = sky.SURF_CHN_MUL_HOR_v2()
        namelists, data = sky.combine(data1,data2)
        sky.data2files(namelists, data, format=format)
        start           = start + timedelta(minutes=5)

        # break # FOR TESTING A SINGLE FILE


if __name__ =="__main__":

    main()


