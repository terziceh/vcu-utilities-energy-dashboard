CREATE OR ALTER VIEW mart.vw_tableau_monthly_building_map AS
SELECT
    m.FY,
    m.Campus,
    m.Building_Name,
    m.Bill_Type,
    m.Charge_Type,
    m.Reporting_Month,
    m.Spend,
    m.kWh,
    m.Cost_per_kWh,
    g.Address
FROM vw_monthly m
LEFT JOIN dbo.vcu_buildings_tableau_map g
    ON UPPER(LTRIM(RTRIM(m.Building_Name))) = UPPER(LTRIM(RTRIM(g.Building_Name)));