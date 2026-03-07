# Uber-Ride-Analytics
📌 Project Overview

This project focuses on building a comprehensive data pipeline to analyze Uber ride-sharing data. The workflow spans from Data Engineering (ingesting and transforming 100k+ raw CSV records into a structured MySQL database) to Data Analytics (SQL-based KPIs and EDA) and finally Data Visualization (Power BI dashboarding).

The goal was to identify revenue drivers, peak traffic zones, and customer behavior patterns to optimize driver positioning and payment strategies.

📂 Dataset Information

The analysis uses a multi-table relational structure:

Fact Table (uber_ride): Contains transactional data including Trip IDs, timestamps, passenger counts, distances, and financial metrics like fares and surge fees.

Dimension Table (location_lookup): Maps Location IDs to specific names and cities to allow for geographical analysis.

Scale: 100,000+ rows of ride-share data.

🛠️ Tools & Technologies

Database: MySQL (Relational Schema Design & ETL).

Languages: SQL (DDL, DML, DQL).

Visualization: Power BI (Interactive Dashboards, DAX, Bookmarks).

Presentation: Gamma AI (Automated PPT generation for stakeholders).

Data Cleaning: SQL STR_TO_DATE transformations.

⚙️ Project Workflow (Step-by-Step)

1. Database Setup & ETL (Extract, Transform, Load)

Optimization: Utilized LOAD DATA LOCAL INFILE for high-performance bulk loading, bypassing the limitations of standard Import Wizards.

Data Transformation: Standardized inconsistent CSV date formats (DD-MM-YYYY) into MySQL-native DATETIME using STR_TO_DATE functions.

Normalization: Implemented a Star Schema by joining transactional data with location dimensions via INNER JOIN.

2. SQL Business Logic (KPIs)

Developed queries to extract high-value business metrics:

Revenue Metrics: Total revenue (Fare + Surge) and Average Booking Value (ABV).

Operational Efficiency: Average Trip Duration and Average Trip Distance.

Behavioral Trends: Revenue breakdown by Payment Type and Top 5 Vehicle Types.

3. Advanced Power BI Dashboarding

Beyond basic charts, I implemented advanced features to enhance user experience:

Interactive Bookmarks: Created custom views that allow users to toggle between different report states (e.g., switching between "Revenue View" and "Operational View") without changing pages.

Selection Pane & Buttons: Designed a custom navigation menu using buttons and the Selection Pane to hide/show visuals, creating a clean, "App-like" interface.

Dynamic Slicers: Implemented synchronized slicers for Vehicle Type, Payment Method, and City to ensure consistent filtering across all report tabs.

Tooltips & Drill-throughs: Added custom tooltips to provide granular location details when hovering over data points on the map.

📊 Key Results & Insights

Payment Adoption: "Uber Pay" was identified as the dominant payment method, suggesting high digital adoption.

Operational Hotspots: Through table JOINS, I identified high-traffic zones, allowing for strategic surge pricing and driver positioning.

Performance: Automated the data ingestion process, successfully migrating 100k+ records from CSV to MySQL.

🚀 How to Run

Clone the Repo: Download the .sql file and the datasets.

Database Configuration: Run the Uber_Ride_Queries.sql script in MySQL Workbench. Update the file paths in the LOAD DATA statements to match your local machine.

Power BI: Open the .pbix file and refresh the data source to connect to your local MySQL instance.

Presentation: Review the PPT created via Gamma AI for a high-level summary of findings.

Author: Tejeendra Arragudla

Status: Project Completed Successfully
