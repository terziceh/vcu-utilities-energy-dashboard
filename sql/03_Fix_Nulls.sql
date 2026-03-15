/* ===========================
Looking into the missing rows before filtering (duplicates and missings)
Database: BI_HUD
Table: dbo.utility_fy19_25
Author: Ethan Terzic
Date: 2/25/2026
Purpose: To figure out what is going on with the total row difference and see why they aren't on a unique grain.

 =========================== */



WITH dup_keys as  (
	SELECT 
	TRIM(COALESCE([FY],''))		AS FY,
	TRIM(COALESCE([Reporting_Month],''))		AS Reporting_Month,
	TRIM(COALESCE([Type],''))		AS [Type],
	TRIM(COALESCE([Index],''))		AS [Index],
	TRIM(COALESCE([Bldg],''))		AS Bldg,
	COUNT (*) as rows_in_group
FROM dbo.utility_fy19_25
GROUP BY 
	TRIM(COALESCE([FY],'')),
	TRIM(COALESCE([Reporting_Month],'')),
	TRIM(COALESCE([Type],'')),
	TRIM(COALESCE([Index],'')),
	TRIM(COALESCE([Bldg],''))
HAVING COUNT(*) > 1
)
SELECT TOP 50 *
FROM dup_keys
ORDER BY rows_in_group DESC;

-- This was meant to look at if there were alot of account being flagged as duplicates.
-- It seems that were alot we need to find the exact amount and explain why this is the case I have a hunch it's on the meter numbers. 


SELECT 
	COUNT(*) as total_rows,
	COUNT(
		DISTINCT CONCAT(
			TRIM(COALESCE([FY], '')), '|',
			TRIM(COALESCE([Reporting_Month], '')), '|',
			TRIM(COALESCE([Type], '')), '|',
			TRIM(COALESCE([Index], '')), '|',
			TRIM(COALESCE([Bldg], '')), '|',
			TRIM(COALESCE([Account], '')), '|',
			TRIM(COALESCE([Meter], '')), '|'
		)) AS distinct_key
	FROM dbo.utility_fy19_25;

-- It's looking much better now. At 70378 distinct keys, but I still need to diagnose why over 26k are missing.
-- Lets take a look at the rows that aren't considered distinct



SELECT 
	COUNT(*) as total_rows,

	SUM(CASE WHEN NULLIF(TRIM([FY]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_fy,
	SUM(CASE WHEN NULLIF(TRIM([Reporting_Month]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_reporting_month,
	SUM(CASE WHEN NULLIF(TRIM([Bldg]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_bldg,
	SUM(CASE WHEN NULLIF(TRIM([Type]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_type,
	SUM(CASE WHEN NULLIF(TRIM([Index]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_index,
	SUM(CASE WHEN NULLIF(TRIM([Account]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_account,
	SUM(CASE WHEN NULLIF(TRIM([Meter]),'') IS NULL THEN 1 ELSE 0 END)	AS missing_meter,

	SUM(CASE WHEN
		NULLIF(TRIM([FY]),'') IS NULL
	AND	NULLIF(TRIM([Reporting_Month]),'') IS NULL
	AND	NULLIF(TRIM([Bldg]),'') IS NULL
	AND	NULLIF(TRIM([Type]),'') IS NULL
	AND	NULLIF(TRIM([Index]),'') IS NULL
	AND	NULLIF(TRIM([Account]),'') IS NULL
	AND	NULLIF(TRIM([Meter]),'') IS NULL
	THEN 1 ELSE 0 END) as key_parts_missing

FROM dbo.utility_fy19_25;

--So it looks like there might be a ton of null entries since key_parts_missing came out with 25349 rows.
--Let me go through them see if they are nulls then remove so its just relevant data, then we can start with what we need.


SELECT TOP 50 *
FROM dbo.utility_fy19_25
WHERE NULLIF(TRIM([FY]),'') IS NULL
	AND NULLIF(TRIM([Bldg]),'') IS NULL
	AND NULLIF(TRIM([Type]),'') IS NULL
	AND NULLIF(TRIM([Index]),'') IS NULL
	AND NULLIF(TRIM([Account]),'') IS NULL
	AND NULLIF(TRIM([Meter]),'') IS NULL;

--They seem to be all nulls lets do one more check then we can remove the nulls and progress to the next step before staging.

SELECT Count(*) Rows_stuff
FROM dbo.utility_fy19_25
WHERE 
	NULLIF(TRIM([FY]),'') IS NULL
	AND NULLIF(TRIM([Bldg]),'') IS NULL
	AND NULLIF(TRIM([Type]),'') IS NULL
	AND NULLIF(TRIM([Index]),'') IS NULL
	AND NULLIF(TRIM([Account]),'') IS NULL
	AND NULLIF(TRIM([Meter]),'') IS NULL
	AND NULLIF(TRIM([Reporting_Month]),'') IS NULL 
	
	AND(
		NULLIF(TRIM([Provider]), '') IS NOT NULL
	OR	NULLIF(TRIM([Amount_Due]), '') IS NOT NULL
	OR	NULLIF(TRIM([Balancer]), '') IS NOT NULL
	OR	NULLIF(TRIM([Total_Usage]), '') IS NOT NULL
	OR	NULLIF(TRIM([Rates]), '') IS NOT NULL
	OR	NULLIF(TRIM([Bldg_Concatenate]), '') IS NOT NULL
	OR	NULLIF(TRIM([Type]), '') IS NOT NULL
	);

--Looks like there are 12 rows with some data so we need to check those before the filter.

SELECT *
FROM dbo.utility_fy19_25
WHERE 
	NULLIF(TRIM([FY]),'') IS NULL
	AND NULLIF(TRIM([Bldg]),'') IS NULL
	AND NULLIF(TRIM([Type]),'') IS NULL
	AND NULLIF(TRIM([Index]),'') IS NULL
	AND NULLIF(TRIM([Account]),'') IS NULL
	AND NULLIF(TRIM([Meter]),'') IS NULL
	AND NULLIF(TRIM([Reporting_Month]),'') IS NULL 
	
	AND(
		NULLIF(TRIM([Provider]), '') IS NOT NULL
	OR	NULLIF(TRIM([Amount_Due]), '') IS NOT NULL
	OR	NULLIF(TRIM([Balancer]), '') IS NOT NULL
	OR	NULLIF(TRIM([Total_Usage]), '') IS NOT NULL
	OR	NULLIF(TRIM([Rates]), '') IS NOT NULL
	OR	NULLIF(TRIM([Bldg_Concatenate]), '') IS NOT NULL
	OR	NULLIF(TRIM([Type]), '') IS NOT NULL
	);

-- These look to be just null rows with accidental 0s in usage and total amount we should be good to remove the rows missing.

