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


mpl.plot(np.abs(eps),'b.',label="epsilon")
mpl.plot(np.abs(dis),'r.',label="bottom friction")
mpl.plot(np.abs(dip),'g.',label="dissip u>0")
mpl.plot(np.abs(dim),'m.',label="dissip u<0")

mpl.semilogy()
mpl.legend(loc='lower right')

mpl.show()

mpl.plot(eps,'b.',label="epsilon")
mpl.plot(dis,'r.',label="bottom friction")
mpl.plot(dip,'g.',label="dissip u>0")
mpl.plot(dim,'m.',label="dissip u<0")

mpl.legend(loc='lower left')



mpl.show()
