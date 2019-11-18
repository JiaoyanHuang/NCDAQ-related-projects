# Summary of CMAQ related projected

### WPS and WRF
17.  Linux x86_64, Intel compiler    (serial)

http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php
```
/storage/highspeed/JH/WPS
/storage/highspeed/apps/grib2_20191031
/storage/highspeed/JH/WRF
```

WRF 4.0 has been built but not tested using benchmark

WPS 4.0 has been built but not tested using benchmark
### MCIP
MCIP 5.0 has been built
### Boudnary and initial conditions
v5.3 ICON and BCON have been built
### NETCDF4
netcdf-c-4.7.0 has been built

netcdf-fortran-4.4.5 has been built
### IOAPI
ioapi-3.2_20190925 has been built
### CMAQ models
v5.0.2, v5.0.2ISAM, v5.0.2DDM have been built and evaluated with benchmark, this versions have issue with intel compiler 

v5.2, v5.2DDM  have been built and evaluated with benchmark

v5.3, v5.3ISAM have been built and evaluated with benchmark
### post process tools
appendwrf  bldoverlay  block_extract  calc_tmetric  combine  hr2day  sitecmp  sitecmp_dailyo3  writesite have been built and most of them have been tested

### NC nesting
```
'4NC1_219X147', ! 4km North Carolina grid for C40
'12CONUS1', 1128000.000, -552000.000, 4000.000, 4000.000, 219, 147, 1
'1NCSE1_188X204', ! 1km North Carolina grid for C40
'12CONUS1', 1586000.000, -466000.000, 1000.000, 1000.000, 188, 204, 1
```

### model evalution tools
AMET1.4 has been built, but I have not fully tested AMET1.4. It currently has SQL server issue (I have reported this to EPA and UNC IE).
```
/storage/highspeed/JH/AMET_v14
```
