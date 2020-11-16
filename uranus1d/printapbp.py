#! /usr/bin/env python
from ppclass import pp

####
ff = "diagfi.nc"
####

apbp = open("apbp.txt", "w")
prof = open("temp_profile.txt","w")

ap = pp(file=ff,x=0,y=0,var="ap").getf()
bp = pp(file=ff,x=0,y=0,var="bp").getf()
temp = pp(file=ff,x=0,y=0,t=1e10,var="temp",useindex="1000",verbose=True).getf()

for nn in range(len(ap)):
   apbp.write("%14.6e%14.6e\n"%(ap[nn],bp[nn]))

for nn in range(len(temp)):
   prof.write("%14.6f \n"%(temp[nn]))

apbp.close()
prof.close()


