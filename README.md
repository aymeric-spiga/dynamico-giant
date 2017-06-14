
### important

* synchronize call to physics with XIOS outputs
* synchronize also for physics
* do not use a timestep with more than 3 digits after .
* enough procs for xios_server (1 per 25)
* set nprocs_for_run = 10 * nsplit_i * nsplit_j
* do not call physics and radtrans too often
* increase buffer (factor 4 --> 12)
* do not open output file before the end
* augmenter info_level ralentit
* faire tail -f icosa_lmdz.out | grep "0000:" ralentit
* gros effet de la fréquence de sortie (y compris en grille native)

semble-t-il le remapping explose la mémoire utilisée par XIOS
--> utiliser plus que 1 serveur par 25 coeurs de run ?

il faut 100 serveurs pour 1200 sinon ça freeze
testé en sortie grille native
environ même temps de calcul que version non serveur
voire un peu plus rapide
(sauf fin XIOS beaucoup plus longue 
le temps de fermer tous les serveurs)
-- autre probleme: il n ecrit pas bien le startfi.nc
-- et en fait il ne clot jamais...

### fix compilation problems 

dans le .bash_profile

```bash
export PATH=$PATH:.:~millourheat/FCM_V1.2/bin
ulimit -s unlimited
# modules
module purge
module load intel/17.0
module load intelmpi/2017.0.098
module load hdf5/1.8.17
module load netcdf/4.4.0_fortran-4.4.2
module load ncview
module load nco
module load qt
module load python
module load mkl
```

