#script originally by Da pan (2018), heavily modified and expanded by Dennis Larsosn (2020)
#crops all layers for the bioclimatic variable set wc2.1_2.5m_bio and cclgmbi_2.5m, and rescales the LGM layer.

require("raster")

workdir <- "/path/to/WorkDirectory" # The directory where you want to work (the script will create folders and files here)
CurClimDir <- "/path/to/wc2.1_2.5m_bio/" # the folder where the bioclim variables for present are
LgmClimDir <- "/path/to/cclgmbi_2.5m/" # the folder where the bioclim variables for lgm are

range = as(extent(-11, 32, 36, 56),'SpatialPolygons') # These are the longitudes and latitudes that the map will be cropped (W E S N)

crs(range) <- "+proj=longlat +datum=WGS84 +no_defs"
dir.create(paste(workdir, '/cropped_now', sep=""))
setwd(paste(workdir, '/cropped_now', sep=""))
bioclim_world <- stack(list.files(CurClimDir, pattern = "wc2.1_2.5m_bio_", full.names = T), RAT = FALSE)
bioclim_eur <- crop(bioclim_world, range)
i=1
while (i < 20) {
  writeRaster(subset(bioclim_eur,i), paste('bio',i, sep=""), format = 'GTiff')
  #print(names(bioclim_eur)[i])
  print(paste("finished writing now layer",i))
  i=i+1
}

plot(bioclim_eur[[1]])

dir.create(paste(workdir,'/cropped_lgm',sep=""))
setwd(paste(workdir,'/cropped_lgm',sep=""))
bioclim_world_lgm <- stack(list.files(LgmClimDir, pattern = "cclgmbi", full.names = T), RAT = FALSE)
bioclim_eur_lgm <- crop(bioclim_world_lgm, range)

rescale = function (i){
  a = read.table(i, header = F, skip = 6)
  c = read.table(i, header = F, nrow=2)
  d = read.table(i, header = F, nrow=6)
  ii = 1 
  while (ii <= c[2,2]){
    iii = 1
    while (iii <= c[1,2]){
      if (a[ii,iii] > -8000){
        a[ii,iii] =  a[ii,iii]/10
      }
      iii = iii +1
    }
    ii = ii +1
  }
  ## write out put in ascii format
  write.table(d, file = paste('rescale_', i , sep = ''), col.names = F, row.names = F, quote = F)
  write.table(a, file = paste('rescale_', i , sep = ''), col.names = F, row.names = F, append = T)
  
}

i=1
while (i < 20) {
  if (i==1||i==2||i==4||i==5||i==6||i==7||i==8||i==9||i==10||i==11) {
    writeRaster(subset(bioclim_eur_lgm,i), file = paste('bio',i,'.asc', sep=""), format = 'ascii')
    rescale(paste('bio',i,'.asc', sep=""))
    bio <- raster(paste('rescale_bio',i,'.asc', sep=""))
    crs(bio) <- "+proj=longlat +datum=WGS84 +no_defs"
    writeRaster(bio, paste('bio',i,'.tif', sep=""), format = 'GTiff')
    #print(names(bioclim_eur_lgm)[i])
    print(paste("finished rescaling and writing lgm layer",i))
  }
  else {
    writeRaster(subset(bioclim_eur_lgm,i), paste('bio',i, sep=""), format = 'GTiff')
    print(paste("finished writing lgm layer",i))
  }
  
  i=i+1
}

plot(bioclim_eur_lgm[[1]])

