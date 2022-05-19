library(biomod2)

case <- "hongdoushan"

bm_out_file <- load("hongdoushan/hongdoushan.demo1.models.out")
en_bm_out_file <- load("hongdoushan/hongdoushan.demo1ensemble.models.out")

models <- get(bm_out_file)

## asses ensemble models quality ----
models_var_import <- get_variables_importance(models)
write.table(models_var_import, file=paste(case,"/001.build/var_import_each.csv",sep=""), sep=",", row.names=TRUE, col.name=NA, quote=FALSE)
