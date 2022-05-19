
out = addfile("../convert_nc/index74.nc", "r")
data = out->index

season = dim_avg_n_Wrap(data(:,:,2:4), 2)


opt = True
opt@fout = "season.txt"

write_matrix(season, "66f14.2", opt)