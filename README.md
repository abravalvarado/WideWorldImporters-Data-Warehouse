# Data Warehouse and BI Implementation for WideWorldImporters

This repository contains the SQL scripts and documentation for a comprehensive data engineering and business intelligence project. The objective was to design an end-to-end solution for data extraction, storage, and enterprise analysis.

## Overview
Based on the WideWorldImporters transactional database, this project was optimized to meet strategic analytical needs. The final system facilitates data-driven decision-making by enabling the precise identification of business patterns and trends through a star schema and a tabular data model.

## Technologies & Tools
* **SQL Server Management Studio (SSMS)**
* **Visual Studio Code**
* **Microsoft Excel**
* **SQL Server Analysis Services (SSAS)**

## Architecture & Development Process
1. **Planning & Cost Analysis:** Estimation of cloud hosting costs for deploying the database on Azure.
2. **ETL Process:** Development of advanced SQL queries (using complex `JOINs`) to consolidate dispersed information and create clean dimensions (e.g., `Dim_Customer`, `Dim_Product`).
3. **Data Warehouse Construction:** Generation of new dimensions and a central fact table within the `WireWorldImporters DW` analytical database.
4. **Tabular Modeling:** Deployment of a Tabular project in SSAS, connected directly to the Data Warehouse.
5. **Metrics & DAX:** Creation of custom measures and KPIs to monitor business objectives, such as Total Orders and YTD Sales.
6. **Security & Governance:** Configuration of security roles to manage data access based on authorization levels, alongside data hierarchy implementation.

## Repository Contents
* [`SQL Procedures.sql`](./SQL%Procedures.sql): Contains all extraction scripts, dimension creation, and fact table logic.
* [`Project Documentation.pdf`](./Project%Documentation.pdf): Comprehensive project documentation, architectural justification, and references.

## Business Impact
Structuring the data into dimensions significantly optimized query execution times and data retrieval. The robust design enables detailed, granular analysis without compromising operational efficiency or agility, positioning the organization to maximize the value of its data assets.
