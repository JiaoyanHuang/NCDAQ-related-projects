CREATE DATABASE IF NOT EXISTS `nc_county_vmt_speeds`;

DROP TABLE IF EXISTS `nc_county_vmt_speeds`.`HPMS_2016_VMT`;
CREATE TABLE `nc_county_vmt_speeds`.`HPMS_2016_VMT` (
 `countyID` int(10) unsigned DEFAULT NULL,
 `modelingDate`	date,
 `datasetName` varchar(50),
 `yearID` smallint(5) unsigned DEFAULT NULL,
 `wholeCounty` tinyint(1) unsigned DEFAULT NULL,
 `dataSource` varchar(5),
 `funcClass` varchar(30),
 `funcClassCode` smallint(5) unsigned DEFAULT NULL,
 `travelPeriod` varchar(12),
 `travelPeriodID` smallint(5) unsigned DEFAULT NULL, 
 `AADVMT` double DEFAULT NULL,
 `Speed` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

LOAD DATA LOCAL INFILE 'V:/ONROAD/MOVES_Raw_Data/HPMS_VMT/2016/2016_NC_HPMS_VMT_By_County-AADVMT.tab' INTO TABLE `nc_county_vmt_speeds`.`HPMS_2016_VMT`
  FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
