library(biomod2)

species <- 'hongdoushan'
case <- 'MIROC-ES2L-ssp585-2081-2100'

bm_out_file <- load("hongdoushan/hongdoushan.demo1.models.out")
en_bm_out_file <- load("hongdoushan/hongdoushan.demo1ensemble.models.out")

models <- get(bm_out_file)
ensemble_models <- get(en_bm_out_file)

## asses ensemble models quality ----
ensemble_models_scores <- get_evaluations(ensemble_models)

models_scores_graph(
  ensemble_models, 
  by = "models" , 
  metrics = c("ROC","TSS"), 
  xlim = c(0.5,1), 
  ylim = c(0.5,1)
)

## read environment data ----
bioclim <- 
  raster::stack(
    c(
      bio_2 = paste('../data/',case,'/bio_2.asc',sep=""),
      bio_3 = paste('../data/',case,'/bio_3.asc',sep=""),
      bio_8 = paste('../data/',case,'/bio_8.asc',sep=""),
      bio_9 = paste('../data/',case,'/bio_9.asc',sep=""),
      bio_14 = paste('../data/',case,'/bio_14.asc',sep=""),
      bio_15 = paste('../data/',case,'/bio_15.asc',sep=""),
      bio_18 = paste('../data/',case,'/bio_18.asc',sep="")
    )
  )

## do models projections ----

## current projections
models_proj <- 
  BIOMOD_Projection(
    modeling.output = models,
    new.env = bioclim,
    proj.name = case,
    binary.meth = c("ROC","TSS"),
    do.stack = FALSE
  )

ensemble_models_proj <- 
  BIOMOD_EnsembleForecasting(
    EM.output = ensemble_models,
    projection.output = models_proj,
    binary.meth = c("ROC","TSS"),
    do.stack = FALSE
  )

plot(ensemble_models_proj, str.grep="EMwmean")
system(paste("mv Rplots.pdf ", species, "/proj_", case, sep=""))
