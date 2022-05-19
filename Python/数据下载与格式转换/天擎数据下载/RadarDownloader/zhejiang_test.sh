#!/bin/bash

source /public/software/profile.d/utils_anacoda2-env.sh
export TZ=UTC

#starttime=$(date -d "6 minute ago" +%Y%m%d%H%M%S)
#endtime=$(date +%Y%m%d%H%M%S)

starttime=$(date -d '2022-03-14 00:00:00' +%Y%m%d%H%M%S)
endtime=$(date -d '2022-03-14 08:00:00' +%Y%m%d%H%M%S)

# Z9571 Z9040 Z9572 Z9570 Z9576 Z9574 Z9579 Z9578 Z9577 Z9580 
staids=Z9574
#/public/software/utils/anaconda2/bin/python /public/home/rmaps/data/zhejiang/Downloader/RadarDownloader/RadarDownloader.py --start=${starttime} --end=${endtime} --staids=${staids} --root=/public/home/rmaps/data/test_zhejiang/radar --log=/public/home/rmaps/data/test_zhejiang/radar/logs --tmp=/public/home/rmaps/data/test_zhejiang/radar/tmp
/public/software/utils/anaconda2/bin/python /public/home/rmaps/data/zhejiang/Downloader/RadarDownloader/RadarDownloader.py --start=${starttime} --end=${endtime} --staids=${staids} --root=/public/home/rmaps/qqf/mmm --log=/public/home/rmaps/qqf/mmm/logs --tmp=/public/home/rmaps/qqf/mmm/tmp --err=/public/home/rmaps/qqf/mmm/err

