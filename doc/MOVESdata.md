# MOVESdata
This package is desinged to do data analysis from MOVES2014a/b output. Currently, there are 5 funcitons available in this package.
## 1. move_data_summary <br />
This function will read your design sheet, access all the database related to emissions in this design sheet, extract the data, and combine in one table. It will also do this 
"SELECT countyID, yearID, pollutantID, sourcetypeID, sum(emissionQuant) FROM movesoutput
                    group by countyID, sourceTypeID, pollutantID"
for each scenario (county, year), and save the county table as csv file.

## 2. move_VI_summary <br />
This function will read your design sheet, access all the database related to vehicle information in this design sheet, extract the data, and combine in one table. It will also do this 
"SELECT countyID, yearID, activityTypeID, sourcetypeID, sum(activity) FROM movesactivityoutput
                      group by countyID, sourceTypeID, activityTypeID"
for each scenario (county, year), and save the county table as csv file.

## 3. county_level_map <br />
This funciton will read the move output data or vehilce information data and make a map 

![2025_poll31_countymaps](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/MOVESdata-master/plots/2025_poll31_countymaps.png)

## 4. county_level_stackbar <br />
This funciton will read the move output data or vehilce information data and make a stacked bar plot for each county by source type

![2025_nox_emission](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/MOVESdata-master/plots/2025_PM2.5_emission.png)
![2025_nox_percent](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/MOVESdata-master/plots/2025_PM2.5_percent.png)

## 5. pieplot <br />
This funciton will read the move output data or vehilce information data and make piechart as county composition

![2025_nox_pie](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/MOVESdata-master/plots/2025_NOx_pie.png)

