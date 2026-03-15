
/* ===========================
Data Profiling for the utility FY19-25 dataset
Database: BI_HUD
Table: dbo.utility_fy19_25
Author: Ethan Terzic
Date: 2/25/2026
Purpose: Check the health and structure of the dataset before prepping it for EDA in Excel

 =========================== */

SELECT COUNT(*) as total_rows
FROM dbo.utility_fy19_25;
-- This is meant to count the total rows within the dataset.
-- There were 96365 rows, now lets check to see how many work on the grain of the dataset

SELECT COUNT(*) as total_rows,
	COUNT(DISTINCT
		CONCAT(
			TRIM(COALESCE([FY],'')), '|',
			TRIM(COALESCE([Reporting_Month],'')), '|',
			TRIM(COALESCE([Bldg],'')), '|',
			TRIM(COALESCE([Type],'')), '|'

		)
	) AS distinct_candidate_key
FROM dbo.utility_fy19_25;
-- This is just building upon the total count and finding the entries that were distinct candidates (entries unique on our column criteria).
-- The COUNT DISTINCT was used to find the distinct entries based on the values of our criteria columns.
-- The CONCAT was used in order to make it easier for SQL Server to find the unique combinations.
-- The CONCAT outputs a string like: "FY18|11|0518|Steam"
-- I also added TRIM and COALESCE in order to get rid of spaces in the excel entries that could mess up the CONCAT.
-- COALESCE was just used to replace the nulls as '' to be an empty space that wouldn't break the query.
-- WE are missing over 40000 rows based on our distinct keys being 52687 I think these may be attached on split entries so lets add I numbers as well.

SELECT COUNT(*) as total_rows,
	COUNT(DISTINCT
		CONCAT(
			TRIM(COALESCE([FY],'')), '|',
			TRIM(COALESCE([Reporting_Month],'')), '|',
			TRIM(COALESCE([Bldg],'')), '|',
			TRIM(COALESCE([Type],'')), '|',
			TRIM(COALESCE([Index],'')), '|'
		)
	) AS distinct_candidate_key
FROM dbo.utility_fy19_25;

-- We added the Index back and only got around 4500 more keys at 57154 keys, lets check through the missing rows more and see the issue.



