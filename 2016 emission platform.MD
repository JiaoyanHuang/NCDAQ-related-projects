How to process 2016 EMP data into CMAQ ready data files.

http://views.cira.colostate.edu/wiki/wiki/10202

https://www.epa.gov/sites/production/files/2019-09/documents/2016v7.2_regionalhaze_emismod_tsd_508.pdf

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
example
```
./Annual_beis_12US2_2016fh_16j.csh |& tee ./Annual_beis_12US2_2016fh_16j.log
```
You can do any way you want, this way I can monitor the runscript status and have a log file once it is done.

1. look into error, if no error, the message should be
```
now checking log file /storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/intermed/beis/logs/smkmerge_beis_2016fh_16j_20161231_12US2_cmaq_cb6.log
grep: /storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/intermed/beis/logs: Is a directory
grep: /storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/intermed/beis/logs: Is a directory
log analyzer
Getting message data (might take some time)....
Finished getting data
Classifying message types...
Total number of known messages: 202602
Total number of unknown messages: 0
Level 3 analysis...
Finished classifying message types
grep: /storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/intermed/beis/logs: Is a directory
grep: /storage/highspeed/JH/EMP_2016/newftp.epa.gov/air/emismod/2016/v1/2016emissions/2016fh_16j/intermed/beis/logs: Is a directory
log analyzer
Getting message data (might take some time)....
Finished getting data
Classifying message types...
Total number of known messages: 202602
Total number of unknown messages: 0
Level 1 analysis...
Finished classifying message types
Testing for exit priority <=  1
All message priorities >  1
```
If you see an error, you have to look into log files for detail information 
```
[jhuang@ncaqc2017 logs]$ pwd
/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/2016emissions/2016ff_16j/intermed/ptfire3D/logs
[jhuang@ncaqc2017 logs]$ grep ERROR *
laypoint_ptfire3D_jan_2016ff_16j_20160101_12US2.log:     *** ERROR ABORT in subroutine LAYPOINT
smkinven_ptfire3D_2016ff_16j.log:     Value for SMK_MAXERROR:  10000
spcmat_ptfire3D_2016ff_16j_cmaq_cb6.log:     Value for SMK_MAXERROR:  10000
spcmat_ptfire3D_2016ff_16j_cmaq_cb6.log:     Value for DEFAULT_CONV_FAC_ERROR not defined;returning default:   FALSE
temporal_ptfire3D_jan_2016ff_16j_20160101.log:     Value for SMK_MAXERROR:  10000
```
This ERROR ABORT is the key message for the error, others are not real error message
```
vi laypoint_ptfire3D_jan_2016ff_16j_20160101_12US2.log
```
in the end of the file it shows 
```
     MET_DOT_3D      :/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met_for_emissions/12US2/METDOT3D_160101

     >>--->> WARNING in subroutine OPEN3
     File not available.

     Could not open file "MET_DOT_3D".

     *** ERROR ABORT in subroutine LAYPOINT
     Could not open file "MET_DOT_3D".
```
which means DOT_3D files are missing
for ptfire REPCONFIG files are not correct in Annual_ptfire_onetime_12US2_2016ff_16j.csh
these runscirpts look for AREA, but actually it needs POINT not AREA

log files are located in intermed dir/log and some output files are located in premerged and some are located in smoke_out

After looking log files, you have to check the output files size and timeframe.
SMOKE genearates daily files for some sectors, weekend/holiday/weekday files for some, 1 file for a month for some sectors, please read TSD and SMOKE manual for detailed information.

eventaully, these files will be filled up by merge function

### onroad
#### met2moves
```
cd /storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/scripts/met4moves
vi run_metcombine_2016j_12US2.csh
```
you have to make sure BASEDIR, OUTDIR, MET_ROOT are the location you want
```
./run_metcombine_2016j_12US2.csh | & tee run_metcombine_2016j_12US2.log
```
then 
```
vi run_met4moves_2016j_v2_12US2.csh
```

## merge data
run 
```
scripts/merge/Sector_merge_12US1_2016ff_16j.csh
```
make sure following variables are all good
```
# Input files
# Base dir
setenv BASEDIR /storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met2moves
setenv GE_DAT /storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/2016emissions/ge_dat
setenv MCXREF $GE_DAT/onroad/MCXREF_2014v2_10jul2017_v0
setenv MFMREF $GE_DAT/onroad/MFMREF_2014v2_10jul2017_v0
#setenv SRGPRO_PATH $GE_DAT/gridding/surrogates/CONUS12_2014_v1.3_29nov2016
setenv SRGPRO_PATH $GE_DAT/gridding/surrogates/CONUS12_2014_03dec2018
#setenv SRGDESC $GE_DAT/gridding/srgdesc_CONUS12_2014_v1_3_29nov2016_18apr2017_v0.txt
setenv SRGDESC $GE_DAT/gridding/srgdesc_CONUS12_2014_v1_3_29nov2016_13oct2017_v1.txt
#setenv COSTCY $GE_DAT/costcy_for_2007platform_25may2017_v21.txt
setenv COSTCY $GE_DAT/costcy_for_2007platform_28nov2018_nf_v23.txt
#setenv GRIDDESC $GE_DAT/gridding/griddesc_lambertonly_18sep2015_v64.txt
setenv GRIDDESC $GE_DAT/gridding/griddesc_lambertonly_29nov2018_nf_v7.txt

setenv METLIST  $BASEDIR/metfile_list.${GRID}_${METABBREV}.txt
```
This means you starting date and ending date, but it needs the data a day before and after 
```
setenv STDATE ${YEAR}001               # Starting date in Julian
setenv ENDATE ${YEAR}366               # Ending date in Julian (should be 366 for leap year)
```
I just use m3tshift to generate this data, if you have actual data, you can use them as well
```
setenv INFILE METCOMBO_161231
setenv OUTFILE METCOMBO_170101
m3tshift
```
you have to manually add the first and the last line in metfile_list.12US2_16j.txt if you want to generate 2016010 to 20161231 data
/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met2moves/12US2_16j/METCOMBO_151231
...
...
/storage/highspeed/JH/EMP_2016_beta/newftp.epa.gov/air/emismod/2016/beta/met2moves/12US2_16j/METCOMBO_170101





## 4km NC
### generate MCIP files
### how to nest domain
### tools
<pre>
IOAPI
     m3wndw
     m3mask
</pre>
Domain Wizard
https://esrl.noaa.gov/gsd/wrfportal/DomainWizard.html
