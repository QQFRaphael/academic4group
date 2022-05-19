#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
    
server = ECMWFDataServer()
    
for ii in range(1958,2002):
    server.retrieve({
        'stream'    : "moda",
        'levtype'   : "SFC",
        'param'     : "151.128/165.128/166.128/167.128",
        'dataset'   : "era40",
        'date'      : "%s0101/%s0201/%s0301/%s0401/%s0501/%s0601/%s0701/%s0801/%s0901/%s1001/%s1101/%s1201" % (str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii),str(ii)),
        "step"      : "0",
        'type'      : "an",
        'class'     : "e4",
        "grid"      : "2.5/2.5",
        'format'    : "netcdf",
        'target'    : "%s.nc" % str(ii)
    })
