# How I Built an End-to-End Utility Energy Dashboard Using SQL Server, Python, Excel, and Tableau

## Project Overview

Built using **6+ years of electricity billing data across 250+ university buildings** to analyze energy consumption, cost trends, and operational insights.

The goal was to transform raw utility billing data into an interactive dashboard that helps answer key operational questions:

- How is electricity spending changing over time?
- Which buildings consume the most energy?
- What accounts drive the largest share of costs?
- Are cost increases driven by usage or price changes?

The final result is a **Tableau dashboard supported by SQL data modeling and Python preprocessing**.

---

## Project Architecture

The analytics pipeline follows a typical business intelligence workflow:

Raw Utility Billing Data  
↓  
Data Cleaning & Transformation (Python / Excel)  
↓  
SQL Server Data Modeling  
↓  
Feature Engineering  
↓  
Tableau Dashboard Visualization

---

## Tools & Technologies

**Data Processing**
- Python (Pandas)
- Excel

**Database**
- Microsoft SQL Server

**Visualization**
- Tableau

**Development**
- GitHub
- Jupyter Notebook

---

## Dataset

The original dataset contains **electricity billing records across multiple campus buildings from FY19–FY25**.

Due to internal data policies at Virginia Commonwealth University Facilities Management, the full dataset cannot be shared publicly.

This repository includes:

- A **sanitized sample dataset**
- A **data dictionary describing the schema**

Files are located in the `/data` directory.

---

## Data Dictionary

data/data_dictionary.md


for a full description of dataset fields.

---

## Data Preparation

Before analysis, the dataset required several transformations:

- Handling missing building identifiers
- Separating fixed charges from energy charges
- Creating fiscal year metrics
- Calculating electricity cost per kWh

Example metric:

Clean_Cost_per_kwh = Amount_Due / Consumption


These transformations were performed using **Python and SQL**.

---

## SQL Data Modeling

SQL was used to prepare datasets specifically optimized for dashboard analysis.

Key steps included:

- Creating staging tables
- Cleaning null values
- Building aggregated views
- Preparing datasets for Tableau visualization

Example SQL transformation:

```sql
SELECT
Building_Name,
SUM(Consumption) AS Total_Consumption,
SUM(Amount_Due) AS Total_Cost
FROM utilities
GROUP BY Building_Name
```

## Dashboard Features

The Tableau dashboard allows users to explore energy usage across buildings through interactive visualizations and key performance indicators.

### Key Performance Indicators (KPIs)

- Total Electricity Spend  
- Total Consumption  
- Average Cost per kWh  
- Average Monthly Spend  
- Peak Monthly Bill  

### Visualizations

- Monthly Electricity Spend Trend  
- Electricity Consumption Trend  
- Cost per kWh Trend  
- Charge Type Breakdown  
- Top Energy Accounts  

### Interactive Filters

Users can dynamically explore the data by filtering the dashboard by:

- Building  
- Fiscal Year  
- Account  

These filters allow stakeholders to quickly analyze electricity spending patterns across different buildings and time periods.

---

## Dashboard Preview

*(Screenshots or screen recordings will be added here)*

Example visuals include:

- Executive KPI overview  
- Monthly energy cost trends  
- Building-level consumption analysis  
- Campus energy map  

Example screenshot placeholder:

![Dashboard Overview](dashboards/screenshots/dashboard_overview.png)

---

## Key Insights from the Dashboard

The dashboard enables several useful operational insights, including:

- Some buildings account for a disproportionately large share of electricity consumption.
- Energy spending trends do not always move directly with consumption changes.
- Certain accounts consistently drive a significant portion of overall electricity costs.

These insights can support:

- operational planning  
- energy efficiency initiatives  
- cost monitoring across buildings  

---

## Repository Structure
vcu-utilities-energy-dashboard

dashboards/
utilities_tableau_dashboard.twbx


data/
utilities_sample_data.csv
data_dictionary.md

sql/
transformation_scripts.sql

notebooks/
geocode_buildings.ipynb


---

## Future Improvements

Potential extensions for this project include:

- Automated invoice ingestion pipeline
- Anomaly detection for unusual energy consumption patterns
- Predictive energy demand modeling
- Cloud-based data pipeline integration
- Automated reporting dashboards

These improvements would further extend the project into a full **data engineering and analytics pipeline**.

---

## Author

**Ethan Terzic**  
MBA / MS Information Systems (Data Science)  
Virginia Commonwealth University
