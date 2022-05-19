load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./interannual.ncl"
load "./decadal.ncl"



ts2 = asciiread("../EOF-1979-2010/ts2.txt", 32, "float")
ts3 = asciiread("../EOF-1979-2010/ts3.txt", 32, "float")


ts_H = asciiread("PC2-Atlantic.txt",32,"float")
ts_I = asciiread("PC3-Pacific.txt",32,"float")

ts_H_inter = ts_H
ts_H_dec = ts_H
ts_I_inter = ts_I
ts_I_dec = ts_I
ts2_inter = ts2
ts2_dec = ts2
ts3_inter = ts3
ts3_dec = ts3

ts_H_inter = 0.0
ts_H_dec = 0.0
ts_I_inter = 0.0
ts_I_dec = 0.0
ts2_inter = 0.0
ts2_dec = 0.0
ts3_inter = 0.0
ts3_dec = 0.0


interannual(ts_H,ts_H_inter,32) 
decadal(ts_H,ts_H_dec,32) 
interannual(ts_I,ts_I_inter,32) 
decadal(ts_I,ts_I_dec,32) 
interannual(ts2,ts2_inter,32) 
decadal(ts2,ts2_dec,32) 
interannual(ts3,ts3_inter,32) 
decadal(ts3,ts3_dec,32) 

print("ts_H: " +escorc_n(ts2,ts_H, 0, 0))
print("ts_I: " +escorc_n(ts3,ts_I, 0, 0))
print("ts_H_inter: " +escorc_n(ts2_inter,ts_H_inter, 0, 0))
print("ts_H_dec: " +escorc_n(ts2_dec,ts_H_dec, 0, 0))
print("ts_I_inter: " +escorc_n(ts3_inter,ts_I_inter, 0, 0))
print("ts_I_dec: " +escorc_n(ts3_dec,ts_I_dec, 0, 0))

