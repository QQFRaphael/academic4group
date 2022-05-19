load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


yearstart = 1979
yearend = 2018
nyear = yearend - yearstart + 1

ff = addfile("../NA-SAT-EOF/EOF.nc", "r")

snowdata = ff->PC2_norm

indicesfile = addfile("indices.nc","r")

start_year = indicesfile->start_year
end_year = indicesfile->end_year

aodata = indicesfile->ao
naodata = indicesfile->nao
pnadata = indicesfile->pna
ninadata = indicesfile->nina34
nina4data = indicesfile->nina4
nina3data = indicesfile->nina3
nina1data = indicesfile->nina12

n1 = nyear
n2 = nyear-1

t1 = 2.021

ao_jan = aodata(:,0)
ao_feb = aodata(:,1)
ao_mar = aodata(:,2)
ao_apr = aodata(:,3)
ao_may = aodata(:,4)
ao_jun = aodata(:,5)
ao_jul = aodata(:,6)
ao_aug = aodata(:,7)
ao_sep = aodata(:,8)
ao_oct = aodata(:,9)
ao_nov = aodata(:,10)
ao_dec = aodata(:,11)

nao_jan = naodata(:,0)
nao_feb = naodata(:,1)
nao_mar = naodata(:,2)
nao_apr = naodata(:,3)
nao_may = naodata(:,4)
nao_jun = naodata(:,5)
nao_jul = naodata(:,6)
nao_aug = naodata(:,7)
nao_sep = naodata(:,8)
nao_oct = naodata(:,9)
nao_nov = naodata(:,10)
nao_dec = naodata(:,11)

pna_jan = pnadata(:,0)
pna_feb = pnadata(:,1)
pna_mar = pnadata(:,2)
pna_apr = pnadata(:,3)
pna_may = pnadata(:,4)
pna_jun = pnadata(:,5)
pna_jul = pnadata(:,6)
pna_aug = pnadata(:,7)
pna_sep = pnadata(:,8)
pna_oct = pnadata(:,9)
pna_nov = pnadata(:,10)
pna_dec = pnadata(:,11)

nina_jan = ninadata(:,0)
nina_feb = ninadata(:,1)
nina_mar = ninadata(:,2)
nina_apr = ninadata(:,3)
nina_may = ninadata(:,4)
nina_jun = ninadata(:,5)
nina_jul = ninadata(:,6)
nina_aug = ninadata(:,7)
nina_sep = ninadata(:,8)
nina_oct = ninadata(:,9)
nina_nov = ninadata(:,10)
nina_dec = ninadata(:,11)

nina4_jan = nina4data(:,0)
nina4_feb = nina4data(:,1)
nina4_mar = nina4data(:,2)
nina4_apr = nina4data(:,3)
nina4_may = nina4data(:,4)
nina4_jun = nina4data(:,5)
nina4_jul = nina4data(:,6)
nina4_aug = nina4data(:,7)
nina4_sep = nina4data(:,8)
nina4_oct = nina4data(:,9)
nina4_nov = nina4data(:,10)
nina4_dec = nina4data(:,11)

nina3_jan = nina3data(:,0)
nina3_feb = nina3data(:,1)
nina3_mar = nina3data(:,2)
nina3_apr = nina3data(:,3)
nina3_may = nina3data(:,4)
nina3_jun = nina3data(:,5)
nina3_jul = nina3data(:,6)
nina3_aug = nina3data(:,7)
nina3_sep = nina3data(:,8)
nina3_oct = nina3data(:,9)
nina3_nov = nina3data(:,10)
nina3_dec = nina3data(:,11)

nina1_jan = nina1data(:,0)
nina1_feb = nina1data(:,1)
nina1_mar = nina1data(:,2)
nina1_apr = nina1data(:,3)
nina1_may = nina1data(:,4)
nina1_jun = nina1data(:,5)
nina1_jul = nina1data(:,6)
nina1_aug = nina1data(:,7)
nina1_sep = nina1data(:,8)
nina1_oct = nina1data(:,9)
nina1_nov = nina1data(:,10)
nina1_dec = nina1data(:,11)


print("")
print("==================================================================================================")
print("")

; AO: SON snow cover -- SON AO_INDEX
n = n1
ao = (ao_sep + ao_oct + ao_nov) / 3.0
rc = escorc_n(snowdata,ao,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("AO:  SON snow cover -- SON AO_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )


print("")
print("==================================================================================================")
print("")



; NAO: SON snow cover -- SON NAO_INDEX
n = n1
nao = (nao_sep + nao_oct + nao_nov) / 3.0
rc = escorc_n(snowdata,nao,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("NAO:  SON snow cover -- SON NAO_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )



print("")
print("==================================================================================================")
print("")


; PNA: SON snow cover -- SON PNA_INDEX
n = n1
pna = (pna_sep + pna_oct + pna_nov) / 3.0
rc = escorc_n(snowdata,pna,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("PNA:  SON snow cover -- SON PNA_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA)


print("")
print("==================================================================================================")
print("")

; NINA: SON snow cover -- SON NINA_INDEX
n = n1
nina = (nina_sep + nina_oct + nina_nov) / 3.0
rc = escorc_n(snowdata,nina,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("NINA:  SON snow cover -- SON NINA_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )


print("")
print("==================================================================================================")
print("")


; NINA4: SON snow cover -- SON NINA4_INDEX
n = n1
nina4 = (nina4_sep + nina4_oct + nina4_nov) / 3.0
rc = escorc_n(snowdata,nina4,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("NINA4:  SON snow cover -- SON NINA4_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )


print("")
print("==================================================================================================")
print("")


; NINA3: SON snow cover -- SON NINA3_INDEX
n = n1
nina3 = (nina3_sep + nina3_oct + nina3_nov) / 3.0
rc = escorc_n(snowdata,nina3,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("NINA3:  SON snow cover -- SON NINA3_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )


print("")
print("==================================================================================================")
print("")

; NINA1: SON snow cover -- SON NINA1_INDEX
n = n1
nina1 = (nina1_sep + nina1_oct + nina1_nov) / 3.0
rc = escorc_n(snowdata,nina1,0,0)
t = abs(rc * sqrt( (n-2) / (1-rc*rc) ))
flagA = t.ge.t1
print("NINA1:  SON snow cover -- SON NINA1_INDEX NEXT RC = " + rc +  " tval = " + t + " PASS 95: " + flagA )

print("")
print("==================================================================================================")
print("")