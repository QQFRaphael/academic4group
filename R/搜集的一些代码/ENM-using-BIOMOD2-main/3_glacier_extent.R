library('raster')
library('rgdal')


#RESTART RSTUDIO IF THE shp2raster FUNCTION CRASHES!!!!!


setwd('/path/to/WorkDirectory/modelling_result')

inp="Porbiculare_lgm_ROC"

lgm_glacier = readOGR("/path/to/lgm/", "lgm")
alps_glacier =readOGR("/path/to/lgm_alpen/", "lgm_alpen")

shp2raster <- function(shp, mask.raster, label, value, transform = FALSE, proj.from = NA, proj.to = NA, map = TRUE) {
  require(raster, rgdal)
  
  # use transform==TRUE if the polygon is not in the same coordinate system as
  # the output raster, setting proj.from & proj.to to the appropriate
  # projections
  if (transform == TRUE) {
    proj4string(shp) <- proj.from
    shp <- spTransform(shp, proj.to)
  }
  
  # convert the shapefile to a raster based on a standardised background
  # raster
  r <- rasterize(shp, mask.raster)
  # set the cells associated with the shapfile to the specified value
  r[!is.na(r)] <- value
  # merge the new raster with the mask raster and export to the working
  # directory as a tif file
  r <- mask(merge(r, mask.raster), mask.raster, filename = label, format = "GTiff",
            overwrite = T)
  
  # plot map of new raster
  if (map == TRUE) {
    plot(r, main = label, axes = F, box = F)
  }
  
  names(r) <- label
  return(r)
}

inpf=paste(inp,".asc",sep="")
lgm = raster(inpf)

alps_glacier_raster <- shp2raster(shp = lgm_glacier, mask.raster = lgm, label = "lgm", transform = FALSE, value = 0)
alps_glacier_raster2 <- shp2raster(shp = alps_glacier, mask.raster = alps_glacier_raster, label = "lgm", transform = FALSE, value = 0)

## Found 1 region(s) and 97 polygon(s)


writeRaster(alps_glacier_raster2, file = paste(inp,"_gla.asc",sep=""), format ='ascii')

map <- raster(paste(inp,"_gla.asc",sep=""))
pdf(file = "EnsembleHabitatSuitabilityIcesheet.pdf", title = "EnsembleHabitatSuitabilityIcesheet")
plot(map, main = "Ensemble habitat suitability LGM with ice sheet")
dev.off()