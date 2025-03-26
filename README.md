# Data Warehouse Architecture

## Overview
This project implements a Data Warehouse architecture using **Snowflake**, designed to process and manage structured data from multiple sources, including CRM and ERP systems. The data is ingested, transformed, and made business-ready following a multi-layered ELT approach.

## Architecture
The data warehouse follows a **three-layered architecture**:

### 1. Bronze Layer (Raw Data)
- **Object Type**: Tables
- **Load Process**:
  - Batch Processing
  - Full load
  - Truncate & Insert
- **Transformations**: None (Raw Data)
- **Data Model**: None (as-is)

### 2. Silver Layer (Cleansed & Standardized Data)
- **Object Type**: Tables
- **Load Process**:
  - Batch Processing
  - Full load
  - Truncate & Insert
- **Transformations**:
  - Data Cleansing
  - Data Standardization
  - Data Normalization
  - Derived Columns
  - Data Enrichment
- **Data Model**: None (as-is)

### 3. Gold Layer (Business Ready Data)
- **Object Type**: Views
- **Load Process**: No additional loading, transformations happen within views.
- **Transformations**:
  - Data Integrations
  - Aggregations
  - Business Logic
- **Data Model**:
  - Star Schema
  - Flat Table
  - Aggregated Table

## Technologies Used
- **Snowflake**: Cloud-based Data Warehouse
- **dbt (Data Build Tool)**: Transformation and modeling tool for ELT processes
- **CSV Files**: Source data format from CRM and ERP

## Workflow
1. **Data Ingestion**: Source data from CSV files is loaded into the Bronze Layer.
2. **Transformation**:
   - Silver Layer: Data is cleansed, standardized, and enriched.
   - Gold Layer: Business logic, integrations, and aggregations are applied.
3. **Consumption**: Business-ready data is exposed via views for analytics and reporting.

## License
This project is licensed under the MIT License.

