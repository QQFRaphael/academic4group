## biomod2 video: Multi species modelling ----
##
## author: Damien Georges
## date: 2020-05-13
## licence: GPL2
##
## Credit:
## This example has been inspired by the book
## **Habitat Suitability and Distribution Models** with Applications in R
## **by A. Guisan (1), W. Thuiller (2), N.E. Zimmermann (3) **
## with contribution by V. Di Cola, D. Georges and A. Psomas
## _(1) University of Lausanne, Switzerland_
## _(2) CNRS, Université Grenoble Alpes, France_
## _(3) Swiss Federal Research Institute WSL, Switzerland_
## Cambridge University Press
## http://www.cambridge.org/gb/academic/subjects/life-sciences/quantitative-biology-biostatistics-and-mathematical-modellin/habitat-suitability-and-distribution-models-applications-r
## 
## Citation:
## @book{
##    title={Habitat Suitability and Distribution Models: With Applications in R},
##    author={Guisan, A. and Thuiller, W. and Zimmermann, N.E.},
##    isbn={9780521758369},
##    series={Ecology, Biodiversity and Conservation},
##    year={2017},
##    publisher={Cambridge University Press}
## }
##

## download the required data ----
## reauired data are available at:
## https://github.com/biomodhub/biomod2-tutorial-material/raw/master/biomod2_video_multi_species_modelling.zip

## setup environment ----
setwd('workdir')

## load the required packages
library(biomod2)
library(raster)
library(rasterVis)
library(gridExtra)
library(reshape2)

## read data ----
## species occurences data
data <- read.csv('../data/Larus_occ.csv', stringsAsFactors = FALSE)
head(data)
table(data$species)
spp_to_model <- unique(data$species)

## curent climatic variables
stk_current <- 
  raster::stack(
    c(
      bio_1 =  "../data/worldclim_EU/worldclim_EU_bio_1.tif",
      bio_12 = "../data/worldclim_EU/worldclim_EU_bio_12.tif",
      bio_8 =  "../data/worldclim_EU/worldclim_EU_bio_8.tif"
    ),
    RAT = FALSE
  )

## 2050 climatic variables
stk_2050_BC_45 <- 
  raster::stack(
    c(
      bio_1 =  "../data/worldclim_EU/worldclim_EU_2050_BC45_bio_1.tif",
      bio_12 = "../data/worldclim_EU/worldclim_EU_2050_BC45_bio_12.tif",
      bio_8 =  "../data/worldclim_EU/worldclim_EU_2050_BC45_bio_8.tif"
    ),
    RAT = FALSE
  )

## 2070 climatic variables
stk_2070_BC_45 <- 
  raster::stack(
    c(
      bio_1 =  "../data/worldclim_EU/worldclim_EU_2070_BC45_bio_1.tif",
      bio_12 = "../data/worldclim_EU/worldclim_EU_2070_BC45_bio_12.tif",
      bio_8 =  "../data/worldclim_EU/worldclim_EU_2070_BC45_bio_8.tif"
    ),
    RAT = FALSE
  )


## build species modelling wrapper ----
biomod2_wrapper <- function(sp){
  cat("\n> species : ", sp)
  
  ## get occurrences points
  sp_dat <- data[data$species == sp, ]
  
  ## formating the data
  sp_format <- 
    BIOMOD_FormatingData(
      resp.var = rep(1, nrow(sp_dat)), 
      expl.var = stk_current,
      resp.xy = sp_dat[, c("long", "lat")],
      resp.name = sp,
      PA.strategy = "random", 
      PA.nb.rep = 2, 
      PA.nb.absences = 1000
    )
  
  ## print formatting summary
  sp_format
  
  ## save image of input data summary
  if(!exists(sp)) dir.create(sp)
  pdf(paste(sp, "/", sp ,"_data_formated.pdf", sep="" ))
  try(plot(sp_format))
  dev.off()
  
  ## define models options
  sp_opt <- BIOMOD_ModelingOptions()
  
  ## model species
  sp_model <- BIOMOD_Modeling( 
    sp_format, 
    models = c('GLM', 'FDA', 'RF'), 
    models.options = sp_opt, 
    NbRunEval = 2, 
    DataSplit = 70, 
    Yweights = NULL, 
    VarImport = 3, 
    models.eval.meth = c('TSS', 'ROC'),
    SaveObj = TRUE,
    rescal.all.models = FALSE,
    do.full.models = FALSE,
    modeling.id = "demo2"
  )
  
  ## save some graphical outputs
  #### models scores
  pdf(paste0(sp, "/", sp , "_models_scores.pdf"))
  try(gg1 <- models_scores_graph(sp_model, metrics = c("TSS", "ROC"), by = 'models', plot = FALSE))
  try(gg2 <- models_scores_graph(sp_model, metrics = c("TSS", "ROC"), by = 'data_set', plot = FALSE))
  try(gg3 <- models_scores_graph(sp_model, metrics = c("TSS", "ROC"), by = 'cv_run', plot = FALSE))
  try(grid.arrange(gg1, gg2, gg3))
  dev.off()
  
  ## build ensemble models
  sp_ens_model <- 
    BIOMOD_EnsembleModeling(
      modeling.output = sp_model,
      em.by = 'all',
      eval.metric = 'TSS',
      eval.metric.quality.threshold = 0.4,
      models.eval.meth = c('TSS','ROC'),
      prob.mean = FALSE,
      prob.mean.weight = TRUE,
      VarImport = 0
    )
  
  ## do projections
  proj_scen <- c("current", "2050_BC_45", "2070_BC_45")
  
  for(scen in proj_scen){
    cat("\n> projections of ", scen)
    
    ## single model projections
    sp_proj <- 
      BIOMOD_Projection(
        modeling.output = sp_model,
        new.env = get(paste0("stk_", scen)),
        proj.name = scen,
        selected.models = 'all',
        binary.meth = "TSS",
        filtered.meth = NULL,
        compress = TRUE,
        build.clamping.mask = FALSE,
        do.stack = FALSE,
        output.format = ".img"
      )
    
    ## ensemble model projections
    sp_ens_proj <- 
      BIOMOD_EnsembleForecasting(
        EM.output = sp_ens_model,
        projection.output = sp_proj,
        binary.meth = "TSS",
        compress = TRUE,
        do.stack = FALSE,
        output.format = ".img"
      )
  }
  
  return(paste0(sp," modelling completed !"))
}


## launch the spiecies modelling wrapper over species list ----
if(require(snowfall)){ ## parallel computation
  ## start the cluster
  sfInit(parallel = TRUE, cpus = 5) ## here we only require 4 cpus
  sfExportAll()
  sfLibrary(biomod2)
  ## launch our wrapper in parallel
  sf_out <- sfLapply(spp_to_model, biomod2_wrapper)
  ## stop the cluster
  sfStop()
} else { ## sequencial computation
  for (sp in spp_to_model){
    biomod2_wrapper(sp)
  }
  ## or with a lapply function in sequential model
  ## all_species_bm <- lapply(spp_to_model, biomod2_wrapper)
}

## produce alpha-diversity maps ----

## current conditons
### load binary projections
f_em_wmean_bin_current <- 
  paste0(
    spp_to_model,
    "/proj_current/individual_projections/", 
    spp_to_model, "_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData_TSSbin.img"
  )

### sum all projections
if(length(f_em_wmean_bin_current) >= 2){
  ## initialisation
  taxo_alpha_div_current <- raster(f_em_wmean_bin_current[1]) 
  for(f in f_em_wmean_bin_current[-1]){
    taxo_alpha_div_current <- taxo_alpha_div_current + raster(f)
  }
}

## 2050 conditons
### load binaries projections
f_em_wmean_bin_2050 <- 
  paste0(
    spp_to_model,
    "/proj_2050_BC_45/individual_projections/", 
    spp_to_model, "_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData_TSSbin.img"
  )

### sum all projections
if(length(f_em_wmean_bin_2050) >= 2){
  ## initialisation
  taxo_alpha_div_2050 <- raster(f_em_wmean_bin_2050[1]) 
  for(f in f_em_wmean_bin_2050[-1]){
    taxo_alpha_div_2050 <- taxo_alpha_div_2050 + raster(f)
  }
}

## 2070 conditons
### load binaries projections
f_em_wmean_bin_2070 <- 
  paste0(
    spp_to_model,
    "/proj_2070_BC_45//individual_projections/", 
    spp_to_model, "_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData_TSSbin.img"
  )

### sum all projections
if(length(f_em_wmean_bin_2070) >= 2){
  ## initialisation
  taxo_alpha_div_2070 <- raster(f_em_wmean_bin_2070[1]) 
  for(f in f_em_wmean_bin_2070){
    taxo_alpha_div_2070 <- taxo_alpha_div_2070 + raster(f)
  }
}

## plot the alpha-div maps
levelplot(
  stack(
    c(
      current = taxo_alpha_div_current, 
      in_2050 = taxo_alpha_div_2050, 
      in_2070 = taxo_alpha_div_2070 
    )
  ),
  main = expression(paste("Larus ", alpha, "-diversity")),
  par.settings = BuRdTheme
)

