IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'mart')
	EXEC('CREATE SCHEMA mart');
GO

USE BI_HUB;
GO

--View for the Monthly Base
CREATE OR ALTER VIEW mart.vw_monthly AS
SELECT
	FY,
	Campus,
	Building_Name,
	Bill_Type,
	Charge_Type,

	Reporting_Month,

	SUM(Amount_Due) as Spend,
	SUM(Consumption) as kWh,

	CASE	
		WHEN SUM(Consumption) = 0 THEN NULL
		ELSE SUM(Amount_Due) / SUM(Consumption)
	END AS Cost_per_kWh

FROM dbo.Cleaned_Utility_Data_Tableau

GROUP BY 
	FY,
	Campus,
	Building_Name,
	Bill_Type,
	Charge_Type,
	Reporting_Month;

--Let's make the other views now for the dashboard, starting with the KPI Section

CREATE OR ALTER VIEW mart.vw_kpi_summary AS
SELECT
	FY,
	Campus,
	SUM(Spend) AS Total_Spend,
	SUM(kWh) as Total_kWh,
	CASE WHEN SUM(kWh)=0 THEN NULL ELSE SUM(Spend)/SUM(kWh) END AS Cost_Per_kWh
FROM mart.vw_monthly
GROUP BY FY, Campus;
GO

-- Now we need a view for the sparklines near them
CREATE OR ALTER VIEW mart.vw_kpi_sparklines AS
SELECT 
	FY,
	Campus,
	Reporting_Month,
	SUM(Spend) as Spend,
	SUM(kWh) as kWh,
	CASE WHEN SUM(kWh)=0 THEN NULL ELSE SUM(Spend)/SUM(kWh) END AS Cost_Per_kWh
FROM mart.vw_monthly
GROUP BY FY, Campus, Reporting_Month;
GO

--Now last portion of the KPIs we need to set up the YoY Spend and kWh
USE BI_HUB;
GO

CREATE OR ALTER VIEW mart.vw_kpi_yoy AS
WITH yearly AS (
	SELECT
		FY,
		Campus,
		SUM(Spend) AS Spend,
		SUM(kWh) AS kWh
	FROM mart.vw_monthly
	GROUP BY FY, Campus
) 

SELECT	
	FY,
	Campus,
	Spend,
	kWh,
	LAG(Spend) OVER (PARTITION BY Campus ORDER BY FY) AS Spend_PY,
	LAG(kWh) OVER (PARTITION BY Campus ORDER BY FY) AS kWh_PY,
	CASE
		WHEN LAG(Spend) OVER (PARTITION BY Campus ORDER BY FY) IS NULL THEN NULL
		WHEN LAG(Spend) OVER (PARTITION BY Campus ORDER BY FY)  = 0 THEN NULL
		ELSE (Spend - LAG(Spend) OVER (PARTITION BY Campus Order BY FY))
			/ LAG(Spend) OVER (PARTITION BY Campus Order BY FY)
	END AS Spend_YoY_Pct,
	CASE
		WHEN LAG(kWh) OVER (PARTITION BY Campus ORDER BY FY) IS NULL THEN NULL
		WHEN LAG(kWh) OVER (PARTITION BY Campus ORDER BY FY)  = 0 THEN NULL
		ELSE (kWh - LAG(kWh) OVER (PARTITION BY Campus Order BY FY))
			/ LAG(kWh) OVER (PARTITION BY Campus Order BY FY)
	END AS kWh_YoY_Pct
FROM yearly;
GO

--Campus Monthly
CREATE OR ALTER VIEW mart.vw_campus_monthly AS
SELECT
	FY,
	Campus,
	Reporting_Month,
	SUM(Spend) as Spend,
	SUM(kWh) as kWh,
	CASE WHEN SUM(kWh)=0 THEN NULL ELSE SUM(Spend)/SUM(kWh) END AS Cost_per_kWh
FROM mart.vw_monthly
GROUP BY FY, Campus, Reporting_Month;
GO

-- Building Rollup
CREATE OR ALTER VIEW mart.vw_rollup AS
SELECT 
	FY,
	Campus,
	Building_Name,
	SUM(Spend) as Spend,
	SUM(kWh) as kWh,
	CASE WHEN SUM(kWh)=0 THEN NULL ELSE SUM(Spend)/SUM(kWh) END AS Cost_per_kWh
FROM mart.vw_monthly
GROUP BY FY, Campus, Building_Name;
GO

-- Building Heatmap

CREATE OR ALTER VIEW mart.vw_heatmap AS
SELECT
	FY,
	Campus,
	Building_Name,
	Reporting_Month,
	SUM(Spend) as Spend
FROM mart.vw_monthly
GROUP BY FY, Campus, Building_Name, Reporting_Month;
GO

-- Bill Type

CREATE OR ALTER VIEW mart.vw_type AS
SELECT 
	FY,
	Campus,
	Bill_Type,
	SUM(Spend) as Spend
FROM mart.vw_monthly
GROUP BY FY, Campus, Bill_Type;
GO

-- Worst Months

CREATE OR ALTER VIEW mart.vw_worst_months AS
SELECT 
	FY,
	Campus,
	Building_Name,
	Reporting_Month,
	SUM(Spend) as Spend,
	SUM(kWh) as kWh,
	CASE WHEN SUM(kWh)=0 THEN NULL ELSE SUM(Spend)/SUM(kWh) END AS Cost_Per_kWH
FROM mart.vw_monthly
GROUP BY FY, Campus, Building_Name, Reporting_Month;
GO
