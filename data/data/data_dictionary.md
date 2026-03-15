# Data Dictionary

This dataset contains utility billing records used to analyze electricity consumption and cost patterns across buildings.

Due to organizational data policies, the full dataset used in the project cannot be shared publicly.  
A sanitized sample dataset is included to demonstrate the structure of the analysis pipeline.

| Column | Description |
|------|-------------|
| Provider | Utility provider for the billing account |
| Type | Utility type (Electric, Gas, etc.) |
| Operator | Internal system operator field |
| Account | Utility account identifier |
| Customer_Type | Classification of the account |
| Index | Internal billing index |
| Bldg | Building identifier |
| Building_Name | Name or label of the building |
| Status | Operational status of the building |
| Campus | Campus location of the building |
| Address | Building address |
| Own_vs_Lease | Indicates whether the building is owned or leased |
| Meter | Meter identifier |
| Consumption | Electricity consumption for the billing period (kWh) |
| Amount_Due | Total cost billed for the period |
| Total_Usage | Total energy usage billed |
| Reporting_Month | Month the bill is reported |
| Svc_End_Date | End date of service period |
| UtiliTrak_Date | Date recorded in the utility tracking system |
| Svc_End_Date_Fixed | Cleaned service date used for analysis |
| FY | Fiscal year of the billing record |
| Charge_Type | Type of charge (Energy, Adjustment, etc.) |
| Bill_Type | Classification of bill (Credit, Non-Credit) |
| Building_Key | Combined identifier used for analysis |
| Clean_Cost_per_kwh | Calculated electricity cost per kWh |
