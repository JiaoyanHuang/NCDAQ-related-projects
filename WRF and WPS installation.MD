How to install WRF related libs and programs in NCDAQ cluster computer

This guidence is based on following websites

http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php
https://www.climatescience.org.au/sites/default/files/werner_compiling.pdf
## Test environmental varialbes
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar

```
tar -xf Fortran_C_tests.tar
ifort TEST_1_fortran_only_fixed.f
ifort TEST_2_fortran_only_free.f90
icc TEST_3_c_only.c
icc -c -m64 TEST_4_fortran+c_c.c
ifort -c -m64 TEST_4_fortran+c_f.f90
ifort -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out
./TEST_csh.csh
./TEST_perl.pl
./TEST_sh.sh
```

## libs
```
/storage/highspeed/apps/netcdf-c-4.7.0-intel17
/storage/highspeed/apps/mvapich2-2.2_ifc17/
/storage/highspeed/apps/zlib-1.2.11_ifc17
/storage/highspeed/apps/grib2_20191031
```

## Library Compatibility Tests
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
```
cp /storage/highspeed/apps/netcdf-c-4.7.0-intel17/include/netcdf.inc .
ifort -c 01_fortran+c+netcdf_f.f
icc -c 01_fortran+c+netcdf_c.c
setenv NETCDF /storage/highspeed/apps/netcdf-c-4.7.0-intel17
ifort 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
./a.out
mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
mpirun ./a.out
```

## Building WRF
```
./configure
```
em_real (3d real case)
18. (serial)
```
./compile case_name >& log.compile
```
## Building WPS
```
cd WPS
./clean
setenv JASPERLIB /storage/highspeed/apps/grib2_20191031/lib
setenv JASPERINC /storage/highspeed/apps/grib2_20191031/include
./configure
./compile >& log.compile
```
