CREATE DATABASE Ola;
USE Ola;

-- Create table 

CREATE TABLE bookings (
    Date VARCHAR(30),
    Time VARCHAR(20),
    Booking_ID VARCHAR(20),
    Booking_Status VARCHAR(50),
    Customer_ID VARCHAR(20),
    Vehicle_Type VARCHAR(30),
    Pickup_Location VARCHAR(100),
    Drop_Location VARCHAR(100),
    V_TAT VARCHAR(20),
    C_TAT VARCHAR(20),
    Canceled_Rides_by_Customer VARCHAR(255),
    Canceled_Rides_by_Driver VARCHAR(255),
    Incomplete_Rides VARCHAR(20),
    Incomplete_Rides_Reason VARCHAR(255),
    Booking_Value INT,
    Payment_Method VARCHAR(50),
    Ride_Distance INT,
    Driver_Ratings VARCHAR(20),
    Customer_Rating VARCHAR(20)
);

SELECT * FROM bookings;

-- Import DATASET 

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Admin/Desktop/Projects/Dataset/bookings.csv'
INTO TABLE bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

----------------------------------------------------------------------------------------------------------------------------------------
-- 1. Retrieve all successful bookings:

-- Business Problem
-- The management wants to analyze all successfully completed rides to understand customer demand,
-- operational efficiency, and revenue-generating transactions.

SELECT * FROM bookings
WHERE Booking_status = "Success";

-- Business Impact
-- Helps track completed and revenue-generating rides.
-- Enables analysis of customer travel patterns.
-- Supports operational performance monitoring.

-- Count Bookings Status by status
SELECT COUNT(*) AS Total_Successful_Bookings
FROM bookings
WHERE Booking_Status = 'Success';

SELECT Booking_Status,
COUNT(*) AS Total_Bookings FROM bookings
GROUP BY Booking_status
ORDER BY Total_Bookings DESC;
----------------------------------------------------------------------------------------------------------------------------------------

-- 2. Find the average ride distance for each vehicle type:

-- Business Problem
-- The management wants to understand the average distance traveled by customers for each vehicle category.
-- This helps identify customer travel patterns and the utilization of different vehicle types.

CREATE VIEW  average_ride_distance_for_each_vehicle AS 
SELECT Vehicle_type, ROUND(AVG(Ride_distance)) AS Average_distance
From bookings
GROUP BY Vehicle_type
ORDER BY Average_Distance DESC;

-- 2. Find the average ride distance for each vehicle type:
SELECT * FROM average_ride_distance_for_each_vehicle;

-- Business Impact
-- Helps identify which vehicle types are used for longer trips.
-- Supports fleet management and vehicle allocation decisions.
-- Assists in pricing and operational planning.
-- Enables the company to optimize vehicle availability based on customer demand.
----------------------------------------------------------------------------------------------------------------------------------------

-- 3. Get the total number of cancelled rides by customers:

-- Business Problem
-- Customer cancellations can lead to revenue loss, inefficient driver allocation, and operational challenges.
-- The management wants to monitor how frequently customers cancel their bookings.

SELECT COUNT(*) AS total_number_of_cancelled_rides_by_customers
FROM bookings 
WHERE booking_status ="Canceled by Customer";

-- Business Impact
-- Helps measure customer cancellation rates.
-- Identifies potential issues in pricing, waiting time, or service quality.
-- Supports strategies to reduce cancellations and improve customer retention.
-- Helps estimate revenue lost due to customer-initiated cancellations.

-- Instead of only showing the total cancellations, we can analyze the reasons behind customer cancellations.
SELECT Canceled_Rides_by_Customer AS Cancellation_Reason,
       COUNT(*) AS Total_Cancellations
FROM bookings
WHERE Booking_Status = 'Canceled by Customer'
GROUP BY Canceled_Rides_by_Customer
ORDER BY Total_Cancellations DESC;
-- Business Problem
-- The company wants to understand why customers cancel rides so that corrective actions can be taken.

-- Business Impact
-- Identifies the most common cancellation reasons.
-- Helps improve customer experience.
-- Enables data-driven decisions to reduce ride cancellations.
-- Improves overall ride completion rates.
-----------------------------------------------------------------------------------------------------------------------------------------

-- 4. List the top 5 customers who booked the highest number of rides:

-- Business Problem
-- The company wants to identify its most active customers. Understanding who frequently uses 
-- the platform can help in designing loyalty programs, personalized offers, and customer retention strategies.

CREATE VIEW top_5_customers AS
SELECT customer_id, COUNT(booking_id) AS Number_of_rides
FROM bookings
GROUP BY customer_id
ORDER BY Number_of_rides DESC 
LIMIT 5;

SELECT * FROM top_5_customers;
-- Business Impact
-- Identifies the most valuable customers.
-- Helps create targeted marketing campaigns.
-- Supports customer loyalty and reward programs.
-- Increases customer retention and lifetime value.
----------------------------------------------------------------------------------------------------------------------------------

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
-- Business Problem
-- Driver-side cancellations can negatively impact customer trust, ride completion rates, and overall service quality.
-- Management wants to understand how many rides were cancelled due to drivers' personal reasons or vehicle-related issues.

SELECT COUNT(*) AS rides_cancelled_by_drivers
FROM bookings 
WHERE Canceled_Rides_by_Driver = "Personal & Car related issue";

-- Business Impact
-- Helps monitor driver reliability.
-- Identifies operational issues affecting service quality.
-- Supports driver training and vehicle maintenance programs.
-- Reduces customer dissatisfaction caused by last-minute cancellations.
-----------------------------------------------------------------------------------------------------------------------------------------

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:

-- Business Problem
-- The management wants to evaluate the service quality of the Prime Sedan category by
-- identifying the highest and lowest driver ratings received in completed rides.

-- SET SQL_SAFE_UPDATES = 0;
-- UPDATE bookings
-- SET Driver_Ratings = NULL
-- WHERE Driver_Ratings = 'null';

SELECT MAX(Driver_Ratings) AS Max_rating,
	   MIN(Driver_Ratings) AS Min_rating
FROM bookings
WHERE Vehicle_Type ="Prime Sedan";

-- SET SQL_SAFE_UPDATES = 1;

-- Business Impact
-- Helps assess the quality of service in the Prime Sedan category.
-- Identifies the range of driver performance.
-- Supports driver training and quality improvement initiatives.
-- Helps maintain premium customer experience standards.
----------------------------------------------------------------------------------------------------------------------------------------
# 7. Retrieve all rides where payment was made using UPI:

-- Business Problem
-- The company wants to analyze the adoption of UPI as a payment method and understand customer preferences for digital transactions.

SELECT * FROM bookings
WHERE Payment_Method ="UPI";

-- Business Impact
-- Helps measure the popularity of UPI payments.
-- Supports digital payment strategy and promotional campaigns.
-- Enables analysis of customer payment preferences.
-- Assists in improving payment-related services and partnerships.

-- Instead of only listing UPI transactions, analyze the usage of all payment methods.
SELECT Payment_method,
COUNT(*) AS Total_rides
FROM bookings
GROUP BY Payment_method
ORDER BY Total_rides DESC; -- LIMIT 4 OFFSET  1 
-- Business Problem
-- Management wants to understand which payment methods are most frequently used and how much revenue each payment channel generates.

-- Business Impact
-- Identifies the most preferred payment methods.
-- Helps optimize payment infrastructure.
-- Supports targeted cashback and discount campaigns.
-- Assists in increasing digital payment adoption.

------------------------------------------------------------------------------------------------------------------------------------------

# 8. Find the average customer rating per vehicle type:

-- Business Problem
-- The management wants to evaluate customer satisfaction across different vehicle categories.
-- This helps identify which vehicle types provide the best customer experience and which may require improvement.

SELECT Vehicle_Type,
       ROUND(AVG(Customer_Rating),2) AS Average_rating
       FROM bookings
       GROUP BY Vehicle_type
       ORDER BY Average_rating DESC;
       
-- Business Impact
-- Measures customer satisfaction for each vehicle category.
-- Identifies high-performing and low-performing services.
-- Helps improve service quality and customer experience.
-- Supports data-driven decisions for fleet and service management.  

    
-- Instead of showing only the average rating, include the total number of ratings received.
SELECT Vehicle_Type,
       COUNT(customer_rating) AS Total_ratings,
       ROUND(AVG(Customer_Rating),2) AS Average_rating
       FROM bookings
       GROUP BY Vehicle_type
       ORDER BY Average_rating DESC;
-- Business Problem
-- Management wants to compare both customer satisfaction and the volume of customer feedback across vehicle categories.

-- Business Impact
-- Provides a more reliable view of customer satisfaction.
-- Helps identify whether a high rating is based on sufficient feedback.
-- Supports better service quality assessment.
-- Enables benchmarking of vehicle categories.       
-----------------------------------------------------------------------------------------------------------------------------------------       
       
# 9. Calculate the total booking value of rides completed successfully:

-- Business Problem
-- The management wants to determine the total revenue generated from successfully completed rides.
-- This is a key performance indicator (KPI) used to measure business growth and financial performance.

SELECT SUM(Booking_Value) AS Total_revenue
FROM bookings
WHERE Booking_status ="success";

-- Business Impact
-- Measures total revenue generated from completed rides.
-- Helps track business performance and growth.
-- Supports financial reporting and forecasting.
-- Assists management in making strategic decisions based on revenue trends.


-- Instead of only showing total revenue, analyze revenue by vehicle type.
SELECT Vehicle_type,
       COUNT(*) AS Total_Rides,
       SUM(Booking_value) AS Total_revenue
FROM bookings
WHERE Booking_Status = "Success"
GROUP BY Vehicle_type
ORDER BY Total_revenue DESC;       
-- Business Problem
-- Management wants to identify which vehicle categories contribute the most revenue to the business.
-- Business Impact
-- Identifies the highest revenue-generating vehicle types.
-- Supports pricing and fleet allocation decisions.
-- Helps optimize business strategies for profitable services.
-- Enables performance comparison across vehicle categories.
----------------------------------------------------------------------------------------------------------------------------------------

# 10. List all incomplete rides along with the reason:

-- Business Problem
-- Incomplete rides negatively impact customer experience and operational efficiency.
-- The management wants to identify all incomplete rides and understand the reasons behind them to reduce ride failures.

SELECT Booking_id, Incomplete_rides_reason
FROM bookings
WHERE Incomplete_rides = "yes";

-- Business Impact
-- Identifies ride failures and their causes.
-- Helps improve operational efficiency.
-- Reduces customer dissatisfaction.
-- Supports corrective actions to increase ride completion rates.


-- Instead of listing all incomplete rides, analyze the frequency of each incomplete ride reason.
SELECT Incomplete_Rides_Reason,
       COUNT(*) AS Total_Incomplete_Rides
FROM bookings
WHERE Incomplete_Rides = 'Yes'
GROUP BY Incomplete_Rides_Reason
ORDER BY Total_Incomplete_Rides DESC;
-- Business Problem
-- Management wants to identify the most common reasons behind incomplete rides so that targeted improvements can be made.
-- Business Impact
-- Highlights the major operational issues.
-- Helps prioritize problem-solving efforts.
-- Improves ride completion rates.
-- Enhances customer satisfaction and service reliability.
------------------------------------------------------------------------------------------------------------------------------------------