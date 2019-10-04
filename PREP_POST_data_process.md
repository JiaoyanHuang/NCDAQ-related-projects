# CMAQ PREP and POST data processes


https://github.com/USEPA/CMAQ/tree/master/PREP
## MCIP
source files are located in /storage/highspeed/JH/CMAQ_REPO_v5.3/PREP/mcip/src
```
cd /storage/highspeed/JH/CMAQ_REPO_v5.3/PREP/mcip/src
vi Makefile
```
in makefile
```
#...Intel Fortran
FC      = ifort
NETCDF = /storage/highspeed/apps//storage/highspeed/apps/netcdf-c-4.7.0-intel17
NETCDFF = /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17
#NETCDF = /storage/highspeed/apps/netcdf-4.4.1.1_ifc16_disable4/
IOAPI_ROOT = /storage/highspeed/apps/ioapi-3.2_20190925
#IOAPI_ROOT = /storage/highspeed/apps/ioapi-3.2_ifc16_disable_ncf4/
###FFLAGS  = -g -O0 -check all -C -traceback -FR -I$(NETCDF)/include  \
###          -I$(IOAPI_ROOT)/Linux2_x86_64ifort
FFLAGS  = -FR -O3 -traceback -I$(NETCDFF)/include -I$(NETCDF)/include -I$(IOAPI_ROOT)/Linux2_x86_64ifort_intel17
#FFLAGS  = -FR -O3 -traceback -I$(NETCDF)/include -I$(IOAPI_ROOT)/Linux2_x86_64ifort_intel

LIBS    = -L$(IOAPI_ROOT)/Linux2_x86_64ifort_intel17 -lioapi \
          -L$(NETCDFF)/lib -lnetcdff -L$(NETCDF)/lib -lnetcdf -qopenmp
make clean
make |& tee make.mcip.log
```
If things go well, you will see a mcip.exe built.

## ICON
ICON exe was built in 
/storage/highspeed/Models/aq/CMAQ/CMAQ_v5.3/PREP/icon/scripts. This blidt script is based on config_cmaq.csh two levels upper.

```
./bldit_icon.csh |& tee bldit_icon.log
```

## BCON
BCON exe was built in 
/storage/highspeed/Models/aq/CMAQ/CMAQ_v5.3/PREP/bcon/scripts. This blidt script is based on config_cmaq.csh two levels upper.

```
./bldit_bcon.csh |& tee bldit_bcon.log
```


https://github.com/USEPA/CMAQ/tree/master/POST
## combine function
This Fortran program combines fields from a set of IOAPI or wrfout input files to an output file. The file assigned to environmental variable SPECIES_DEF defines the new species variables and how they are constructed.

```
bldit_combine.csh |& tee bldit_combine.log
```
to run combine uses run_combine.csh
```
vi run_combine.csh
```
in run script
make sure following vars are correct.
```
 set VRSN      = v53               #> Code Version
 set PROC      = mpi               #> serial or mpi
 set MECH      = cb6r3_ae7_aq      #> Mechanism ID
 set APPL      = Bench_2016_12SE1         #> Application Name (e.g. Gridname)

 setenv METDIR     ${CMAQ_DATA}/2016_12SE1/met/mcipv5.0            #> Met Output Directory
 setenv CCTMOUTDIR ${CMAQ_DATA}/output_CCTM_${RUNID}      #> CCTM Output Directory
 setenv POSTDIR    ${CMAQ_DATA}/POST                      #> Location where combine file will be written

#> Set Start and End Days for looping
 set START_DATE = "2016-07-01"     #> beginning date (July 1, 2016)
 set END_DATE   = "2016-07-14"     #> ending date    (July 14, 2016)

#> Set location of species definition files for concentration and deposition species.
 setenv SPEC_CONC $REPO_HOME/POST/combine/scripts/spec_def_files/SpecDef_${MECH}.txt
 setenv SPEC_DEP  $REPO_HOME/POST/combine/scripts/spec_def_files/SpecDef_Dep_${MECH}.txt

  #> Define name of input files needed for combine program.
  #> File [1]: CMAQ conc/aconc file
  #> File [2]: MCIP METCRO3D file
  #> File [3]: CMAQ APMDIAG file
  #> File [4]: MCIP METCRO2D file
   setenv INFILE1 $CCTMOUTDIR/CCTM_ACONC_${RUNID}_$YYYY$MM$DD.nc
   setenv INFILE2 $METDIR/METCRO3D_$YY$MM$DD.nc
   setenv INFILE3 $CCTMOUTDIR/CCTM_APMDIAG_${RUNID}_$YYYY$MM$DD.nc
   setenv INFILE4 $METDIR/METCRO2D_$YY$MM$DD.nc

  #> Define name of input files needed for combine program.
  #> File [1]: CMAQ DRYDEP file
  #> File [2]: CMAQ WETDEP file
  #> File [3]: MCIP METCRO2D
  #> File [4]: {empty}
   setenv INFILE1 $CCTMOUTDIR/CCTM_DRYDEP_${RUNID}_$YYYY$MM$DD.nc
   setenv INFILE2 $CCTMOUTDIR/CCTM_WETDEP1_${RUNID}_$YYYY$MM$DD.nc
   setenv INFILE3 $METDIR/METCRO2D_$YY$MM$DD.nc
```

Also this combine run script include two parts: ACONC and DEP

## hr2day
This Fortran program creates gridded IOAPI files with daily values from gridded IOAPI files containing hourly values.

```
./bldit_hr2day.csh |& tee bldit_hr2day.log
```
to run hr2day uses run_hr2day.csh
Make sure following things are correct.
```
#> Set General Parameters for Configuring the Simulation
 set VRSN      = v53               #> Code Version
 set PROC      = mpi               #> serial or mpi
 set MECH      = cb6r3_ae7_aq      #> Mechanism ID
 set APPL      = Bench_2016_12SE1         #> Application Name (e.g. Gridname)

#> ending hour for daily metrics (default is 23)
 setenv END_HOUR 23

#> Number of 8hr values to use when computing daily maximum 8hr ozone.
#> Allowed values are 24 (use all 8-hr averages with starting hours
#> from 0 - 23 hr local time) and 17 (use only the 17 8-hr averages
#> with starting hours from 7 - 23 hr local time)
 setenv HOURS_8HRMAX 24
# setenv HOURS_8HRMAX 17

#> define species (format: "Name, units, From_species, Operation")
#>  operations : {SUM, AVG, MIN, MAX, @MAXT, MAXDIF, 8HRMAX, SUM06}
 setenv SPECIES_1 "O3_HRMAX,ppbV,O3,8HRMAX"
 setenv SPECIES_2 "O3,ppbV,O3,AVG"
 setenv SPECIES_3 "NOX,ppbV,NOX,AVG"
# setenv SPECIES_4 "VOC,ppbV,VOC,AVG"
 setenv SPECIES_4 "PM25,ug m-3,PM25_TOT,AVG"
#> Optional desired first and last processing date. The program will
#> adjust the requested dates if the desired range is not covered by
#> the input file(s). If these dates are not specified, the processing
#> will be performed for the longest possible time record that can be
#> derived from the model input file(s)
 setenv START_DATE 2016182

```

