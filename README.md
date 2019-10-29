Joey Huang huangj1311@gmail.com 20191029
https://www.cmascenter.org

All the installations are based on follwoing settings:

```
[jhuang@ncaqc2017 apps]$ which ifort
/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/ifort
[jhuang@ncaqc2017 apps]$ which icc
/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc
[jhuang@ncaqc2017 apps]$ which icpc
/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icpc
[jhuang@ncaqc2017 apps]$ which mpirun
/storage/highspeed/apps/mvapich2-2.2_ifc17/bin/mpirun
```

if you have any quesiton please post question to 

https://forum.cmascenter.org/

## Tools

### netcdf
### ioapi
please see https://github.com/JiaoyanHuang/NCDAQ-CMAQ-related-project/blob/master/CMAQ(v5.3)%20system%20installation%20NCDAQ.md

located in 
```
/storage/highspeed/apps/ioapi-3.2_20190925
/storage/highspeed/apps/netcdf-c-4.7.0-intel17
/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17
```
m3tools or ioapi functions can be found in:

https://www.cmascenter.org/ioapi/documentation/all_versions/html/AA.html

netcdf functions or questions can check here:

https://www.unidata.ucar.edu/software/netcdf/

## CMAQ
I built mulitple version of CMAQ for different usages, since not all versions of CMAQ include 
Integrated Source Apportionment Method (ISAM):https://www.airqualitymodeling.org/index.php/CMAQv5.0.2_Integrated_Source_Apportionment

Decoupled Direct Method in 3 Dimensions (DDM-3D):https://www.airqualitymodeling.org/index.php/CMAQ_version_5.2_DDM_Technical_Documentation

Advanced Plume Treatment (APT):https://www.airqualitymodeling.org/index.php/CMAQv5.0.2-APT

ISAM and DDM are instrumental models for CMAQ source apportionment, the difference between these two are DDM can give us more detail information
about contribution the A precursor from B sources to C pollutant. ISAM can only provide contribution from B sources to C pollutant.

APT is a CMAQ advanced plume treatment model for CMAQ, Randy wish to understand of the contributions for landing and takeoff contribution in downwind area of airports.

### CMAQv5.0.2
CMAQ 5.0.2, CMAQ ISAM, CMAQ DDM have been built in 
```
/storage/highspeed/Models/aq/CMAQ/CMAQv5.0.2
```
However, there is an evalution issue, we have to update intel fortran compiler to 2018:

https://forum.cmascenter.org/t/cmaq-benchmark-differences/475

CMAQ APT cannot be built due to makefile issue:

https://forum.cmascenter.org/t/cmaq-v5-0-2-apt-installation-issue/1077

### CMAQv5.2
CMAQ 5.2 and CMAQ DDM have been built in

```
/storage/highspeed/Models/aq/CMAQ/CMAQ_v5.2
```
evalutions are OK.

### CMAQv5.3

CMAQ 5.3 and CMAQ ISAM have been built in
```
/storage/highspeed/Models/aq/CMAQ/CMAQ_v5.3
```
evalutions are OK.

## SMOKE

## NEI2016
