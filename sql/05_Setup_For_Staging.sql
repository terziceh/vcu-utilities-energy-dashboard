/* ===========================
Filtering for Staging Tables
Database: BI_HUD
Table: raw.utility_fy19_25
Author: Ethan Terzic
Date: 2/26/2026
Purpose: Time to actually filter down the tables now that I know that everything not attached to the grain is null.
 =========================== */

-- Just in case we'll make a rejects table of our Nulls if we need it later.


CREATE OR ALTER VIEW staging.utility_rejects AS
SELECT *
FROM raw.utility_fy19_25
WHERE 
	NULLIF(TRIM([FY]), '') IS NULL
	AND NULLIF(TRIM([Bldg]), '') IS NULL
	AND NULLIF(TRIM([Type]), '') IS NULL
	AND NULLIF(TRIM([Index]), '') IS NULL
	AND NULLIF(TRIM([Account]), '') IS NULL
	AND NULLIF(TRIM([Meter]), '') IS NULL
	AND NULLIF(TRIM([Reporting_Month]), '') IS NULL;
GO

--Now that the rejects are grouped up lets filter them out of the dataset so we can get to using our base.


CREATE OR ALTER VIEW staging.utility_base AS
SELECT *
FROM raw.utility_fy19_25
WHERE NOT(
	NULLIF(TRIM([FY]), '') IS NULL
	AND NULLIF(TRIM([Bldg]), '') IS NULL
	AND NULLIF(TRIM([Type]), '') IS NULL
	AND NULLIF(TRIM([Index]), '') IS NULL
	AND NULLIF(TRIM([Account]), '') IS NULL
	AND NULLIF(TRIM([Meter]), '') IS NULL
	AND NULLIF(TRIM([Reporting_Month]), '') IS NULL
	);
GO

--Now we got our base. We aren't done yet though, we need to check if everything is correct before putting it in the staging schema.

SELECT 
	(SELECT COUNT(*) FROM raw.utility_fy19_25) as raw_rows,
	(SELECT COUNT(*) FROM staging.utility_base) as base_rows,
	(SELECT COUNT(*) FROM staging.utility_rejects) as rejects_rows;\

-- Counts look correct lets see if they are in the staging schema and we will do the final steps to get it ready for the Excel EDA.


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE 'utility%';

-- Tables are in the right schema. Let's save then check so more so we cna get it into the core for EDA.