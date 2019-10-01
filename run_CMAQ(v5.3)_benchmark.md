# run CMAQv5.3 bechmark 
How to install WRF CMAQ related libs and programs
```
cd /storage/highspeed/Models/aq/CMAQ/CMAQ_v5.3/CCTM/scripts
cp run_cctm_Bench_2016_12SE1.csh run_cctm_Bench_2016_12SE1.csh.orig
vi run_cctm_Bench_2016_12SE1.csh
set PROC      = mpi 
@ NPCOL  =  2; @ NPROW =  4
```

After configuring the MPI settings for your Linux system, check the rest of the script to ensure the correct path, date and names are used for the input data files. Per the note above, different Linux systems have different requirements for submitting MPI jobs. The command below is an example of how to submit the CCTM run script and may differ depending on the MPI requirements of your Linux system.
```
./run_cctm_Bench_2016_12SE1.csh |& tee cctm.log
```
To confirm that the benchmark case ran to completion view the run.benchmark.log file. For MPI runs, check each of the CTM_LOG_[ProcessorID]*.log files. A successful run will contain the following line at the bottom of the log(s):
```
>>----> Program completed successfully <----<<
```
Note: If you are running on multiple processors the log file for each processor is also moved from the $CMAQ_HOME/CCTM/scripts directory to the benchmark output directory:
```
$CMAQ_DATA/output_CCTM_v53_[compiler]_Bench_2016_12SE1
```
