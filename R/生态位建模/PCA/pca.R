library(raster)
library(biomod2)
library(ade4)

bioclim_current <- 
  raster::stack(
    c(
      bio_1 = '../data/current/bio_1.asc',
      bio_2 = '../data/current/bio_2.asc',
      bio_3 = '../data/current/bio_3.asc',
      bio_4 = '../data/current/bio_4.asc',
      bio_5 = '../data/current/bio_5.asc',
      bio_6 = '../data/current/bio_6.asc',
      bio_7 = '../data/current/bio_7.asc',
      bio_8 = '../data/current/bio_8.asc',
      bio_9 = '../data/current/bio_9.asc',
      bio_10 = '../data/current/bio_10.asc',
      bio_11 = '../data/current/bio_11.asc',
      bio_12 = '../data/current/bio_12.asc',
      bio_13 = '../data/current/bio_13.asc',
      bio_14 = '../data/current/bio_14.asc',
      bio_15 = '../data/current/bio_15.asc',
      bio_16 = '../data/current/bio_16.asc',
      bio_17 = '../data/current/bio_17.asc',
      bio_18 = '../data/current/bio_18.asc',
      elev = '../data/current/elev.asc'
    )
  )

data <- na.omit(as.data.frame(bioclim_current))

head(data)

occ <- read.csv('../samples/Tetrastigma-hemsleyanum.csv')
points<-data.frame(occ[1:328,c("lon", "lat")])
cell_id <- cellFromXY(subset(bioclim_current,1), points)







pca_ZA <- dudi.pca(data,scannf = F, nf = 2)


plot(pca_ZA$li[, 1:2])

# tail of distributions

sort(pca_ZA$li[, 1])[1:10]

to_remove <- which(pca_ZA$li[, 1] < -10)

par(mfrow=c(1, 2))

# Discriminate Protea laurifolia presences from the entire # South African environmental space.

s.class(pca_ZA$li[, 1:2], fac= factor(rownames(data) %in% cell_id, levels = c("FALSE", "TRUE" ), labels = c("background", "ProLau")), col=c("red", "blue"), cstar = 0, cpoint = .3, pch = 16, xlim=c(-10,10), ylim=c(-6,6))

#mtext("(a)", side = 3, line = 3, adj = 0)
plot.new()
s.corcircle(pca_ZA$co, clabel = .3,add.plot=FALSE )

mtext("(b)", side = 3, line = 3, adj = 0)