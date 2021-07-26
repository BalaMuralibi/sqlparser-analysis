--liquibase formatted sql

--changeset xtoms:DATES_20210504 RunOnChange:True logicalFilePath:src/changelogs/views/013_DATES.sql
--comment: Creating view for DATES

CREATE OR REPLACE VIEW MARGINDATA.DATES
AS
SELECT
	ROW_VALUE:MK_DatesID::INTEGER AS MK_DATES_ID,
    ROW_VALUE:IsLastTradeDate::BOOLEAN AS IS_LAST_TRADE_DATE,
    ROW_VALUE:IsTradingDay::BOOLEAN AS IS_TRADING_DAY,
    ROW_VALUE:DateID::INTEGER AS DATE_ID
FROM ESA.DATES;