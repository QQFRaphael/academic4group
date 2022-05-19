# script written by Dennis Larsson (2020) to subsamples coordinates to ensure that only one coordinate per cell is present.

library(raster)
setwd("/path/to/workDirectory/")

my.grid <- raster("/path/to/workDirectory/cropped_now/bio1.tif")
my.coords <- read.csv("coords.csv")
outputfile <- "coords_CellFiltered.csv"

plot(my.grid)
points(my.coords[3:2])

my.cells <- cellFromXY(object=my.grid, xy = my.coords[3:2])
#write(my.cells,"coords_cells",ncolumns=1)
cell.list <- data.frame(gbifID=my.coords[[1]],cellNr=my.cells)
gbifID.filtered <- vector()
cell=1
s=1
while (cell <= length(cell.list[[1]])) {
  i=1
  next.cell=cell+1
  draw.list <- vector()
  while (next.cell < length(cell.list[[1]])) {
    if (cell.list[cell,2] == cell.list[next.cell,2]) {
      draw.list[i] <- as.character(cell.list[next.cell,1])
      i=i+1
    }
    next.cell <- next.cell+1
  }
  if (length(draw.list >= 1)) {
    draw.list[i] <- as.character(cell.list[cell,1])
    random.pick <- sample(1:length(draw.list),1)
    gbifID.filtered[s] <- draw.list[random.pick]
    for (c in draw.list) {
      cell.list <- subset(cell.list, gbifID!=c)
    }
    s=s+1
  }
  else {
    gbifID.filtered[s] <- as.character(cell.list[cell,1])
    s=s+1
    cell=cell+1
  }
}

coord.list.filtered <- data.frame(gbifID=1:length(gbifID.filtered), Latitude=1:length(gbifID.filtered), Longitude=1:length(gbifID.filtered))
f=1
for (ID in gbifID.filtered) {
  index <- match(ID, as.character(my.coords[,1]))
  coord.list.filtered[f,] <- c(as.character(my.coords[index,1]), as.character(my.coords[index,2]),as.character(my.coords[index,3]))
  f=f+1
}

write.csv(coord.list.filtered, file = outputfile, row.names = F, quote = F)

plot(my.grid)
points(coord.list.filtered[3:2])
