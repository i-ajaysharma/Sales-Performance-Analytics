# Contributing / Practice Guide

This repository is intentionally structured as a portfolio + hands-on learning project.

## Recommended build order
1. Load the CSV files into MySQL.
2. Run `sql/01_schema.sql`.
3. Import the CSV data into the corresponding tables.
4. Run and understand every query in `sql/02_advanced_analysis.sql`.
5. Import the tables into Power BI.
6. Apply the star-schema relationships documented in `powerbi/04_Data_Model_and_Dashboard_Spec.md`.
7. Create and test the DAX measures in `powerbi/03_DAX_Measures.txt`.
8. Build the dashboard pages.
9. Validate Power BI KPIs against SQL.
10. Document final business insights.

## Portfolio rule
Do not claim an insight until it has been validated against the underlying data.
