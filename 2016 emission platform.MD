How to process 2016 EMP data into CMAQ ready data files.
## Data download
ftp://newftp.epa.gov/air/emismod/2016/v1/

the easiest way is using 
```
wget -r ftp://newftp.epa.gov/air/emismod/2016/v1/
```

However, the speed is about 2mb/s, and the connection is unstable, I usually do wget one dir by one dir, eg
```
wegt -r ftp://newftp.epa.gov/air/emismod/2016/v1/2016emissions/
wegt -r ftp://newftp.epa.gov/air/emismod/2016/v1/2020emissions/
...
...
```
the longest one will take about 23 hrs, but it is still manageable. you can also download beta files if you would like to test beta data. Also, 12km CMAQ ready data for 12US1 or 12US2 will be ready on https://views.cira.colostate.edu/iwdw/RequestData/Default.aspx.

## extract files

there are a couple of ways to do it:
```
find . -name "*.zip" -exec unzip {} \
unzip '*.zip'
find -iname \*.tar -exec tar -xvf {} \
```
you can google online, in general stackoverflow has some answers.

## setup scripts
EMP path released from EPA is not clean, but I usually set
```
setenv INSTALL_DIR "/storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions"
setenv MET_ROOT "/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met_for_emissions/12US2"
setenv MET_ROOT_3D "/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met_for_emissions/12US2"
```
double check all variables in the directory_definitions_12US2.csh or 12US1 or 4kmNC

make sure ge_dat, script inside 
```
/storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j
```
and ge_dat, ioapi, and smoke4.7 in the level of 
```
/storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions
```
## run scripts
all initial scripts are located in and separated by biogenics, nonpoint, point, onroad
```
/storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/scripts
```
log files are located in intermed dir/log and some output files are located in premerged and some are located in smoke_out
## merge data
run 
```
scripts/merge/Sector_merge_12US1_2016ff_16j.csh
```
