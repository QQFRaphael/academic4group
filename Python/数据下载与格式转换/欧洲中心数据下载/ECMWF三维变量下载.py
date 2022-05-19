#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
    
server = ECMWFDataServer()
    
for ii in range(1958,2002):
    server.retrieve({
        'stream'    : "moda",
        'levelist'  : "10/20/30/50/70/100/150/200/250/300/400/500/600/700/850/925/1000",
        'levtype'   : "pl",
        'param'     : "129.128/130.128/131.128/132.128/135.128/157.128",
        'dataset'   : "era40",
        'date'      : "%s0101/%s0201/%s0301/%s0401/%s0501/%s0601/%s0701/%s0801/%s0901/%s1001/%s1101/%s1201" % (str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii)),
        "step"      : "0",
        'type'      : "an",
        'class'     : "e4",
        "grid"      : "2.5/2.5",
        'format'    : "netcdf",
        'target'    : "%s.nc" % str(ii)
    })
