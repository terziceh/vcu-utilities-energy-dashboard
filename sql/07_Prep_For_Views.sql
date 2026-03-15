SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
AND TABLE_NAME = 'Cleaned_Utility_Data_Tableau'

ALTER TABLE dbo.Cleaned_Utility_Data_Tableau
ALTER COLUMN Consumption INT;

ALTER TABLE dbo.Cleaned_Utility_Data_Tableau
ALTER COLUMN Amount_Due DECIMAL(10,2);

ALTER TABLE dbo.Cleaned_Utility_Data_Tableau
ALTER COLUMN Total_Usage DECIMAL(10,2);


SELECT *
FROM dbo.Cleaned_Utility_Data_Tableau
WHERE Building_Name IS NULL
OR Building_Name = '';
--70938 rows of data look correct.
-- Here we were able to alter the tables to fix better formatting I left the dbo.Cleaned_Utility_Data_Tableau Clean_Cost_per_kwh column alone
-- I also checked to see that the dataset has a building name for each with just a quick null and not null check showing there were no missing columns.
