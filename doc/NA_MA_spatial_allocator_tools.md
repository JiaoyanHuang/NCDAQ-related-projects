# NA_Maintenance_area_emission_tool
This repo is written for the state/local agencies to calculate emissions in NA/maintenance areas which are partial county area
To use this tool, you will need the target area shape file, 4km surrogate files.
Once you have your shape file, you can convert coordinate from UTM to long/lat using coordinate convertor.

## Using coordinate convertor
The file you need is xxx.shp  
st_read, this function will return  
proj4string:    +proj=utm +zone=17 +datum=NAD83 +units=m +no_defs, this will be used in the conversion tool  
then the data will be saved as a csv file with long and lat  

## Calculaing target area fraction
In 2014_4km_surrogate surface  
double check path, GRID, REAL, latmin, latmax, lonmin, lonmax, county_list, SF_code, SF_DESC  

![GSMNP_population_CONUS4k_surrogate](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/NA_Maintenance_area_emission_tool-master/plots/NP_Population_CONUS4k_GRIDCRO2D.png)

![Full_county_population_CONUS4k_surrogate](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/NA_Maintenance_area_emission_tool-master/plots/Population_CONUS4k_GRIDCRO2D.png)


## Target area mask
NA_target area
double check path, GRID, REAL, latmin, latmax, lonmin, lonmax, county_list, SF_code, SF_DESC  

![target area grids](https://github.com/JiaoyanHuang/NCDAQ-related-projects/tree/master/NA_Maintenance_area_emission_tool-master/plots/GSMNP_cell.png)  
blue points are boundary and red points are inside the boundary
