/* ===========================
Schemas for work layers
Database: BI_HUD
Table: dbo.utility_fy19_25
Author: Ethan Terzic
Date: 2/26/2026
Purpose: I just wanted to organize the data through schemas in order to know the stage of work they are at.

 =========================== */

 CREATE SCHEMA raw;
 GO
 ALTER SCHEMA raw TRANSFER dbo.utility_fy19_25

-- dbo.utility_fy19_25 was changed to raw.utility_fy19_25

SELECT *
FROM raw.utility_fy19_25

-- Proof that this works.

USE BI_HUB;
GO

SELECT s.name as schema_name
FROM sys.schemas as s
WHERE s.name IN ('raw','staging', 'core', 'mart', 'meta')
ORDER BY s.name;

--All the schemas are there, lets save then finally get to filtering the data down and sending it to staging.

