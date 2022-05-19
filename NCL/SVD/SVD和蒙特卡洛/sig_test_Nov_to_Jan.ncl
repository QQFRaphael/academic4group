
nsvd = 5 
ntime = 38
ncol = 5457
nstation = 756 

svdinputfile = addfile("svd_input.nc","r")

snowdepth_Nov_to_Jan_reshape = svdinputfile->snowdepth_Nov_to_Jan_reshape

pre_Jun_to_Aug = svdinputfile->pre_Jun_to_Aug

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

homlft = new((/nsvd,ncol/),"float") 
homrgt = new((/nsvd,nstation/),"float") 
hetlft = new((/nsvd,ncol/),"float")  
hetrgt = new((/nsvd,nstation/),"float") 
lft_in = new((/ncol,ntime/),"float")
rgt_in = new((/nstation,ntime/),"float")

out = new((/100,nsvd/),"double") 


do i=0,100

snow_rand_idx = generate_unique_indices( ntime )
pre_rand_idx = generate_unique_indices( ntime )

snow_rand = snowdepth_Nov_to_Jan_reshape(snow_rand_idx,:)
pre_rand = pre_Jun_to_Aug(pre_rand_idx,:)

var = svdstd(snow_rand(ncol|:,year|:),pre_rand(nstation|:,year|:),nsvd,homlft,hetlft,homrgt,hetrgt)
print("this is the "+i+"th test and the variance of 1st mode is "+var(0))

out(i,:) = var

end do

opt = True
opt@title  = "Normal"
opt@tspace = 22
write_matrix (out, "5f7.2" , opt)

