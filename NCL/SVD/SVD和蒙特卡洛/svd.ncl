

svdinputfile = addfile("svd_input.nc","r")

snowdepth_Oct_to_Dec_reshape = svdinputfile->snowdepth_Oct_to_Dec_reshape
snowdepth_Nov_to_Jan_reshape = svdinputfile->snowdepth_Nov_to_Jan_reshape
snowdepth_Dec_to_Feb_reshape = svdinputfile->snowdepth_Dec_to_Feb_reshape
snowdepth_Jan_to_Mar_reshape = svdinputfile->snowdepth_Jan_to_Mar_reshape
snowdepth_Feb_to_Apr_reshape = svdinputfile->snowdepth_Feb_to_Apr_reshape
snowdepth_Mar_to_May_reshape = svdinputfile->snowdepth_Mar_to_May_reshape

pre_Jun_to_Aug = svdinputfile->pre_Jun_to_Aug

printVarSummary(snowdepth_Oct_to_Dec_reshape)
printVarSummary(pre_Jun_to_Aug)
print(max(snowdepth_Oct_to_Dec_reshape))
print(min(snowdepth_Oct_to_Dec_reshape))
print(max(pre_Jun_to_Aug))
print(min(pre_Jun_to_Aug))

nsvd = 5
ntime = 38
ncol = 5457
nstation = 756

homlft_Oct_to_Dec = new((/nsvd,ncol/),"float") 
homlft_Nov_to_Jan = new((/nsvd,ncol/),"float")
homlft_Dec_to_Feb = new((/nsvd,ncol/),"float")
homlft_Jan_to_Mar = new((/nsvd,ncol/),"float")
homlft_Feb_to_Apr = new((/nsvd,ncol/),"float")
homlft_Mar_to_May = new((/nsvd,ncol/),"float")

hetlft_Oct_to_Dec = new((/nsvd,ncol/),"float") 
hetlft_Nov_to_Jan = new((/nsvd,ncol/),"float")
hetlft_Dec_to_Feb = new((/nsvd,ncol/),"float")
hetlft_Jan_to_Mar = new((/nsvd,ncol/),"float")
hetlft_Feb_to_Apr = new((/nsvd,ncol/),"float")
hetlft_Mar_to_May = new((/nsvd,ncol/),"float")

homrgt_Oct_to_Dec = new((/nsvd,nstation/),"float") 
homrgt_Nov_to_Jan = new((/nsvd,nstation/),"float")
homrgt_Dec_to_Feb = new((/nsvd,nstation/),"float")
homrgt_Jan_to_Mar = new((/nsvd,nstation/),"float")
homrgt_Feb_to_Apr = new((/nsvd,nstation/),"float")
homrgt_Mar_to_May = new((/nsvd,nstation/),"float")

hetrgt_Oct_to_Dec = new((/nsvd,nstation/),"float") 
hetrgt_Nov_to_Jan = new((/nsvd,nstation/),"float")
hetrgt_Dec_to_Feb = new((/nsvd,nstation/),"float")
hetrgt_Jan_to_Mar = new((/nsvd,nstation/),"float")
hetrgt_Feb_to_Apr = new((/nsvd,nstation/),"float")
hetrgt_Mar_to_May = new((/nsvd,nstation/),"float")

; perform svd
print("Oct_to_Dec")
var_Oct_to_Dec = svdstd(snowdepth_Oct_to_Dec_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Oct_to_Dec,hetlft_Oct_to_Dec,homrgt_Oct_to_Dec,hetrgt_Oct_to_Dec)

print("Nov_to_Jan")
var_Nov_to_Jan = svdstd(snowdepth_Nov_to_Jan_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Nov_to_Jan,hetlft_Nov_to_Jan,homrgt_Nov_to_Jan,hetrgt_Nov_to_Jan)

print("Dec_to_Feb")
var_Dec_to_Feb = svdstd(snowdepth_Dec_to_Feb_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Dec_to_Feb,hetlft_Dec_to_Feb,homrgt_Dec_to_Feb,hetrgt_Dec_to_Feb)

print("Jan_to_Mar")
var_Jan_to_Mar = svdstd(snowdepth_Jan_to_Mar_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Jan_to_Mar,hetlft_Jan_to_Mar,homrgt_Jan_to_Mar,hetrgt_Jan_to_Mar)

print("Feb_to_Apr")
var_Feb_to_Apr = svdstd(snowdepth_Feb_to_Apr_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Feb_to_Apr,hetlft_Feb_to_Apr,homrgt_Feb_to_Apr,hetrgt_Feb_to_Apr)

print("Mar_to_May")
var_Mar_to_May = svdstd(snowdepth_Mar_to_May_reshape(ncol|:,year|:),pre_Jun_to_Aug(nstation|:,year|:),nsvd,homlft_Mar_to_May,hetlft_Mar_to_May,homrgt_Mar_to_May,hetrgt_Mar_to_May)

print("writing...")

outfile = addfile("svd_output.nc","c")
outfile->homlft_Oct_to_Dec=homlft_Oct_to_Dec
outfile->homlft_Nov_to_Jan=homlft_Nov_to_Jan
outfile->homlft_Dec_to_Feb=homlft_Dec_to_Feb
outfile->homlft_Jan_to_Mar=homlft_Jan_to_Mar
outfile->homlft_Feb_to_Apr=homlft_Feb_to_Apr
outfile->homlft_Mar_to_May=homlft_Mar_to_May

outfile->hetlft_Oct_to_Dec=hetlft_Oct_to_Dec
outfile->hetlft_Nov_to_Jan=hetlft_Nov_to_Jan
outfile->hetlft_Dec_to_Feb=hetlft_Dec_to_Feb
outfile->hetlft_Jan_to_Mar=hetlft_Jan_to_Mar
outfile->hetlft_Feb_to_Apr=hetlft_Feb_to_Apr
outfile->hetlft_Mar_to_May=hetlft_Mar_to_May

outfile->homrgt_Oct_to_Dec=homrgt_Oct_to_Dec
outfile->homrgt_Nov_to_Jan=homrgt_Nov_to_Jan
outfile->homrgt_Dec_to_Feb=homrgt_Dec_to_Feb
outfile->homrgt_Jan_to_Mar=homrgt_Jan_to_Mar
outfile->homrgt_Feb_to_Apr=homrgt_Feb_to_Apr
outfile->homrgt_Mar_to_May=homrgt_Mar_to_May

outfile->hetrgt_Oct_to_Dec=hetrgt_Oct_to_Dec
outfile->hetrgt_Nov_to_Jan=hetrgt_Nov_to_Jan
outfile->hetrgt_Dec_to_Feb=hetrgt_Dec_to_Feb
outfile->hetrgt_Jan_to_Mar=hetrgt_Jan_to_Mar
outfile->hetrgt_Feb_to_Apr=hetrgt_Feb_to_Apr
outfile->hetrgt_Mar_to_May=hetrgt_Mar_to_May

outfile->var_Oct_to_Dec=var_Oct_to_Dec
outfile->var_Nov_to_Jan=var_Nov_to_Jan
outfile->var_Dec_to_Feb=var_Dec_to_Feb 
outfile->var_Jan_to_Mar=var_Jan_to_Mar
outfile->var_Feb_to_Apr=var_Feb_to_Apr
outfile->var_Mar_to_May=var_Mar_to_May
