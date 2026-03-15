--I'm going to have to export in SQL to python in order to pull the building locations in Python.

SELECT DISTINCT
	Building_Name,
	Campus,
	Address
FROM dbo.Cleaned_Utility_Data_Tableau
WHERE Building_Name IS NOT NULL AND LTRIM(RTRIM(Building_Name)) <> ''
ORDER BY Building_Name;