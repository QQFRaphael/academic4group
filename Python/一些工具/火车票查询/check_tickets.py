# -*- coding: UTF-8 -*-
import sys
import json
import requests

class CheckTicket:

    def __init__(self, FROM, TO, TIME):
        self.FROM = FROM
        self.TO = TO
        self.TIME = TIME
        self.station_train_code = []
        self.from_station_name = []
        self.to_station_name = []
        self.start_time = []
        self.arrive_time = []
        self.lishi = []
        self.seatsnum = []
        self.price = []
        self.url_ticket = ""

    def url_creater(self):
        self.url_ticket = "https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=" + self.TIME + "&leftTicketDTO.from_station=" + self.FROM + "&leftTicketDTO.to_station=" + self.TO + "&purpose_codes=ADULT"

    def get_info(self):
        r = requests.get(self.url_ticket, verify=False)
        info_json = json.loads(r.text)
        info = info_json['data']
        for train_data in info:
            train = train_data['queryLeftNewDTO']
            self.station_train_code.append(train['station_train_code'])
            self.from_station_name.append(train['from_station_name'])
            self.to_station_name.append(train['to_station_name'])
            self.start_time.append(train['start_time'])
            self.arrive_time.append(train['arrive_time'])
            self.lishi.append(train['lishi'])
            self.seatsnum.append([train['swz_num'], train['tz_num'], train['zy_num'], train['ze_num'], train['gr_num'], train['rw_num'], train['yw_num'], train['rz_num'], train['yz_num'], train['wz_num'], train['qt_num']])

    def write_out(self, location):
        reload(sys)
        sys.setdefaultencoding('utf-8')
        with open(location + "/tickets.txt", "w") as ticket_info:
            ticket_info.write("%4s   %3s-%3s   %5s-%5s=%5s   %2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s \n" % ("车次", "始发站", "终点站", "发车时", "到站时", "历时", "商务", "特等", "一等", "二等", "高软", "软卧", "硬卧", "软座", "硬座", "无座", "其它"))
            for ii in range(len(self.station_train_code)):
                ticket_info.write("%4s   %3s-%3s   %5s-%5s=%5s   %2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s/%2s \n" % (self.station_train_code[ii], self.from_station_name[ii], self.to_station_name[ii], self.start_time[ii], self.arrive_time[ii], self.lishi[ii], self.seatsnum[ii][0], self.seatsnum[ii][1], self.seatsnum[ii][2], self.seatsnum[ii][3], self.seatsnum[ii][4], self.seatsnum[ii][5], self.seatsnum[ii][6], self.seatsnum[ii][7], self.seatsnum[ii][8], self.seatsnum[ii][9], self.seatsnum[ii][10]))

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='check tickets:')
    parser.add_argument('--time', '-t', type=str, default='2017-01-01', help='like 2017-01-01')
    parser.add_argument('--destiny', '-d', type=str, default='HZH', help='like HZH')
    parser.add_argument('--start', '-s', type=str, default='BJP', help='like BJP')
    parser.add_argument('--out', '-o', type=str, default='./', help='location for output file, like ./')

    args = parser.parse_args()
    FROM = args.start
    TO = args.destiny
    TIME = args.time
    location = args.out

    rr = CheckTicket(FROM, TO, TIME)
    rr.url_creater()
    rr.get_info()
    rr.write_out(location)
