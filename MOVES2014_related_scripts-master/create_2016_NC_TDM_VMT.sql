USE `nc_county_vmt_speeds`;

DROP TABLE IF EXISTS `nc_county_vmt_speeds`.`MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017`;
CREATE TABLE `nc_county_vmt_speeds`.`MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` (
 `countyID` 		int(10) unsigned DEFAULT NULL,
 `modelingDate`		date,
 `datasetName` 		varchar(50), 
 `yearID` smallint(5) unsigned DEFAULT NULL,
 `wholeCounty` 		tinyint(1) unsigned DEFAULT NULL,
 `dataSource` 		varchar(5),
 `funcClass` 		varchar(30),
 `funcClassCode` 	smallint(5) unsigned DEFAULT NULL,
 `travelPeriod`	varchar(12),
 `travelPeriodID` smallint(5) unsigned DEFAULT NULL, 
 `2015_AADVMT` 		double DEFAULT NULL,
 `2015_Speed` 		double DEFAULT NULL,
 `2025_AADVMT` 		double DEFAULT NULL,
 `2025_Speed` 		double DEFAULT NULL,
 `2017_AADVMT_Intrpltd` double DEFAULT NULL,
 `2017_Speed_Intrpltd`	double DEFAULT NULL,
 `Scenario` tinyint(1) unsigned DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- LOAD DATA LOCAL INFILE 'P:/Planning/ATTAINMT/ONROAD/MOVES_Raw_Data/TDM_VMT_Speeds/working_DB_fomat/Metrolina_2045_MTP_TDM_VMT_Speeds.tab' INTO TABLE `nc_county_vmt_speeds`.`Metrolina_2045_MTP_VMT_Speeds`
--  FIELDS TERMINATED BY '\t'
--  LINES TERMINATED BY '\n'
--  IGNORE 1 LINES;

INSERT INTO `MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` 
SELECT `countyID`,`modelingDate`, `datasetName`, "2017" as `yearID`, `wholeCounty`, `dataSource`,`funcClass`, `funcClassCode`, `travelPeriod`, `travelPeriodID`, `AADVMT`, `Speed` ,NULL ,NULL, NULL, NULL, `Scenario`	
FROM `nc_county_vmt_speeds`.`MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty`
WHERE `yearID` = 2015
ORDER BY `countyID`, `modelingDate`, `funcClassCode`, `travelPeriodID`;

-- GROUP BY `yearID`
   
UPDATE `MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` a, (SELECT `countyID`, `modelingDate`, `datasetName`, `yearID`, `funcClassCode`, `travelPeriod`, `travelPeriodID`, `AADVMT`, `Speed` FROM `nc_county_vmt_speeds`.`MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty` WHERE `yearID` = 2025) b
SET `a`.`2025_AADVMT` = `b`.`AADVMT`, `a`.`2025_Speed` = `b`.`Speed`
WHERE `a`.`countyID`=`b`.`countyID` AND `a`.`modelingDate`=`b`.`modelingDate` AND `a`.`datasetName`=`b`.`datasetName` AND `a`.`funcClassCode`=`b`.`funcClassCode` AND `a`.`travelPeriodID`=`b`.`travelPeriodID`;

UPDATE `MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` a
SET `a`.`2017_AADVMT_Intrpltd` = `a`.`2015_AADVMT` +  (`a`.`2025_AADVMT` - `a`.`2015_AADVMT`)*(2017-2015)/(2025-2015), 
    `a`.`2017_Speed_Intrpltd` = `a`.`2015_Speed` +  (`a`.`2025_Speed` - `a`.`2015_Speed`)*(2017-2015)/(2025-2015);
    
UPDATE `MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` a
SET `a`.`2017_AADVMT_Intrpltd` = 0, `a`.`2017_Speed_Intrpltd` = 0
WHERE `a`.`funcClassCode` = 350 and `a`.`countyID` IN (37097, 37179);    

UPDATE `MRM18v1dot1_2045MTP_VMT_Speeds_FullCounty_interpolated_2017` a
SET `a`.`2017_AADVMT_Intrpltd` = 0, `a`.`2017_Speed_Intrpltd` = 0
WHERE `a`.`funcClassCode` = 350 and `a`.`countyID` = 37119 and `a`.`travelPeriodID` IN (2, 4);    

-- 
-- `2025_AADVMT` 	
-- `2025_Speed`
-- `2017_AADVMT` 	
-- `2017_Speed` 	`yearID`,  `pollutantID`, `pollutantName`, sum(`totalEmissionQuant`) AS `annualEmissionQuant_NMAA`, 0.0 AS `annualEmissionQuant_TDM`, 0.0 AS `totalAnnualEmissionQuant`
