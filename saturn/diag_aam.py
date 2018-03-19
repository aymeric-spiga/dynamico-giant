#! /usr/bin/env python

import numpy as np
import matplotlib.pyplot as mpl

eps = np.loadtxt("epsilon.txt")
eps = eps[np.where(eps != 0.)]

dis = np.loadtxt("aam_dissip.txt")
dis = dis[np.where(dis != 0.)]

phy = np.loadtxt("aam_phys.txt")
phy = phy[np.where(dis != 0.)]

dip = np.loadtxt("aam_dissip_plus.txt")
dip = dip[np.where(dip != 0.)]

dim = np.loadtxt("aam_dissip_moins.txt")
dim = dim[np.where(dim != 0.)]

dyn = np.loadtxt("aam_dyn.txt")
dyn = dyn[np.where(dyn != 0.)]

mas = np.loadtxt("aam_mass.txt")
win = np.loadtxt("aam_vel.txt")

l = len(win)
tot = mas[0:l] + win 
norm = tot / tot[0]
mpl.plot(norm,'g-')
mpl.ylim(ymin=0.95,ymax=1.05)
mpl.title("Normalized total angular momentum")
mpl.xlabel("simulated days")
mpl.savefig('diag_aam_1_tot.png', bbox_inches='tight')
mpl.close()

mpl.plot(np.abs(mas),'g.',label="AAM_mass")
mpl.plot(np.abs(win),'r.',label="|AAM_wind|")
mpl.plot(np.abs(eps),'b.',label="|epsilon|")
mpl.legend(loc='lower center')
mpl.semilogy()
mpl.xlabel("simulated days")
mpl.savefig('diag_aam_2_glob_log.png', bbox_inches='tight')
mpl.close()

mpl.plot(np.abs(eps),'b.',label="|epsilon|")
mpl.plot(np.abs(dis),'r.',label="|bottom friction|")
mpl.plot(np.abs(dip),'g.',label="|dissip u>0|")
mpl.plot(np.abs(dim),'m.',label="|dissip u<0|")
mpl.semilogy()
mpl.legend(loc='lower right')
mpl.xlabel("simulated days")
mpl.savefig('diag_aam_3_pert_log.png', bbox_inches='tight')
mpl.close()

mpl.plot(eps,'b.',label="epsilon")
mpl.plot(dis,'r.',label="bottom friction")
mpl.plot(dip,'g.',label="dissip u>0")
mpl.plot(dim,'m.',label="dissip u<0")
mpl.legend(loc='lower left')
mpl.xlabel("simulated days")
mpl.savefig('diag_aam_4_pert.png', bbox_inches='tight')
mpl.close()

l = len(eps)
rat = 100.*eps[0:l]/dyn[0:l]
rat2 = 100.*eps[0:l]/win[0:l]
mpl.plot(rat,'b.',label="epsilon/dyn in %")
mpl.plot(rat2,'r.',label="epsilon/wind in %")
mpl.legend(loc='lower left')
mpl.xlabel("simulated days")
mpl.semilogy()
mpl.savefig('diag_aam_5_relative.png', bbox_inches='tight')
mpl.close()

