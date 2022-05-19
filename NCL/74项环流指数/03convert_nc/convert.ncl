startyear = 1951
endyear = 2016
nyears = endyear - startyear + 1

system("rm -rf index74.nc")
out = addfile("index74.nc", "c")
data = new((/74, nyears, 12/), "float")

do ii = 1, 74
    orifile = "../cut_head/idx"+ii+".txt"
    data(ii-1,:,:) = asciiread(orifile, (/nyears, 12/), "float")
end do

data@_FillValue = 999

out->index = data