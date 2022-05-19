library(rgdal)
library(raster)
library(biomod2)
library(usdm)

workdir <- "/path/to/WorkDirectory" # The directory where you want to work (the script will create folders and files here)
species_name <- 'Porbiculare' # The name of the species (not the full name of the presence file. for example if the presence file is names Porbiculare.csv, then enter
                              # here only Porbiculare)
PseudoAbsence.rep = 10
number.evalRuns = 10

setwd(workdir)

Now_sta <- stack(list.files(paste(workdir,"/cropped_now",sep=""), pattern = "*.tif", full.names = T), RAT = FALSE)
LGM_sta <- stack(list.files(paste(workdir,"/cropped_lgm",sep=""), pattern = "*.tif", full.names = T), RAT = FALSE)

#to take into account multicollinearity between bioclim variables we use VIF (see vif documentation in the package usdm) to remove highly collinear variables
coordFile <- read.csv(paste(species_name,".csv",sep=''),sep = ",")

bioclimVar <- extract(Now_sta, cbind(coordFile$Longitude,coordFile$Latitude))
cofcor.now <-vifcor(bioclimVar, th = 0.7)
print(cofcor.now@results)
write.csv(cofcor.now@results,file = "VIF_kept_output.csv")
write.csv(cofcor.now@corMatrix,file = "VIF_correlationMatrix.csv")

Now_sta.reduced <- exclude(Now_sta, cofcor.now)
LGM_sta.reduced <- exclude(LGM_sta, cofcor.now)

ferr <- coordFile
coor = ferr[c('Longitude','Latitude')]
ferr_data = ferr[c("object",'Longitude','Latitude',species_name)]
myresp = as.numeric(ferr_data[,species_name])
###  PA.nb.rep##
myBiomodData <- BIOMOD_FormatingData(resp.var = myresp, 
                                     expl.var = Now_sta.reduced, 
                                     resp.xy = coor, 
                                     resp.name = species_name,
                                     PA.nb.rep=PseudoAbsence.rep, # https://mltconsecol.github.io/TU_LandscapeAnalysis_Documents/Assignments_web/Assignment08_SpeciesDistributionModeling_Pt1.html
                                     PA.nb.absences = length(myresp)) # absences same as nr presences: https://mltconsecol.github.io/TU_LandscapeAnalysis_Documents/Assignments_web/Assignment08_SpeciesDistributionModeling_Pt1.html

myBiomodOption <- BIOMOD_ModelingOptions()

myBiomodModelOut <- BIOMOD_Modeling(myBiomodData,
                                    models = c('GLM', 'GBM', 'GAM', 'CTA', 'ANN', 'SRE', 'FDA', 'MARS', 'RF'),
                                    models.options = myBiomodOption,
                                    NbRunEval=number.evalRuns, # Same as Da Pan et al 2020
                                    DataSplit=80,  # Same as Da Pan et al 2020
                                    models.eval.meth = 'ROC', # Same as Da Pan et al 2020
                                    do.full.models = FALSE) 

model.eva <- get_evaluations(myBiomodModelOut,as.data.frame=T)
write.csv(model.eva,file="modelEval.csv")

model.eva.scores <- get_evaluations(myBiomodModelOut,as.data.frame=F)
mean.model.eva.scores<- apply(model.eva.scores[,"Testing.data",,,], c(1,2), mean)
write.csv(mean.model.eva.scores,file="modelEval.mean.csv")
sd.model.eva.scores<- apply(model.eva.scores[,"Testing.data",,,], c(1,2), sd)
write.csv(sd.model.eva.scores,file="modelEval.sd.csv")

#pdf("model_scores_graph.pdf", title = "model_scores_graph", height = 8, width = 10)
#models_scores_graph(myBiomodModelOut, metrics = c("ROC","TSS"),by="models")
#dev.off()

myBiomodEM <- BIOMOD_EnsembleModeling(modeling.output = myBiomodModelOut,
                                      em.by = 'all',
                                      eval.metric = 'ROC', # Same as Da Pan et al 2020
                                      eval.metric.quality.threshold = 0.75, # Same as Da Pan et al 2020
                                      prob.mean = F, # true in Da Pan et al 2020
                                      prob.mean.weight = T,
                                      VarImport = 1)

model.evaEM <- get_evaluations(myBiomodEM,as.data.frame=T)
write.csv(model.evaEM,file="modelEvalEM.csv")
var.impEM <- get_variables_importance(myBiomodEM)
write.csv(var.impEM,file="varImpEM.csv")

if (file.exists("modelling_result") == FALSE){
  dir.create("modelling_result")
}
#Project ensemble model on  bioclim variable for Now
myBiomodProjectionNow <- BIOMOD_Projection(modeling.output = myBiomodModelOut,
                                           new.env = Now_sta.reduced,
                                           proj.name = "current",
                                           compress = FALSE,
                                           build.clamping.mask = FALSE)

EnsembleDistributionNow <- BIOMOD_EnsembleForecasting(projection.output = myBiomodProjectionNow, EM.output = myBiomodEM)
## if you want to plot the result to a pdf file 
pdf('EnsembleDistributionNow.pdf', title = "EnsembleDistributionNow")
plot(EnsembleDistributionNow)  
dev.off() 

myProjdfNow <- get_predictions(EnsembleDistributionNow)

writeRaster(myProjdfNow[[1]], file = paste('modelling_result/', species_name, '_now_ROC_wMean.asc', sep = ''), format='ascii')

pdf(file = "MeanSuitModelsNow.pdf", title = "MeanSuitModelsNow")
all.models <- get_predictions(myBiomodProjectionNow)
for (i in 1:9) {
  glmstack <- stack(all.models@layers[seq(i,length(all.models@layers), by=9)])
  glmstack.mean <- mean(glmstack)
  print(names(glmstack))
  plot(glmstack.mean, main = names(glmstack)[1])
}
dev.off()
#Project ensemble model on  bioclim variable for LGM
myBiomodProjectionLGM <- BIOMOD_Projection(modeling.output = myBiomodModelOut,
                                           new.env = LGM_sta.reduced,
                                           proj.name = "LGM",
                                           compress = FALSE,
                                           build.clamping.mask = FALSE)

EnsembleDistributionLGM <- BIOMOD_EnsembleForecasting( projection.output = myBiomodProjectionLGM, EM.output = myBiomodEM)


pdf('EnsembleDistributionLGM.pdf', title = "EnsembleDistributionLGM")
plot(EnsembleDistributionLGM)
dev.off() 

myProjdfLGM <- get_predictions(EnsembleDistributionLGM)

writeRaster(myProjdfLGM[[1]], file = paste('modelling_result/', species_name, '_lgm_ROC_wMean.asc', sep = ''), format='ascii')

pdf(file = "MeanSuitModelsLGM.pdf", title = "MeanSuitModelsLGM")
all.models <- get_predictions(myBiomodProjectionLGM)
for (i in 1:9) {
  glmstack <- stack(all.models@layers[seq(i,length(all.models@layers), by=9)])
  glmstack.mean <- mean(glmstack)
  print(names(glmstack))
  plot(glmstack.mean, main = paste("Mean habitat suitability",strsplit(names(glmstack)[1],"_")[[1]][4]))
}
dev.off()

pdf(file = "EnsembleHabitatSuitability.pdf", title = "EnsembleHabitatSuitability")
plot(myProjdfNow[[1]], main = "Ensemble habitat suitability Now")
plot(myProjdfLGM[[1]], main = "Ensemble habitat suitability LGM")
dev.off()
