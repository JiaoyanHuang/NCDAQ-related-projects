SELECT 
`countyID`, `modelingDate`, `datasetName`, `yearID`, `wholeCounty`,
`dataSource`, `funcClass`, `funcClassCode`, `travelPeriod`, `travelPeriodID`,
`2017_AADVMT_Intrpltd`, `2017_Speed_Intrpltd`, `Scenario`
FROM `nc_county_vmt_speeds`.`mrm18v1dot1_2045mtp_vmt_speeds_fullcounty_interpolated_2017`
ORDER BY `countyID`, `yearID`, `travelPeriodID`, `funcClassCode`;
