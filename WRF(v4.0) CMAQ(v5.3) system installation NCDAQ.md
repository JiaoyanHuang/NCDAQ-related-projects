WRF(v4.0) CMAQ(v5.3) system installation
======

How to install WRF CMAQ related libs and programs in NCDAQ cluster computer

This guidence is based on following websites

CMAQ_UG_tutorial_build_library_intel.md
https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_build_library_intel.md

CMAQ_UG_tutorial_benchmark.md
https://github.com/JiaoyanHuang/CMAQ/blob/master/DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_benchmark.md

IOAPI
https://www.cmascenter.org/ioapi/documentation/all_versions/html/TUTORIAL.html
https://github.com/cjcoats/ioapi-3.2

NETCDF
https://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html
https://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html

Overall 
https://blog.chenzhang.org/post/gis/cmaq-installation/

created by Joey Huang 2019/10/01

0. Make sure you have fortran compiler ready, here are what I have in my .cshrc, you can add these manually, but I suggest to have all these in .cshrc. You will also have to update these based you the most current intel compiler we have on the cluster.
```
##INTEL v17.0.4
setenv INTEL_DIR /storage/highspeed/apps/intel
source $INTEL_DIR/bin/compilervars.csh intel64
source $INTEL_DIR/parallel_studio_xe_2017.4.056/bin/psxevars.csh intel64
source $INTEL_DIR/compilers_and_libraries_2017.4.196/linux/mpi/intel64/bin/mpivars.csh intel64
source ~/mvapich2_vars.csh
```

1. create a dir for source code, you can do this in home or /storage/highspeed/JH (this is Joey's data dir, you can create yours). You can select any version you want for netcdf

```
mkdir netcdf
cd netcdf
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-4.7.0.tar.gz
```

2. Untar the file 

```
tar -xzvf netcdf-c-4.7.0.tar.gz
cd netcdf-c-4.7.0
```

3. Review the installation instructions for netcdf-c-4.7.0 for building Classic netCDF

```
more INSTALL.md
```

4. Create a target installation directory that includes the loaded module environment name. You can also, build this in your data dir (/storage/highspeed/JH), once you successfully make it, you can then rebuild it in /storage/highspeed/apps

```
mkdir /storage/highspeed/apps/netcdf-c-4.7.0-intel17
```

5. Run the configure --help command to see what settings can be used for the build. All the option can be found in 
https://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html configure options
```
./configure --help
```

6. Set the Compiler environment variables

First find the path to the CC compiler on your system using the which command
```
which icc
/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc
```
Next, replace the following path in the setenv command below to use the path to your CC compiler


Liz suggests this
```
setenv CC "storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc"
```
but I prefer this
```
setenv CC icc
```

Find the path to the Fortran compiler on your ssystem using the which command
```
which ifort
```
Next, replace the following path in the setenv command below to use the path to the Fortran compiler on your system
```
setenv FC ifort
```

Find the path to the CXX compiler on your system using the which command
```
which icpc
```
Next, replace the following path in the setenv command below to use the path to the CXX compiler on your system:
```
setenv CXX icpc
```
just for your reference

[jhuang@ncaqc2017 ~]$ which icc

/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc

[jhuang@ncaqc2017 ~]$ which icc

/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc

[jhuang@ncaqc2017 ~]$ which ifort

/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/ifort

[jhuang@ncaqc2017 ~]$ which icpc

/storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icpc

[jhuang@ncaqc2017 ~]$ which mpirun

/storage/highspeed/apps/mvapich2-2.2_ifc17/bin/mpirun


Finally, set your installation location netcdf-c-dir (NCDIR)
```
setenv NCDIR /storage/highspeed/apps/netcdf-c-4.7.0-intel17
```

7. Run the configure command

```
./configure --prefix=$NCDIR --disable-netcdf-4 --disable-dap
```

11. Check that the configure command worked correctly, you can also do make check and make install separately

```
make check install |& tee make.install.log.txt
```

12. Verify that the following message is obtained at the end of your make.install.log.txt file

```
| Congratulations! You have successfully installed netCDF!    |
```

you can check any error during make by

```
grep ERROR make.install.log.txt
grep FAIL make.install.log.txt
```

## Install netCDF-Fortran

1. Download netCDF-Fortran from the following website https://www.unidata.ucar.edu/downloads/netcdf/index.jsp

```
cd ~/netcdf
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.5.tar.gz 
tar -xzvf netcdf-fortran-4.4.5.tar.gz
cd netcdf-fortran-4.4.5
```

2. Make an install directory that matches the name of your loaded module environment

```
mkdir /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17
```

3. Review the installation document http://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html

4. Set the environment variable NCDIR, this is not necessary since we set this up in previous process, but it does not hurt to do it again

```
setenv NCDIR /storage/highspeed/apps/netcdf-c-4.7.0-intel17
```

5. Set the CC environment variable to use the intel compilers, again, this is not necessary, we did all these in previous process.

First find the path to the CC compiler on your system using the which command
```
which icc
```
Next, replace the following path in the setenv command below to use the path to your CC compiler
```
setenv CC icc
```

Find the path to the Fortran compiler on your ssystem using the which command
```
which ifort
```
Next, replace the following path in the setenv command below to use the path to the Fortran compiler on your system
```
setenv FC ifort
```

Find the path to the CXX compiler on your system using the which command
```
which icpc
```

8. Set your LD_LIBRARY_PATH to include the netcdf-C library path for netCDF build

```
setenv LD_LIBRARY_PATH ${NCDIR}/lib:${LD_LIBRARY_PATH}
```

9. Check your LD_LIBRARY_PATH

```
echo $LD_LIBRARY_PATH
```

10. Set the install directory for netCDF fortran

```
setenv NFDIR /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17
setenv CPPFLAGS -I${NCDIR}/include
setenv LDFLAGS -L${NCDIR}/lib
```

11. check your LD_LIBRARY_PATH environment variable, make sure netcdf-c-4.7.0-intel17/lib included in LD_LIBRARY_PATH

```
echo $LD_LIBRARY_PATH
```

12. Run the configure command

```
./configure --prefix=${NFDIR}
```

13. Run the make check command

```
make check |& tee make.check.log.txt
```

Output if successful:

```
Testsuite summary for netCDF-Fortran 4.4.5
==========================================
# TOTAL: 6
# PASS:  6
```

14. Run the make install command

```
make install |& tee ./make.install.log.txt
```

Output successful if you see:

```
Libraries have been installed in:
   
   /home/netcdf-fortran-4.4.5-intel18.2

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the '-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'
```

if everything goes well

[jhuang@ncaqc2017 ~]$ which nf-config
/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/bin/nf-config
[jhuang@ncaqc2017 ~]$ nf-config --all

This netCDF-Fortran 4.4.5 has been built with the following features:

  --cc        -> /storage/highspeed/apps/intel/compilers_and_libraries_2017.4.196/linux/bin/intel64/icc
  
  --cflags    ->  -I/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/include -I/storage/highspeed/apps/netcdf-c-4.7.0-intel17//include

  --fc        -> ifort
  
  --fflags    -> -I/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/include
  
  --flibs     -> -L/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/lib -lnetcdff -L/storage/highspeed/apps/netcdf-c-4.7.0-intel17//lib -lnetcdf -lnetcdf -lhdf5_hl -lhdf5 -lz -lcurl -lm
  
  --has-f90   -> no
  
  --has-f03   -> yes

  --has-nc2   -> yes
  
  --has-nc4   -> no

  --prefix    -> /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17
  
  --includedir-> /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/include
  
  --version   -> netCDF-Fortran 4.4.5



15. set your LD_LIBRARY_PATH to include the netcdf-Fortran library path for netCDF build

```
setenv NFDIR /home/netcdf-fortran-4.4.5-intel18.2
setenv LD_LIBRARY_PATH ${NFDIR}/lib:${LD_LIBRARY_PATH}
```
(may need to add the NCDIR and NFDIR to .cshrc)

Here are what I added to my .cshrc

setenv PATH './:${PATH}:${HOME}:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/storage/highspeed/apps/bin:/usr/local/aq/opengrads:/storage/highspeed/apps/SMOKEv4.5/subsys/smoke/Linux2_x86_64iforti:/storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/lib:/storage/highspeed/apps/netcdf-c-4.7.0-intel17/lib'

set path = ($path /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/bin)

set NETCDF_ROOT = /storage/highspeed/apps/netcdf-fortran-4.4.5-intel17/bin


## Install I/O API

0. you can do this under /storage/highspeed/apps or test it first under your data dir or home dir

1. Download I/O API

```
git clone https://github.com/cjcoats/ioapi-3.2 ioapi-3.2_20190925
```
this will download IOAPI 3.2 to a different dir under the location you want

2. Change the BIN setting on line 133 of the Makefile to include the loaded module name

```
cp Makefile.template Makefile
vi Makefile
BIN        = Linux2_x86_64ifort_intel17
```

3. Change the NCFLIBS setting on line 141 of the Makefile to be

```
NCFLIBS    = -lnetcdff -lnetcdf
```

4. Copy an existing Makeinclude file to have this BIN name at the end

```
cd ioapi
cp Makeinclude.Linux2_x86_64ifort Makeinclude.Linux2_x86_64ifort_intel17
```

5. Edit the Makeinclude file, lines 27 and 28 to use -qopenmp instead of -openmp

```
OMPFLAGS  = -qopenmp
OMPLIBS   = -qopenmp
```

6. Set the environment variable BIN

```
setenv BIN Linux2_x86_64ifort_intel17
```

7. Create a BIN directory under the ioapi-3.2 directory

```
cd ..
mkdir $BIN
```

8. Link the netcdf-C and netcdf-Fortran library in the $BIN directory

```
cd $BIN
ln -s /home/netcdf-c-4.7.0-intel18.2/libnetcdf.a
ln -s /home/netcdf-fortran-4.4.5-intel18.2/libnetcdffa
```

9. Run the make command to compile and link the ioapi library

```
make all |& tee make.log
```

10. Change directories to the $BIN dir and verify that both the libioapi.a and the m3tools were successfully built

```
cd $BIN
ls -lrt libioapi.a
ls -rlt m3xtract
```

11. After successfull completion of this tutorial, the user is now ready to proceed to the [CMAQ Installation & Benchmarking Tutorial](./CMAQ_UG_tutorial_benchmark.md). 

