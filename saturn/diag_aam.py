#! /usr/bin/env python

import numpy as np
import matplotlib.pyplot as mpl
import ppcompute

## reading
eps = np.loadtxt("epsilon.txt")
dis = np.loadtxt("aam_dissip.txt")
phy = np.loadtxt("aam_phys.txt")
dip = np.loadtxt("aam_dissip_plus.txt")
dim = np.loadtxt("aam_dissip_moins.txt")
dyn = np.loadtxt("aam_dyn.txt")
dyp = np.loadtxt("aam_dyn_plus.txt")
dym = np.loadtxt("aam_dyn_moins.txt")
mas = np.loadtxt("aam_mass.txt")
win = np.loadtxt("aam_vel.txt")
wip = np.loadtxt("aam_vel_plus.txt")
wim = np.loadtxt("aam_vel_moins.txt")
crd = np.arange(eps.shape[0])

#tot = mas + win
#norm = tot / tot[0]
#mpl.plot(crd,norm,'g-')
#mpl.ylim(ymin=0.95,ymax=1.05)
#mpl.xlabel("simulated days")
#mpl.savefig('diag_aam_1_tot.png', bbox_inches='tight')
#mpl.close()

## calculate ratios
zedyn = np.abs(dyn)
denom = zedyn + np.abs(eps)
numer = np.abs(eps)
rat = 100.*numer/denom
rat[denom == 0] = 0. # ensure smooth is OK
zedyn = np.maximum(np.abs(dyn),np.abs(dyp),np.abs(dym))
zewin = np.maximum(np.abs(win),np.abs(wip),np.abs(wim))
chk = 100.*zedyn/zewin

## smooth for plot clarity
smth = 200
eps = ppcompute.smooth1d(eps,window=smth) / 1.e25
dip = ppcompute.smooth1d(dip,window=smth) / 1.e25
dim = ppcompute.smooth1d(dim,window=smth) / 1.e25
dyp = ppcompute.smooth1d(dyp,window=smth) / 1.e25
dym = ppcompute.smooth1d(dym,window=smth) / 1.e25
wip = ppcompute.smooth1d(dyp,window=smth) / 1.e25
wim = ppcompute.smooth1d(dym,window=smth) / 1.e25
win = ppcompute.smooth1d(win,window=smth) / 1.e25
mas = ppcompute.smooth1d(mas,window=smth) / 1.e25
coo = ppcompute.smooth1d(crd,window=smth)
rat = ppcompute.smooth1d(rat,window=smth) 
chk = ppcompute.smooth1d(chk,window=smth) 

## calculate xi from Lebonnois et al. 2012
xi = np.abs(eps) / np.maximum(np.abs(dip),np.abs(dim))

## calculate total AAM and normalize by initial value
tot = mas + win
norm = tot / tot[0]

####################
mpl.plot(coo,norm,'g-')
mpl.ylim(ymin=0.95,ymax=1.05)
mpl.xlabel("simulated days")
mpl.legend()
mpl.savefig('diag_aam_1_tot.png', bbox_inches='tight')
mpl.close()

####################
mpl.plot(coo,np.abs(mas),'g-',label=r'$\mathcal{M}_m$')
mpl.plot(coo,np.abs(win),'r-',label=r'$\mathcal{M}_w$')
mpl.legend(loc='lower center')
mpl.semilogy()
mpl.xlabel("simulated days")
mpl.ylabel(r'$10^{25}$ kg m$^2$ s$^{-1}$')
mpl.savefig('diag_aam_2_glob_log.png', bbox_inches='tight')
mpl.close()

####################
mpl.plot(coo,xi,'k-')
mpl.plot(coo,coo*0.+1.,'r-')
mpl.xlabel("simulated days")
mpl.savefig('diag_aam_3_xi.png', bbox_inches='tight')
mpl.close()

####################
mpl.plot(coo,eps,'k-',label=r'$\varepsilon$')
mpl.plot(coo,dip,'m-',label=r'$(D+F)_{u+}$')
mpl.plot(coo,dim,'g-',label=r'$(D+F)_{u-}$')
mpl.plot(coo,dyp,'r-',label=r'$(Dy)_{u+}$')
mpl.plot(coo,dym,'b-',label=r'$(Dy)_{u-}$')
mpl.legend(loc='lower left',ncol=2)
mpl.xlabel("simulated days")
mpl.ylabel(r'$10^{25}$ kg m$^2$ s$^{-2}$ ')
mpl.savefig('diag_aam_4_pert.png', bbox_inches='tight')
mpl.close()

####################
mpl.plot(coo,rat,'k-',label=r'$\frac{\varepsilon}{\varepsilon+\delta}$')
mpl.plot(coo,coo*0.+50.,'r-')
mpl.xlabel("simulated days")
mpl.ylabel("%")
mpl.savefig('diag_aam_5_relative.png', bbox_inches='tight')
mpl.close()

####################
mpl.plot(coo,chk,'k-')
mpl.xlabel("simulated days")
mpl.ylabel("%")
mpl.ylim(ymax=0.1)
mpl.savefig('diag_aam_6_relative_dyncontrib.png', bbox_inches='tight')
mpl.close()


