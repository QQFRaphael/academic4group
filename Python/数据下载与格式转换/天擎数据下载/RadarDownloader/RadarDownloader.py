# coding=utf-8
# by QQF@2022-04-15
import os
import time
import shutil
import datetime
import argparse
import logging
from cma.music.DataQueryClient import DataQueryClient


# parse argument
parser = argparse.ArgumentParser(description="Download radar data, example: python this.py --root=./ --staids=Z9571 --start=20220413000000 --end=20220414000000")
parser.add_argument("--staids", type=str, default="Z9571", help="station ID, default Z9571")
parser.add_argument("--start", type=str, default="20220413000000", help="start time, default 20220413000000")
parser.add_argument("--end", type=str, default="20220414000000", help="end time, default 20220414000000")
parser.add_argument("--root", type=str, default="./data", help="data dir")
parser.add_argument("--log", type=str, default="./", help="log dir")
parser.add_argument("--tmp", type=str, default="./", help="tmp dir, put all downloaded files here before check duplicated files")
parser.add_argument("--err", type=str, default="./", help="error dir, put all files with errors here")

args = parser.parse_args()
staids = args.staids.split(',')
starttime = args.start
endtime = args.end
root = args.root
logs = args.log
tmpdir = args.tmp
errdir = args.err

# log info prepare
LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
if not os.path.exists(logs): os.makedirs(logs)
logname = "%s/radardownload.log.%s" % (logs, time.strftime("%Y%m%d"))
logging.basicConfig(filename=logname, level=logging.DEBUG, format=LOG_FORMAT)

# check start & end time
if datetime.datetime.strptime(starttime, "%Y%m%d%H%M%S") >= datetime.datetime.strptime(endtime, "%Y%m%d%H%M%S"): logging.error("please check your start and end time"); exit()

# check tmp&error dir
if not os.path.exists(tmpdir): os.makedirs(tmpdir)
if not os.path.exists(errdir): os.makedirs(errdir)

# set ID and password, initialize client
userId      = "USR_SUTAO"
pwd         = "Qks123456"
interfaceId = "getRadaFileByTimeRangeAndStaId"
serverId    = "NMIC_MUSIC_CMADAAS"
client      = DataQueryClient()

# download begin
for staid in staids:
    fileDir = "%s/%s" % (root, staid)
    
    if not os.path.exists(fileDir): os.makedirs(fileDir)
    
    params      = {'dataCode':"RADA_L2_FMT",
                    'elements':"Datetime,DATA_ID,FILE_SIZE,File_URL",\
                    'timeRange':"[" + starttime + "," + endtime + "]",\
                    'staIds':staid
                    }
                    
    logging.info("Args: --root=%s --staids=%s --start=%s --end=%s" % (root, staid, starttime, endtime))
    stime = time.time()
    result = client.callAPI_to_downFile(userId, pwd, interfaceId, params, tmpdir)
    etime = time.time()
    logging.info(result.request)
    logging.info("Download cost %fs" % (etime - stime))

    # remove duplicate files
    stime = time.time()
    files = [x.fileName for x in result.fileInfos]
    for file in files:
        if(os.path.exists("%s/%s" % (fileDir, file)) or os.path.exists("%s/%s" % (fileDir, file[0:51])) or os.path.exists("%s/%s" % (fileDir, file[0:50]))):
        # first, check *.bz2 file; second, check *.bin file; third, check *.bin file of Lishui SA radar
            os.remove("%s/%s" % (tmpdir, file))
        else:
            f1 = "%s/%s" % (tmpdir, file)
            f2 = "%s/%s" % (fileDir, file)
            if(os.path.exists(f1)):
                os.system("/public/home/rmaps/qqf/soft/anaconda3/bin/python /public/home/rmaps/data/zhejiang/Downloader/RadarDownloader/Checker.py --radarfile=%s --errordir=%s --log=%s" % (f1, errdir, logname))
                if(os.path.exists(f1)): shutil.move(f1, f2)
            else:
                logging.info("%s do not exist. Check download process. Do NOT download too much data one time." % f1)
    etime = time.time()
    logging.info("Delete duplicate files and check all files cost %fs" % (etime-stime))
    logging.info("===================================================================================================")
