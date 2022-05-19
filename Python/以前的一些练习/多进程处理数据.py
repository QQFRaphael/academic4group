import os
import time
import multiprocessing

def worker(model):
    t_start = time.time()
    print("begin to process %s" % model)

    os.chdir(model)

    allbios = os.popen("ls bio*.nc").read().split("\n")[0:19]

    for bio in allbios:
    	prefix = os.path.splitext(bio)[0]
    	os.system("sed -i \"1s/^.*.$/f = addfile(\\\"%s\\\", \\\"r\\\")/\" %s.ncl" % (bio,model))
    	os.system("sed -i \"29s/^.*.$/system(\\\"rm -rf %s-china.nc\\\")/\" %s.ncl" % (prefix,model))
    	os.system("sed -i \"30s/^.*.$/out = addfile(\\\"%s-china.nc\\\",\\\"c\\\")/\" %s.ncl" % (prefix,model))
    	os.system('ncl %s.ncl' % model)
    	os.system('gdal_translate -of aaigrid netcdf:%s-china.nc:Band1 %s.asc' % (prefix, prefix))
    	os.system('rm -rf *.xml')
    	print("%s/%s complete" % (model,bio))
    t_stop = time.time()
    print("Model: %s complete, exit !!! Use %0.2f" % (model,t_stop-t_start))

if __name__ == "__main__":
    timestart = time.time()
    pool = multiprocessing.Pool(processes = 7)

    models = os.popen("ls -d */").read().split("\n")
    models = models[0:len(models)-1]
    for model in models:
        pool.apply_async(worker, (model[:-1], ))   

    pool.close()
    pool.join() 
    timestop = time.time() 
    print("All subprocesses are complete after %0.2f" % t_stop-t_start)