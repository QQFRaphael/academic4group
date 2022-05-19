import os
import threading
import time

district = ["haidian", "chaoyang", "dongchenga", "fengtai", "xicheng", "chongwen", "xuanwu", "shijingshan", "changping", "tongzhou", "daxing", "shunyi", "huairou", "fangshan", "mentougou", "miyun", "pinggua", "yanqing", "yanjiao"]

# example url: http://beijing.anjuke.com/sale/shunyi/p3/#filtersort
url_base = "http://beijing.anjuke.com/sale/"

class MyThread(threading.Thread):
    def __init__(self, target, args):
        super(MyThread, self).__init__() 
        self.target = target
        self.args = args

    def run(self) :
        self.target(self.args)

def fuck_houses(args):
    for ii in range(1, 51):
        url = url_base + args + "/p" + str(ii) + "/#filtersort"
        os.system("w3m " + url + " > ./raw/" + args + "." + str(ii))
        time.sleep(1)
    print args + " complete!"

def main():
    mythread = []
    for ii in district:
        mythread.append(MyThread(fuck_houses, ii))
    for ii in mythread:
        ii.start()
    for ii in mythread:
        ii.join()
    print "all tasks complete!!!"

if __name__ == '__main__':
    main()