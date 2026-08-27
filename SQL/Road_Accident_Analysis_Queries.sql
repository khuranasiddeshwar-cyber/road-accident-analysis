-- ROAD ACCIDENT ANALYSIS
-- SQL Queries Used for Dashboard Validation

-- 1. Current Year Casualties
SELECT
    SUM(number_of_casualties) AS current_year_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022;


-- 2. Current Year Accidents
SELECT
    COUNT(DISTINCT accident_index) AS current_year_accidents
FROM road_accident
WHERE YEAR(accident_date) = 2022;


-- 3. Current Year Fatal Casualties
SELECT
    SUM(number_of_casualties) AS current_year_fatal_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
  AND accident_severity = 'Fatal';


-- 4. Current Year Serious Casualties
SELECT
    SUM(number_of_casualties) AS current_year_serious_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
  AND accident_severity = 'Serious';


-- 5. Current Year Slight Casualties
SELECT
    SUM(number_of_casualties) AS current_year_slight_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
  AND accident_severity = 'Slight';


-- 6. Casualties by Vehicle Type
SELECT
    CASE
        WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
        WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Car'
        WHEN vehicle_type IN (
            'Motorcycle 50cc and under',
            'Motorcycle over 50cc and up to 125cc',
            'Motorcycle over 125cc and up to 500cc',
            'Motorcycle over 500cc'
        ) THEN 'Bike'
        WHEN vehicle_type IN (
            'Bus or coach (17 or more pass seats)',
            'Minibus (8 - 16 passenger seats)'
        ) THEN 'Bus'
        WHEN vehicle_type IN (
            'Goods vehicle - unknown weight',
            'Van / Goods 3.5 tonnes mgw or under'
        ) THEN 'Van'
        ELSE 'Other'
    END AS vehicle_group,
    SUM(number_of_casualties) AS current_year_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY
    CASE
        WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
        WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Car'
        WHEN vehicle_type IN (
            'Motorcycle 50cc and under',
            'Motorcycle over 50cc and up to 125cc',
            'Motorcycle over 125cc and up to 500cc',
            'Motorcycle over 500cc'
        ) THEN 'Bike'
        WHEN vehicle_type IN (
            'Bus or coach (17 or more pass seats)',
            'Minibus (8 - 16 passenger seats)'
        ) THEN 'Bus'
        WHEN vehicle_type IN (
            'Goods vehicle - unknown weight',
            'Van / Goods 3.5 tonnes mgw or under'
        ) THEN 'Van'
        ELSE 'Other'
    END;


-- 7. Current Year Monthly Casualties
SELECT
    DATENAME(MONTH, accident_date) AS month_name,
    SUM(number_of_casualties) AS casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY
    DATENAME(MONTH, accident_date),
    MONTH(accident_date)
ORDER BY MONTH(accident_date);


-- 8. Previous Year Monthly Casualties
SELECT
    DATENAME(MONTH, accident_date) AS month_name,
    SUM(number_of_casualties) AS casualties
FROM road_accident
WHERE YEAR(accident_date) = 2021
GROUP BY
    DATENAME(MONTH, accident_date),
    MONTH(accident_date)
ORDER BY MONTH(accident_date);


-- 9. Casualties by Road Type
SELECT
    road_type,
    SUM(number_of_casualties) AS current_year_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY road_type;


-- 10. Casualties by Urban/Rural
SELECT
    urban_or_rural_area,
    SUM(number_of_casualties) AS current_year_casualties
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY urban_or_rural_area;


-- 11. Urban/Rural Percentage of Total Casualties
SELECT
    urban_or_rural_area,
    CAST(
        100.0 * SUM(number_of_casualties)
        / SUM(SUM(number_of_casualties)) OVER ()
        AS DECIMAL(10,2)
    ) AS percentage_of_total
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY urban_or_rural_area;


-- 12. Casualties by Light Condition — Day vs Night
SELECT
    CASE
        WHEN light_conditions = 'Daylight'
            THEN 'Day'
        WHEN light_conditions IN (
            'Darkness - no lighting',
            'Darkness - lights lit',
            'Darkness - lights unlit',
            'Darkness - lighting unknown'
        )
            THEN 'Night'
    END AS light_condition,
    CAST(
        100.0 * SUM(number_of_casualties)
        / SUM(SUM(number_of_casualties)) OVER ()
        AS DECIMAL(10,2)
    ) AS percentage_of_total
FROM road_accident
WHERE YEAR(accident_date) = 2022
GROUP BY
    CASE
        WHEN light_conditions = 'Daylight'
            THEN 'Day'
        WHEN light_conditions IN (
            'Darkness - no lighting',
            'Darkness - lights lit',
            'Darkness - lights unlit',
            'Darkness - lighting unknown'
        )
            THEN 'Night'
    END;


-- 13. Top 10 Locations by Casualties
SELECT TOP 10
    local_authority,
    SUM(number_of_casualties) AS total_casualties
FROM road_accident
GROUP BY local_authority
ORDER BY total_casualties DESC;
