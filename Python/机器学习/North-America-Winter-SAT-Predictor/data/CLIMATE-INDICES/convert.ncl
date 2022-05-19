load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

system("rm -rf indices.nc")

mystart = 1979
myend = 2018

outfile = addfile("indices.nc","c")
outfile->start_year = mystart
outfile->end_year = myend

filename = "./ao.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->ao = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)


filename = "./nao.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->nao = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)

filename = "./pna.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->pna = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)

filename = "./nina1.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->nina12 = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)

filename = "./nina3.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->nina3 = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)

filename = "./nina4.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->nina4 = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)

filename = "./nina34.data"
year_start = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $1}'"))
year_end = stringtoint(systemfunc("head -n 1 "+filename+" | awk '{print $2}'"))
data = new((/year_end-year_start+1,12/),"float")
stringdata = systemfunc("grep '^\s*[0-9]...' "+filename+" | sed '1d'")
do ii = 0,11
    data(:,ii)=stringtofloat(str_get_field(stringdata, ii+2," "))
end do
outdata = data(mystart-year_start:myend-year_start,:)
outfile->nina34 = outdata
delete(filename)
delete(year_start)
delete(year_end)
delete(data)
delete(stringdata)
delete(outdata)
