dans le .bash_profile

~~~
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
~~~
