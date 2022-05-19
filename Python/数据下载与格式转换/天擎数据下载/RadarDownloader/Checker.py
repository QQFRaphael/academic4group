#!/public/home/rmaps/qqf/soft/anaconda3/bin/python
import os
import time
import shutil
import logging
import argparse
from cinrad.io import StandardData

class Checker(object):
    def __init__(self, ScanTable):
        self.ScanTable = ScanTable
    
    def __call__(self, radarfile, logfile, errdir):
        LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
        if not os.path.exists(errdir): os.makedirs(errdir)
        logging.basicConfig(filename=logfile, level=logging.DEBUG, format=LOG_FORMAT)
        
        f = StandardData(radarfile)
        
        if f.task_name in self.ScanTable and len(f.el) == self.ScanTable[f.task_name]:
            logging.info("%s..........................................................OK" % radarfile)
        else:
            logging.error("%s is inconsistent with ScanTable, please check the file in %s" % (radarfile, errdir))
            shutil.move(radarfile, errdir)

parser = argparse.ArgumentParser(description="A brief check of radar data: python this.py --radarfile=Z_RADR_I_Z9574_20220314045912_O_DOR_SAD_CAP_FMT.bin.bz2")
parser.add_argument("--radarfile", type=str, default="Z_RADR_I_Z9574_20220314045912_O_DOR_SAD_CAP_FMT.bin.bz2", help="radar file name, e.g., Z_RADR_I_Z9574_20220314045912_O_DOR_SAD_CAP_FMT.bin.bz2")
parser.add_argument("--errordir", type=str, default="./err", help="dir to store radar files probably with errors")
parser.add_argument("--log", type=str, default="./log", help="print logs")

args = parser.parse_args()
radarfile = args.radarfile.split(',')
errdir = args.errordir
logfile = args.log

ScanTable = { 
'VCP32D': 7,
'VCP31D': 8,
'VCP21D': 11,
'VCP11D': 16,
'VCP12D': 17,
'VCP121D':20
}

checker = Checker(ScanTable)
for rfile in radarfile:
    checker(rfile, logfile, errdir)

