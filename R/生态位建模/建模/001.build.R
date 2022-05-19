library(raster)
library(biomod2)


setwd('.')

case <- "hongdoushan"

# clean previous runs
system(paste("rm -rf ", case, sep=""))

## read environment data ----
bioclim_current <- 
  raster::stack(
    c(
      bio_2 = '../data/current/bio_2.asc',
      bio_3 = '../data/current/bio_3.asc',
      bio_8 = '../data/current/bio_8.asc',
      bio_9 = '../data/current/bio_9.asc',
      bio_14 = '../data/current/bio_14.asc',
      bio_15 = '../data/current/bio_15.asc',
      bio_18 = '../data/current/bio_18.asc'
    )
  )

## read sample data ----
occ <- read.csv('../samples/hongdoushan.csv')
#summary(occ)

## format the data ----
data <- 
  BIOMOD_FormatingData(
    resp.var = occ[case],
    resp.xy = occ[, c('lon', 'lat')],
    expl.var = bioclim_current,
    resp.name = case,
    PA.nb.rep = 5,
    PA.nb.absences = 800,
    PA.strategy = 'random'
  )

plot(data)

## define individual models options ---- 
opt <- 
  BIOMOD_ModelingOptions(
    GLM = list(type='quadratic', interaction.level=3),
    GBM = list(n.trees=3000),
    RF  = list(ntree=1500),
    GAM = list(algo='GAM_mgcv'),
    CTA = list(method='class'),
    ANN = list(maxit=600),
    SRE = list(quant=0.025),
    FDA = list(method="mars"),
    MARS = list(myFormula="simple"),
    MAXENT.Phillips = list(path_to_maxent.jar=".",maximumiterations=6000,convergencethreshold=0.0001)
  )

## run the individual models ----
models <- 
  BIOMOD_Modeling(
    data = data,
    models = c("GLM","GBM","RF","GAM","CTA","ANN","SRE","FDA","MARS","MAXENT.Phillips"),
    models.options = opt,
    models.eval.meth = c("TSS", "ROC"),
    NbRunEval = 5,
    DataSplit = 70,
    VarImport = 5,
    SaveObj = TRUE,
    modeling.id = "demo1"
  )

## asses individual models quality ----

## get models evaluation scores
models_scores <- get_evaluations(models)

## models_scores is a 5 dimension array containing the scores of the models
#dim(models_scores)
#dimnames(models_scores)

## plot models evaluation scores
models_scores_graph(
  models, 
  by = "models", 
  metrics = c("ROC","TSS"), 
  xlim = c(0.5,1), 
  ylim = c(0.5,1)
)

models_scores_graph(
  models, 
  by = "cv_run" , 
  metrics = c("ROC","TSS"), 
  xlim = c(0.5,1), 
  ylim = c(0.5,1)
)

models_scores_graph(
  models, 
  by = "data_set", 
  metrics = c("ROC","TSS"), 
  xlim = c(0.5,1), 
  ylim = c(0.5,1)
)

## check variable importance
models_var_import <- get_variables_importance(models)

## make the mean of variable importance by algorithm
var_importance <- apply(models_var_import, c(1,2), mean)

## individual models response plots
glm <- BIOMOD_LoadModels(models, models='GLM', run.eval='Full')
gbm <- BIOMOD_LoadModels(models, models='GBM', run.eval='Full')
rf  <- BIOMOD_LoadModels(models, models='RF', run.eval='Full')
gam <- BIOMOD_LoadModels(models, models='GAM', run.eval='Full')
cta <- BIOMOD_LoadModels(models, models='CTA', run.eval='Full')
ann <- BIOMOD_LoadModels(models, models='ANN', run.eval='Full')
sre <- BIOMOD_LoadModels(models, models='SRE', run.eval='Full')
fda <- BIOMOD_LoadModels(models, models='FDA', run.eval='Full')
mars <- BIOMOD_LoadModels(models, models='MARS', run.eval='Full')
maxent <- BIOMOD_LoadModels(models, models='MAXENT.Phillips', run.eval='Full')

glm_eval_strip <- 
  biomod2::response.plot2(
    models  = glm,
    Data = get_formal_data(models,'expl.var'), 
    show.variables= get_formal_data(models,'expl.var.names'),
    do.bivariate = FALSE,
    fixed.var.metric = 'mean',
    legend = FALSE,
    display_title = FALSE,
    data_species = get_formal_data(models,'resp.var')
  )

gbm_eval_strip <- 
  biomod2::response.plot2(
    models  = gbm,
    Data = get_formal_data(models,'expl.var'), 
    show.variables= get_formal_data(models,'expl.var.names'),
    do.bivariate = FALSE,
    fixed.var.metric = 'mean',
    legend = FALSE,
    display_title = FALSE,
    data_species = get_formal_data(models,'resp.var')
  )

rf_eval_strip <- 
  biomod2::response.plot2(
    models  = rf,
    Data = get_formal_data(models,'expl.var'), 
    show.variables= get_formal_data(models,'expl.var.names'),
    do.bivariate = FALSE,
    fixed.var.metric = 'mean',
    legend = FALSE,
    display_title = FALSE,
    data_species = get_formal_data(models,'resp.var')
  )

gam_eval_strip <- 
  biomod2::response.plot2(
  models  = gam,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

cta_eval_strip <- 
  biomod2::response.plot2(
  models  = cta,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

ann_eval_strip <- 
  biomod2::response.plot2(
  models  = ann,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

sre_eval_strip <- 
  biomod2::response.plot2(
  models  = sre,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

fda_eval_strip <- 
  biomod2::response.plot2(
  models  = fda,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

mars_eval_strip <- 
  biomod2::response.plot2(
  models  = mars,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

maxent_eval_strip <- 
  biomod2::response.plot2(
  models  = maxent,
  Data = get_formal_data(models,'expl.var'), 
  show.variables= get_formal_data(models,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean',
  legend = FALSE,
  display_title = FALSE,
  data_species = get_formal_data(models,'resp.var')
)

## run the ensemble models ----
ensemble_models <- 
  BIOMOD_EnsembleModeling(
    modeling.output = models,
    em.by = 'all',
    eval.metric = c('TSS','ROC'),
    eval.metric.quality.threshold = c(0.8,0.9),
    models.eval.meth = c('TSS','ROC'),
    prob.mean = FALSE,
    prob.cv = TRUE, 
    committee.averaging = TRUE,
    prob.mean.weight = TRUE,
    VarImport = 0
  )

## asses ensemble models quality ----
ensemble_models_scores <- get_evaluations(ensemble_models)

models_scores_graph(
  ensemble_models, 
  by = "models" , 
  metrics = c("ROC","TSS"), 
  xlim = c(0.5,1), 
  ylim = c(0.5,1)
)

dir.create(paste(case,"/001.build",sep=""))
save(data, file=paste(case,"/001.build/PA.data",sep=""))
write.table(glm_eval_strip, file=paste(case,"/001.build/glm_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(gbm_eval_strip, file=paste(case,"/001.build/gbm_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(rf_eval_strip, file=paste(case,"/001.build/rf_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(gam_eval_strip, file=paste(case,"/001.build/gam_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(cta_eval_strip, file=paste(case,"/001.build/cta_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(ann_eval_strip, file=paste(case,"/001.build/ann_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(sre_eval_strip, file=paste(case,"/001.build/sre_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(fda_eval_strip, file=paste(case,"/001.build/fda_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(mars_eval_strip, file=paste(case,"/001.build/mars_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(maxent_eval_strip, file=paste(case,"/001.build/maxent_response.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(var_importance, file=paste(case,"/001.build/var_importance.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(ensemble_models_scores, file=paste(case,"/001.build/ensemble_models_scores.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
write.table(models_scores, file=paste(case,"/001.build/models_scores.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
system(paste("mv Rplots.pdf ", case, "/001.build/", sep=""))
