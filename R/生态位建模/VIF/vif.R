library(usdm)
library(raster)

setwd('.')

case <- 'current'

bioclim_case <- 
  raster::stack(
    c(
      bio_1 = paste('../data/',case,'/bio_1.asc', sep=""),
      bio_2 = paste('../data/',case,'/bio_2.asc', sep=""),
      bio_3 = paste('../data/',case,'/bio_3.asc', sep=""),
      bio_4 = paste('../data/',case,'/bio_4.asc', sep=""),
      bio_5 = paste('../data/',case,'/bio_5.asc', sep=""),
      bio_6 = paste('../data/',case,'/bio_6.asc', sep=""),
      bio_7 = paste('../data/',case,'/bio_7.asc', sep=""),
      bio_8 = paste('../data/',case,'/bio_8.asc', sep=""),
      bio_9 = paste('../data/',case,'/bio_9.asc', sep=""),
      bio_10 = paste('../data/',case,'/bio_10.asc', sep=""),
      bio_11 = paste('../data/',case,'/bio_11.asc', sep=""),
      bio_12 = paste('../data/',case,'/bio_12.asc', sep=""),
      bio_13 = paste('../data/',case,'/bio_13.asc', sep=""),
      bio_14 = paste('../data/',case,'/bio_14.asc', sep=""),
      bio_15 = paste('../data/',case,'/bio_15.asc', sep=""),
      bio_16 = paste('../data/',case,'/bio_16.asc', sep=""),
      bio_17 = paste('../data/',case,'/bio_17.asc', sep=""),
      bio_18 = paste('../data/',case,'/bio_18.asc', sep=""),
      bio_19 = paste('../data/',case,'/bio_19.asc', sep=""),
      elev = paste('../data/',case,'/elev.asc', sep="")
    )
  )

vifstep(bioclim_case)
