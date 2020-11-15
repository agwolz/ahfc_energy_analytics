--MatSu Schools Electricity Ratios

SELECT 
  b_id, 
  read_day, 
  read_month, 
  read_year, 
  -- Add ratio from 6 am to 8 pm
  SUM(CASE WHEN read_hour IN (7,8,9,10,11,12,13,14,15,16) THEN sensor_value END) 
  / SUM(CASE WHEN read_hour NOT IN (7,8,9,10,11,12,13,14,15,16) THEN sensor_value END) 
  AS school_hours_ratio,
  SUM(CASE WHEN read_hour IN (13,14,15,16,17,18,19,20,21,22,23,0) THEN sensor_value END) 
  / SUM(CASE WHEN read_hour NOT IN (13,14,15,16,17,18,19,20,21,22,23,0) THEN sensor_value END) 
  AS inferred_ratio

FROM 
(
  SELECT 
        b.title as building_name,
        s.secondary_building_id as b_id,
        sr.read_time AS read_time,
        DATE_TRUNC('day', sr.read_time) as read_day,
        DATE_TRUNC('month', sr.read_time) as read_month,
        DATE_TRUNC('year', sr.read_time) as read_year,
        date_part('hour', sr.read_time) AS read_hour,
        sr.read_value as sensor_value
    FROM public.matsu_buildings b
    JOIN public.matsu_sensors s
      ON s.building_id = b.id
    JOIN public.matsu_sensor_readings sr
      ON sr.sensor_id = s.sensor_id
    WHERE lower(s.title) LIKE '%elec%'
    -- GROUP BY 1,2,3,4,5
) a 
  
GROUP BY 1,2,3,4
