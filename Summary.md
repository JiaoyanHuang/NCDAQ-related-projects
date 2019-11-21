# Summary of CMAQ related projected

### WPS and WRF
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
potnetial grids
```
GRID-NAME
COORD-NAME, XORIG, YORIG, XCELL, YCELL, NCOLS, NROWS, NTHIK
'4NC2', ! 4km North Carolina 201x114 for Kirk Baker WO 120.2
'LAM_40N97W', 1224000.0, -576000.0, 4000.0, 4000.0, 201, 114, 1
'1RTP1', ! 1km North Carolina 108x60 domain for Kirk Baker WO 120.2
'LAM_40N97W', 1584000.0, -324000.0, 1000.0, 1000.0, 108, 60, 1
'4NC1_219X147', ! 4km North Carolina grid for C40
'12CONUS1', 1128000.000, -552000.000, 4000.000, 4000.000, 219, 147, 1
'1NCSE1_188X204', ! 1km North Carolina grid for C40
'12CONUS1', 1586000.000, -466000.000, 1000.000, 1000.000, 188, 204, 1
'4NC2', ! 4km North Carolina 201x114 for Kirk Baker WO 120.2
'LAM_40N97W', 1224000.0, -576000.0, 4000.0, 4000.0, 201, 114, 1
'1RTP1', ! 1km North Carolina 108x60 domain for Kirk Baker WO 120.2
'LAM_40N97W', 1584000.0, -324000.0, 1000.0, 1000.0, 108, 60, 1
```
surrogate files
https://www3.epa.gov/ttn/chief/conference/ei15/session9/eyth.pdf

### model evalution tools 
**EPA released a updated package in Nov 2019, the whole program needs to be rebuilt.** 
AMET1.4 has been built, but I have not fully tested AMET1.4. It currently has SQL server issue (I have reported this to EPA and UNC IE).
```
/storage/highspeed/JH/AMET_v14
```
