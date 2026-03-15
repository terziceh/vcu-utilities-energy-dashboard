/* ===========================
Final cleaning for EDA
Database: BI_HUD
Table: staging.utility_base
Author: Ethan Terzic
Date: 2/26/2026
Purpose: Now I'm finally setting up the table for our Core Schema that is ready to be looked at in Excel.
 =========================== */

 --Lets look if there are is a difference of total rows between distinct
 SELECT
	COUNT(*) as total_rows,
	COUNT(DISTINCT CONCAT(
	FY, '|',
	Bldg, '|',
	[Type], '|',
	[Index], '|',
	Meter, '|',
	Reporting_Month, '|',
	Account, '|'
	)) AS distinct_rows,
	COUNT(*) - COUNT(DISTINCT CONCAT(
	FY, '|',
	Bldg, '|',
	[Type], '|',
	[Index], '|',
	Meter, '|',
	Reporting_Month, '|',
	Account, '|'
	)) AS row_difference
FROM staging.utility_base;

-- Still a difference of 639 let me look at these outliers and see if there is a group solution for them.


--Lets see where these rows are duplicating

WITH dup_keys AS (
	SELECT FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account
	FROM staging.utility_base
	GROUP BY FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account
	HAVING COUNT(*) > 1)

SELECT b.*
FROM staging.utility_base b
JOIN dup_keys d
ON b.FY = d.FY
AND b.Bldg = d.Bldg
AND b.[Type] = d.[Type]
AND b.[Index] = d.[Index]
AND b.Meter = d.Meter
AND b.Reporting_Month = d.Reporting_Month
AND b.Account = d.Account
ORDER BY b.FY, b.Bldg, b.[Type], b.[Index], b.Meter, b.Reporting_Month, b.Account;

-- Looks like the issue is the percent lets go back and add this to the distinct features and see if that fixes anything.

 SELECT
	COUNT(*) as total_rows,
	COUNT(DISTINCT CONCAT(
	FY, '|',
	Bldg, '|',
	[Type], '|',
	[Index], '|',
	Meter, '|',
	Reporting_Month, '|',
	Account, '|',
	[%]
	)) AS distinct_rows,
	COUNT(*) - COUNT(DISTINCT CONCAT(
	FY, '|',
	Bldg, '|',
	[Type], '|',
	[Index], '|',
	Meter, '|',
	Reporting_Month, '|',
	Account, '|',
	[%]
	)) AS row_difference
FROM staging.utility_base;

--Still 371 lets check out the dups and see why this is happening.

SELECT FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account, [%]
	FROM staging.utility_base
	GROUP BY FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account, [%]
	HAVING COUNT(*) > 1;

-- Looks like these are happening on the Meter numbers that are null. Let's fix this.

SELECT *
FROM (
	SELECT
	b.*,
	COUNT(*) OVER (
	PARTITION BY FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account, [%]
	) AS dups
	FROM staging.utility_base b
	WHERE meter IS NULL
	) x 
WHERE x.dups > 1 
ORDER BY FY, Bldg, [Type], [Index], Meter, Reporting_Month, Account, [%];

-- The meters seem to be the issue we'll try to fix the data in Excel after since this is information we don't know yet. Now lets change the date formatting and final make out core table.


-- Let's make our final staging view then turn it into our core table.


DROP TABLE IF EXISTS core.fact_utility_usage;
GO

SELECT
    FY,                 -- keep EXACTLY as-is: FY18, FY19, etc.
    Provider,
    Type,
    Operator,
    Account,
    Customer_Type,
    [Index],
    Bldg,
    Building_Name,
    Status,
    I_Number,
    Campus,
    Address,
    Own_vs_Lease,
    Original_Invoice_Address,
    Meter,
    Rates,
    Notes,
    [%],

    TRY_CONVERT(decimal(18,4), Consumption) AS Consumption,
    TRY_CONVERT(decimal(18,4), Amount_Due)  AS Amount_Due,
    TRY_CONVERT(decimal(18,4), Total_Usage) AS Total_Usage,

    -- keep Reporting_Month exactly as-is (no conversion)
    Reporting_Month,

    -- convert these ONLY if they are serials / dates; no filtering
    CASE
        WHEN TRY_CONVERT(int, Svc_End_Date) IS NOT NULL
            THEN CONVERT(date, DATEADD(day, TRY_CONVERT(int, Svc_End_Date), '1899-12-30'))
        ELSE TRY_CONVERT(date, Svc_End_Date)
    END AS Svc_End_Date,

    CASE
        WHEN TRY_CONVERT(int, UtiliTrak_Date) IS NOT NULL
            THEN CONVERT(date, DATEADD(day, TRY_CONVERT(int, UtiliTrak_Date), '1899-12-30'))
        ELSE TRY_CONVERT(date, UtiliTrak_Date)
    END AS UtiliTrak_Date

INTO core.fact_utility_usage
FROM staging.utility_base;
GO


SELECT FY, COUNT(*) AS row_count
FROM core.fact_utility_usage
GROUP BY FY
ORDER BY FY;