--실습 join8 (과제)
SELECT regions.region_id, region_name, country_name
FROM regions, countries 
WHERE regions.region_id = countries.region_id
    AND region_name IN ('Europe');

--실습 join9 (과제)
SELECT regions.region_id, region_name, country_name, city
FROM regions, countries, locations
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND region_name IN ('Europe');

--실습 join10 (과제)
SELECT regions.region_id, region_name, country_name, city, department_name
FROM regions, countries, locations, departments
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id 
    AND region_name IN ('Europe');

--실습 join11 (과제)
SELECT regions.region_id, region_name,
        country_name, city, department_name,
        first_name || ' ' || last_name AS name
FROM regions, countries, locations, departments, employees
WHERE regions.region_id = countries.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND departments.department_id = employees.department_id
    AND region_name IN ('Europe');

--실습 join12 (과제)
SELECT employee_id, first_name || ' ' || last_name AS name,
        jobs.job_id, jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

--실습 join13 (과제)
SELECT m.employee_id AS mgr_id,
        m.first_name || ' ' || m.last_name AS mgr_name,
        e.employee_id,
        e.first_name || ' ' || e.last_name AS name,
        e.job_id, jobs.job_title
FROM employees e, employees m, jobs
WHERE e.manager_id = m.employee_id
        AND e.job_id = jobs.job_id;