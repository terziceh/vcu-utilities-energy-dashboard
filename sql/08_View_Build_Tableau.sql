--Now we need to build our Views on the data first I will start with a base table 
--just in case we need to use it if the other views for the graphs aren't working.

CREATE OR ALTER VIEW dbo.vw_tblu_base AS
SELECT
	Provider,
	Type, 
	Operator,
	Account,
	Customer_Type,
	[Index],
	Bldg,
	Building_Name, 
	[Status],
	Campus,
	Address,
	Own_vs_Lease,
	Meter,

	Consumption AS kWh,
	CAST(Amount_Due AS decimal(18,2)) AS Amount_Due,
	Reporting_Month,
	FY,
	Charge_Type,
	Bill_Type,
	Building_Key,

	CASE 
		WHEN Consumption > 0
		THEN CAST(Amount_Due AS decimal(18,2)) / CAST(Consumption)
		ELSE NULL
	END AS CostPerkWh
FROM dbo.Cleaned_Utility_Data_Tableau
GO

		