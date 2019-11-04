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

the longest one will take about 23 hrs, but it is still managable.

## extract files
## setup scripts
## run scripts
## merge data
