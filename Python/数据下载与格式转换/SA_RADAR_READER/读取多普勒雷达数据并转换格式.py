# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import struct
import numpy as np
import os
from netCDF4 import Dataset

filenames=os.popen("ls /Users/QQF/Desktop/20140521/*").read().split("\n")
nfiles=len(filenames)
each_record_byte=2432
missing=-1E10

for ii in range(1):
    nrecords=int(os.popen("ls -l "+filenames[ii]+"|awk '{print $5}'").read())/each_record_byte
    f=open(filenames[ii],"rb")
    ##########################设定读取数据的数组##########################
    unused=[]                                                                                   #保留
    Message_Type=[]                                                                             #1-表示雷达数据
    radical_collect_time=[]                                                                     #径向数据收集时间(毫秒,自 00:00 开始)
    radical_collect_date=[]                                                                     #儒略日(Julian)表示,自 1970 年 1 月 1 日开始
    unambiguousRange=[]                                                                         #不模糊距离(表示:数值/10.=千米)
    AzimuthAngle=[]                                                                             #方位角(编码方式:[数值/8.]*[180./4096.]=度)
    DataNumber=[]                                                                               #当前仰角内径向数据序号
    DataStatus=[]                                                                               #径向数据状态 0:该仰角的第一条径向数据
                                                                                                #           1:该仰角中间的径向数据
                                                                                                #           2:该仰角的最后一条径向数据
                                                                                                #           3:体扫开始的第一条径向数据
                                                                                                #           4:体扫结束的最后一条径向数据
    ElevationAngle=[]                                                                           #仰角 (编码方式:[数值/8.]*[180./4096.]=度)
    ElevationNumber=[]                                                                          #体扫内的仰角数
    FirstGateRangeOfRef=[]                                                                      #反射率数据的第一个距离库的实际距离(单位:米)
    FirstGateRangeOfDoppler=[]                                                                  #多普勒数据的第一个距离库的实际距离(单位:米)
    ReflectivityGateSize=[]                                                                     #反射率数据的距离库长(单位:米)
    DopplerGateSize=[]                                                                          #多普勒数据的距离库长(单位:米)
    ReflectivityGates=[]                                                                        #反射率的距离库数
    DopplerGates=[]                                                                             #多普勒的距离库数
    radicalnumber=[]                                                                            #扇区号
    coefofsys=[]                                                                                #系统订正常数
    RefPointer=[]                                                                               #反射率数据指针(偏离雷达数据信息头的字节数) 表示第一个反射率数据的位置
    VelPointer=[]                                                                               #速度数据指针(偏离雷达数据信息头的字节数),表示第一个速度数据的位置
    SWPointer=[]                                                                                #谱宽数据指针(偏离雷达数据信息头的字节数),表示第一个谱宽数据的位置
    VelResolution=[]                                                                            #多普勒速度分辨率。 2:表示 0.5 米/秒
                                                                                                #                4:表示 1.0 米/秒
    VCP=[]                                                                                      #体扫(VCP)模式 11:降水模式,16 层仰角
                                                                                                #             21:降水模式,14 层仰角
                                                                                                #             31:晴空模式,8 层仰角
                                                                                                #             32:晴空模式,7 层仰角
    RefPointerReplay=[]                                                                         #用于回放的反射率数据指针
    VelPointerReplay=[]                                                                         #用于回放的速度数据指针
    SWPointerReplay=[]                                                                          #用于回放的谱宽数据指针
    NyquistVelocity=[]                                                                          #Nyquist 速度(表示:数值/100. = 米/秒)
    dbz=[]                                                                                      #反射率
                                                                                                #距离库数:0-460 编码方式:(数值-2)/2.-32 = DBZ
                                                                                                #当数值为 0 时,表示无回波数 据(低于信噪比阀值)
                                                                                                #当数值为 1 时,表示距离模糊
    vel=[]                                                                                      #速度 距离库数:0-920 编码方式:
                                                                                                #分辨率为 0.5 米/秒时 (数值-2)/2.-63.5 = 米/秒
                                                                                                #分辨率为 1.0 米/秒时 (数值-2)-127 = 米/秒
                                                                                                #当数值为 0 或 1 时,意义同上
    SpectrlaWidth=[]                                                                            #谱宽 距离库数:0-920 编码方式:
                                                                                                #(数值-2)/2.-63.5 = 米/秒
                                                                                                #当数值为 0 或 1 时,意义同上
                                                                                                #说明: 1.数据的存储方式:每个体扫存储为一个单独的文件 
                                                                                                #     2.数据的排列方式:按照径向数据的方式顺序排列,对于 CINRAD SA/SB 雷达,体扫数据排列自低仰角开始到高仰角结束。
                                                                                                #     3.径向数据的长度:径向数据的长度固定,为 2432 字节
                                                                                                #     4.距离库长和库数:反射率距离库长为 1000 米,最大距离库数为 460; 速度和谱宽距离库长为 250 米,最大距离库数为 920
    ##########################开始读取与处理雷达数据##########################
    for jj in range(nrecords):
        unused.append(struct.unpack("14c",f.read(14)))
        Message_Type.append(struct.unpack("h",f.read(2)))
        unused.append(struct.unpack("12c",f.read(12)))
        radical_collect_time.append(struct.unpack("i",f.read(4)))
        radical_collect_date.append(struct.unpack("h",f.read(2)))
        unambiguousRange.append(int(struct.unpack("h",f.read(2))[0])/10.0)
        AzimuthAngle.append(int(struct.unpack("h",f.read(2))[0])/8.0*180.0/4096.0)
        DataNumber.append(struct.unpack("h",f.read(2)))
        DataStatus.append(struct.unpack("h",f.read(2)))
        ElevationAngle.append(int(struct.unpack("h",f.read(2))[0])/8.0*180.0/4096.0)
        ElevationNumber.append(struct.unpack("h",f.read(2)))
        FirstGateRangeOfRef.append(struct.unpack("h",f.read(2)))
        FirstGateRangeOfDoppler.append(struct.unpack("h",f.read(2)))
        ReflectivityGateSize.append(struct.unpack("h",f.read(2)))
        DopplerGateSize.append(struct.unpack("h",f.read(2)))
        ReflectivityGates.append(struct.unpack("h",f.read(2)))
        DopplerGates.append(struct.unpack("h",f.read(2)))
        radicalnumber.append(struct.unpack("h",f.read(2)))
        coefofsys.append(struct.unpack("i",f.read(4)))
        RefPointer.append(struct.unpack("h",f.read(2)))
        VelPointer.append(struct.unpack("h",f.read(2)))
        SWPointer.append(struct.unpack("h",f.read(2)))
        VelResolution.append(struct.unpack("h",f.read(2)))
        VCP.append(struct.unpack("h",f.read(2)))
        unused.append(struct.unpack("8c",f.read(8)))
        RefPointerReplay.append(struct.unpack("h",f.read(2)))
        VelPointerReplay.append(struct.unpack("h",f.read(2)))
        SWPointerReplay.append(struct.unpack("h",f.read(2)))
        NyquistVelocity.append(int(struct.unpack("h",f.read(2))[0])/100.0)
        unused.append(struct.unpack("38c",f.read(38)))
        for kk in range(460):
            tmp=struct.unpack("b",f.read(1))
            if tmp[0]==0 or tmp[0]==1:
                dbz.append(missing)
            else:
                dbz.append((tmp[0]-2)/2.0-32)
        for kk in range(920):
            tmp=struct.unpack("b",f.read(1))
            if tmp[0]==0 or tmp[0]==1:
                vel.append(missing)
            else:
                if VelResolution[0]==2:
                    vel.append((tmp[0]-2)/2.0-63.5)
                else:
                    vel.append((tmp[0]-2)-127.0)
        for kk in range(920):
            tmp=struct.unpack("b",f.read(1))
            if tmp[0]==0 or tmp[0]==1:
                SpectrlaWidth.append(missing)
            else:
                SpectrlaWidth.append((tmp[0]-2)/2.0-63.5)
    dbz_tmp=np.array(dbz)
    DBZ_out=dbz_tmp.reshape((nrecords,460))
    vel_tmp=np.array(vel)
    VEL_out=vel_tmp.reshape((nrecords,920))
    SpectrlaWidth_tmp=np.array(SpectrlaWidth)
    SPECTRALWIDTH_out=SpectrlaWidth_tmp.reshape((nrecords,920))
    ##########################写出为NetCDF格式##########################
    #创建文件
    output=Dataset(filenames[ii]+".nc", 'w', format='NETCDF4')
    #文件描述
    output.description = 'CINRAD SA/SB Doppler Radar Data'
    #创建维度
    output.createDimension('bin01', None)
    output.createDimension('bin02', None)
    output.createDimension('nrecords', nrecords)
    #创建并写出变量
    MESSAGE_TYPE=output.createVariable('Message_Type', 'i', ('nrecords',))
    MESSAGE_TYPE[:]=Message_Type
    MESSAGE_TYPE.standard_name="1-means radar data"

    RADICAL_COLLECT_TIME=output.createVariable('radical_collect_time', 'i', ('nrecords',))
    RADICAL_COLLECT_TIME[:]=radical_collect_time
    RADICAL_COLLECT_TIME.standard_name="radical collect time, from 00:00, units: ms"

    RADICAL_COLLECT_DATE=output.createVariable('radical_collect_date', 'i', ('nrecords',))
    RADICAL_COLLECT_DATE[:]=radical_collect_date
    RADICAL_COLLECT_DATE.standard_name="Julian calendar, from 1970.01.01"

    UNAMBIGUOUS=output.createVariable('unambiguousRange', 'i', ('nrecords',))
    UNAMBIGUOUS[:]=unambiguousRange
    UNAMBIGUOUS.standard_name="unambiguous range"
    UNAMBIGUOUS.units="km"

    AZIMUTHANGLE=output.createVariable('AzimuthAngle', 'i', ('nrecords',))
    AZIMUTHANGLE[:]=AzimuthAngle
    AZIMUTHANGLE.standard_name="azimuth angle"
    AZIMUTHANGLE.units="degree"

    DATANUMBER=output.createVariable('DataNumber', 'i', ('nrecords',))
    DATANUMBER[:]=DataNumber
    DATANUMBER.standard_name="Data Number: present azimuth angle data number"

    DATASTATUS=output.createVariable('DataStatus', 'i', ('nrecords',))
    DATASTATUS[:]=DataStatus
    DATASTATUS.standard_name="Data Status: 0-first data of present azimuth angle; 1-middle data of present azimuth angle; 2-last data of present azimuth angle; 3-first data of scanning; 4-last data of scanning"

    ELEVATIONANGLE=output.createVariable('ElevationAngle', 'i', ('nrecords',))
    ELEVATIONANGLE[:]=ElevationAngle
    ELEVATIONANGLE.standard_name="Elevation Angle"
    ELEVATIONANGLE.units="degree"

    ELEVATIONNUMBER=output.createVariable('ElevationNumber', 'i', ('nrecords',))
    ELEVATIONNUMBER[:]=ElevationNumber
    ELEVATIONNUMBER.standard_name="Elevation Number"

    FIRSTGATERANGEOFREF=output.createVariable('FirstGateRangeOfRef', 'i', ('nrecords',))
    FIRSTGATERANGEOFREF[:]=FirstGateRangeOfRef
    FIRSTGATERANGEOFREF.standard_name="First Gate Range Of reflectivity"
    FIRSTGATERANGEOFREF.units="m"

    FIRSTGATERANGEOFDOPPLER=output.createVariable('FirstGateRangeOfDoppler', 'i', ('nrecords',))
    FIRSTGATERANGEOFDOPPLER[:]=FirstGateRangeOfDoppler
    FIRSTGATERANGEOFDOPPLER.standard_name="First Gate Range Of Doppler"
    FIRSTGATERANGEOFDOPPLER.units="m"

    REFLECTIVITYGATESIZE=output.createVariable('ReflectivityGateSize', 'i', ('nrecords',))
    REFLECTIVITYGATESIZE[:]=ReflectivityGateSize
    REFLECTIVITYGATESIZE.standard_name="Reflectivity Gate Size"
    REFLECTIVITYGATESIZE.units="m"

    DOPPLERGATESIZE=output.createVariable('DopplerGateSize', 'i', ('nrecords',))
    DOPPLERGATESIZE[:]=DopplerGateSize
    DOPPLERGATESIZE.standard_name="Doppler Gate Size"
    DOPPLERGATESIZE.units="m"

    REFLECTIVITYGATES=output.createVariable('ReflectivityGates', 'i', ('nrecords',))
    REFLECTIVITYGATES[:]=ReflectivityGates
    REFLECTIVITYGATES.standard_name="Reflectivity Gates"

    DOPPLERGATES=output.createVariable('DopplerGates', 'i', ('nrecords',))
    DOPPLERGATES[:]=DopplerGates
    DOPPLERGATES.standard_name="Doppler Gates"

    RADICALNUMBER=output.createVariable('radicalnumber', 'i', ('nrecords',))
    RADICALNUMBER[:]=radicalnumber
    RADICALNUMBER.standard_name="radical number"

    COEFOFSYS=output.createVariable('coefofsys', 'i', ('nrecords',))
    COEFOFSYS[:]=coefofsys
    COEFOFSYS.standard_name="coefficient of system"

    REFPOINTER=output.createVariable('RefPointer', 'i', ('nrecords',))
    REFPOINTER[:]=RefPointer
    REFPOINTER.standard_name="Reflectivity Pointer"

    VELPOINTER=output.createVariable('VelPointer', 'i', ('nrecords',))
    VELPOINTER[:]=VelPointer
    VELPOINTER.standard_name="Velocity Pointer"

    SWPOINTER=output.createVariable('SWPointer', 'i', ('nrecords',))
    SWPOINTER[:]=SWPointer
    SWPOINTER.standard_name="Spectral Width Pointer"

    VELRESOLUTION=output.createVariable('VelResolution', 'i', ('nrecords',))
    VELRESOLUTION[:]=VelResolution
    VELRESOLUTION.standard_name="Velocity Resolution"

    VCP_TYPE=output.createVariable('VCP', 'i', ('nrecords',))
    VCP_TYPE[:]=VCP
    VCP_TYPE.standard_name="VCP: 11-precipitation mode, 16 elevation angle; 21-precipitation mode, 14 elevation angle; 31-nonprecipitation mode, 8 elevation angle; 32-nonprecipitation mode, 7 elevation angle"

    REFPOINTERREPLAY=output.createVariable('RefPointerReplay', 'i', ('nrecords',))
    REFPOINTERREPLAY[:]=RefPointerReplay
    REFPOINTERREPLAY.standard_name="Reflectivity Pointer Replay"

    VELPOINTERREPLAY=output.createVariable('VelPointerReplay', 'i', ('nrecords',))
    VELPOINTERREPLAY[:]=VelPointerReplay
    VELPOINTERREPLAY.standard_name="Velocity Pointer Replay"

    SWPOINTERREPLAY=output.createVariable('SWPointerReplay', 'i', ('nrecords',))
    SWPOINTERREPLAY[:]=SWPointerReplay
    SWPOINTERREPLAY.standard_name="Spectral Width Pointer Replay"

    NYQUISTVELOCITY=output.createVariable('NyquistVelocity', 'i', ('nrecords',))
    NYQUISTVELOCITY[:]=NyquistVelocity
    NYQUISTVELOCITY.standard_name="Nyquist Velocity"
    NYQUISTVELOCITY.units="m/s"

    DBZ=output.createVariable('dbz', 'f8', ('nrecords','bin01'))
    DBZ[:]=DBZ_out
    DBZ.missing_value=missing
    DBZ.standard_name="radar reflectivity"

    VEL=output.createVariable('vel', 'f8', ('nrecords','bin02'))
    VEL[:]=VEL_out
    VEL.missing_value=missing
    VEL.standard_name="velocity"

    SW=output.createVariable('SpectrlaWidth', 'f8', ('nrecords','bin02'))
    SW[:]=SPECTRALWIDTH_out
    SW.missing_value=missing
    SW.standard_name="spectral width"
    
    output.close()
    ##########################清理内存##########################
    del unused
    del Message_Type
    del radical_collect_time
    del radical_collect_date
    del unambiguousRange
    del AzimuthAngle
    del DataNumber
    del DataStatus
    del ElevationAngle
    del ElevationNumber
    del FirstGateRangeOfRef
    del FirstGateRangeOfDoppler
    del ReflectivityGateSize
    del DopplerGateSize
    del ReflectivityGates
    del DopplerGates
    del radicalnumber
    del coefofsys
    del RefPointer
    del VelPointer
    del SWPointer
    del VelResolution
    del VCP
    del RefPointerReplay
    del VelPointerReplay
    del SWPointerReplay
    del NyquistVelocity
    del dbz
    del vel
    del SpectrlaWidth
    del tmp
    del dbz_tmp
    del DBZ_out
    del vel_tmp
    del VEL_out
    del SpectrlaWidth_tmp
    del SPECTRALWIDTH_out
    print filenames[ii]+" complete!" 

