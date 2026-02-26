/* ============================================================
   PROJECT: UBER RIDE ANALYSIS
   AUTHOR: Tejeendra Arragudla
   DATASET: Uber
   ============================================================ */
   
/* ============================================================
   STEP: DATABASE SETUP
   - Setting Up MYSQL Workbench
   - Create A New Schema
   - Creating a Table 
   ============================================================ */

CREATE DATABASE IF NOT EXISTS Uber_Analysis;
USE Uber_Analysis;

CREATE TABLE uber_ride (
    Trip_ID INT PRIMARY KEY,
    Pickup_Time DATETIME,
    DropOff_Time DATETIME,
    passenger_count INT,
    trip_distance DECIMAL(10, 2),
    PU_Location_ID INT,
    DO_Location_ID INT,
    fare_amount DECIMAL(10, 2),
    Surge_Fee DECIMAL(10, 2),
    Vehicle VARCHAR(50),
    Payment_type VARCHAR(50)
);

-- =====================================================================================
-- STEP: DATA TRANSFORMATION (ETL)
-- Reason: This process migrates raw unstructured CSV data into a structured Relational Database (RDBMS).
-- =====================================================================================

/* I have optimized data import performance by Utilizing MYSQL's LOAD DATA LOCAL INFILE statement to Efficiently Load 
10K+ Row Dataset. Initially attempted standard import methods, then identified performance limitations and implemented Bulk
Loading to Improve Speed and Reliability
*/

-- Enable the server to accept local file uploads
SET GLOBAL local_infile = 1;

-- Load the main transactional dataset through LOAD DATA INFILE
LOAD DATA LOCAL INFILE 'C:/Users/tejee/Downloads/Datetime_Dataset.csv'
INTO TABLE uber_ride
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

-- The CSV date format (DD-MM-YYYY) is not natively compatible with MySQL's YYYY-MM-DD format.
(Trip_ID, @var_Pickup, @var_DropOff, passenger_count, trip_distance, PU_Location_ID, DO_Location_ID, fare_amount, Surge_Fee, Vehicle, Payment_type)
SET 
	-- Converting string variables to standardized MySQL DATETIME
    Pickup_Time = STR_TO_DATE(@var_Pickup, '%d-%m-%Y %H:%i'),
    Dropoff_Time = STR_TO_DATE(@var_Dropoff, '%d-%m-%Y %H:%i');
    
USE Uber_Analysis;

-- Cleanup existing schema
DROP TABLE IF EXISTS location_lookup;

CREATE TABLE location_lookup (
    LocationID INT PRIMARY KEY,
    Location VARCHAR(255),
    City VARCHAR(100)
);

SET GLOBAL local_infile = 1;

-- Load the main transactional dataset through LOAD DATA INFILE Same used While Importing Uber_ride dataset.
LOAD DATA LOCAL INFILE 'C:/Users/tejee/Downloads/Location_table_uber.csv'
INTO TABLE location_lookup
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(LocationID, Location, City);

DESCRIBE uber_ride;
DESCRIBE location_lookup;

/* This step combines the 'Fact' table (uber_ride) with the 'Dimension' table (location_lookup). Since the ride table only contains numerical IDs for locations, 
we perform an INNER JOIN. */ 

SELECT 
    u.Trip_ID, 
    u.Pickup_Time, 
    u.DropOff_Time, 
    u.passenger_count, 
    u.trip_distance, 
    p.Location AS Pickup_Location,  -- Name from the 'p' alias
    p.City AS Pickup_City,
    d.Location AS Dropoff_Location, -- Name from the 'd' alias
    d.City AS Dropoff_City,
    u.fare_amount, 
    u.Surge_Fee, 
    u.Vehicle, 
    u.Payment_type
FROM uber_ride u 
JOIN location_lookup p ON u.PU_Location_ID = p.LocationID -- Alias 'p' for Pickup
JOIN location_lookup d ON u.DO_Location_ID = d.LocationID -- Alias 'd' for Dropoff
LIMIT 5000;

-- Data Exploratory Analysis (EDA)

SELECT * FROM uber_ride
WHERE trip_distance = 0
OR fare_amount = 0
OR Pickup_Time IS NULL;

-- =========================================================================
-- STEP: KPI METRICS (Key Performance Indicator) and BUSINESS INSIGHTS Q/A
-- =========================================================================

-- Total Bookings (Total Trips)
SELECT COUNT(*) AS Total_Trips
FROM uber_ride;

-- Total Bookings Value (Total Revenue)
SELECT SUM(fare_amount + Surge_Fee) AS Total_Revenue
FROM uber_ride;

-- Average Booking values (Average Fare Amount)
SELECT AVG(fare_amount) AS Average_Booking_Value
FROM uber_ride;

-- Total Trip Distance (Total Trip Distance)
SELECT SUM(trip_distance) AS Total_Trip_Distance
FROM uber_ride;

-- Average Trip Distance (Average Trip Distance)
SELECT AVG(trip_distance) AS Average_Trip_Distance
FROM uber_ride;

-- Average Trip Duration (Average Trip Time)
SELECT AVG(TIMESTAMPDIFF(MINUTE, Pickup_Time, DropOff_Time)) AS Average_Trip_Duration FROM uber_ride;

-- Top 5 Most Frequent Vehicle Types
SELECT Vehicle, COUNT(*) AS Booking_Count
FROM uber_ride
GROUP BY Vehicle
ORDER BY Booking_Count DESC
LIMIT 5;

-- Revenue By Payment Types
SELECT Payment_type, SUM(fare_amount + Surge_fee) AS Total_Revenue
FROM uber_ride
GROUP BY Payment_type
ORDER BY Total_Revenue DESC;

-- Passenger count distribution
SELECT passenger_count, count(*) AS count_distribution
FROM uber_ride
GROUP BY passenger_count
ORDER BY passenger_count;

-- Reset security settings to default
SET GLOBAL local_infile = 0;

/* =========================================================================
   STEP: PROJECT CONCLUSION & SUMMARY OF FINDINGS
   =========================================================================
   
   TECHNICAL SUMMARY:
   - Successfully implemented an E2E Data Pipeline migrating 100k+ records from CSV to MySQL.
   - Performed Data Transformation (ETL) to standardize date formats for time-series analysis.
   - Normalized the database schema using a Star Schema approach (Fact & Dimension tables).
   
   BUSINESS INSIGHTS DERIVED:
   1. REVENUE: The platform generated substantial revenue, with 'Uber Pay' being the 
      dominant payment method, suggesting high digital adoption.
   2. HOTSPOTS: Through table JOINS, we identified high-traffic zones, allowing for 
      strategic surge pricing and driver positioning in top-tier pickup locations.

   FINAL STATUS: Project Completed Successfully.
   
   ========================================================================= */