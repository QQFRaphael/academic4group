#!/bin/bash

source /public/software/profile.d/utils_anacoda2-env.sh
export TZ=UTC

starttime=$(date -d "6 minute ago" +%Y%m%d%H%M%S)
endtime=$(date +%Y%m%d%H%M%S)

#starttime=$(date -d '2022-04-13 00:30:00' +%Y%m%d%H%M%S)
#endtime=$(date -d '2022-04-13 02:00:00' +%Y%m%d%H%M%S)

/public/software/utils/anaconda2/bin/python /public/home/rmaps/data/zhejiang/Downloader/RadarDownloader/RadarDownloader.py --start=${starttime} --end=${endtime} --staids=Z9571,Z9040,Z9572,Z9570,Z9576,Z9574,Z9579,Z9578,Z9577,Z9580  --root=/public/home/rmaps/data/zhejiang/raw/radar --log=/public/home/rmaps/data/zhejiang/Downloader/logs --tmp=/public/home/rmaps/data/zhejiang/Downloader/RadarDownloader/tmp --err=/public/home/rmaps/data/zhejiang/raw/radar/err

