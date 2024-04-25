-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
select 
	sum(case when gender= 'Male' then 1 end) as nro_Hombres,
	sum(case when gender= 'Female' then 1 end) as nro_Mujeres
from hr
where age >= 18 and termdate='0000-00-00';

select * from hr;

-- lo metemos en una vista
create view w_primera_consulta as
select count(*) cantidad, gender from hr
where age >= 18 and termdate='0000-00-00'
group by gender;

select * from w_primera_consulta;
-- 2. What is the race/ethnicity breakdown of employees in the company?
create view v_segunda_vista as
select race,count(*) cantidad from hr
where age >= 18 and termdate='0000-00-00'
group by race
order by count(*) desc;

-- 3. What is the age distribution of employees in the company?
-- dividimos los grupos de edades a nuestro criterio, seleccionamos la edad mínima y la edad máxima
create view v_tercera_vista as
SELECT 
	CASE
		WHEN age>=18 and age <=24 THEN '18-24'
        WHEN age>=25 and age <=34 THEN '25-34'
        WHEN age>=35 and age <=44 THEN '35-44'
        WHEN age>=45 and age <=54 THEN '45-54'
		WHEN age>=55 and age <=64 THEN '55-64'
        ELSE '65+'
    END AS group_edad,
    count(*) AS cantidad
    FROM hr
    WHERE age >= 18 and termdate='0000-00-00'
    GROUP BY group_edad
    ORDER BY group_edad;
    
    -- ahora con el genero
    CREATE VIEW v_group_edad_genero as
    SELECT 
	CASE
		WHEN age>=18 and age <=24 THEN '18-24'
        WHEN age>=25 and age <=34 THEN '25-34'
        WHEN age>=35 and age <=44 THEN '35-44'
        WHEN age>=45 and age <=54 THEN '45-54'
		WHEN age>=55 and age <=64 THEN '55-64'
        ELSE '65+'
    END AS group_edad, gender,
    count(*) AS cantidad
    FROM hr
    WHERE age >= 18 and termdate='0000-00-00'
    GROUP BY group_edad,gender
    ORDER BY group_edad,gender;
    
-- 4. How many employees work at headquarters versus remote locations?
create view v_cuarta_vista as
SELECT location, count(*) cantidad FROM hr
WHERE age >= 18 and termdate='0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?/ datediff te da la diferencia en días entre dos fechas 
create view v_qinta_vista as
SELECT 
	round(avg(datediff(termdate,hire_date))/360,1) as duracion_tiempo_promedio_trabajado
FROM hr
WHERE termdate<=curdate() AND termdate <> '0000-00-00' AND age>=18;
select * from v_octava_vista;
-- 6. How does the gender distribution vary across departments and job titles?
create view v_sexta_vista as
SELECT department,jobtitle,
count(case when gender='Male'then 1 end) hombres,
count(case when gender='Female'then 1 end) mujeres,
count(case when gender='Non-Conforming'then 1 end) Non_Conforming
FROM hr
WHERE age >= 18 and termdate='0000-00-00'
group by department,jobtitle
order by department,jobtitle;

-- 7. What is the distribution of job titles across the company?
create view v_septima_vista as
SELECT jobtitle,count(*) as cantidad FROM hr
WHERE age >= 18 and termdate='0000-00-00'
group by jobtitle
order by jobtitle desc; 
select * from v_septima_vista;
-- 8. Which department has the highest turnover rate?/¿Qué departamento tiene la tasa de rotación más alta?
create view v_octava_vista as
SELECT department,total_count,terminated_count,terminated_count/total_count as terminaton_rate
FROM(
	SELECT department,
	count(*) as total_count,
	sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) as terminated_count
	FROM hr
	WHERE age >= 18
	GROUP BY department
) AS subquery
ORDER BY terminaton_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
create view v_novena_vista as
select location_city,location_state, count(*) cantidad from hr
WHERE age >= 18 and termdate='0000-00-00'
GROUP BY location_city,location_state
ORDER BY location_state;

-- 10. How has the company's employee count changed over time based on hire and term dates?
create view v_decima_vista as
SELECT year,hires,terminations,hires-terminations as net_change,
round((hires - terminations)/hires * 100,2) as net_change_percent
FROM (
	SELECT YEAR(hire_date) as year,
	count(*) as hires,
	SUM(CASE WHEN termdate <>'0000-00-00' AND termdate <=curdate() THEN 1 ELSE 0 END)AS terminations
	FROM hr
	WHERE age>=18
	GROUP BY YEAR(hire_date)
	)AS subQ
ORDER BY year ASC;

select * from v_decima_vista;
-- 11. What is the tenure distribution for each department?
create view v_undecima_vista as
SELECT department,round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
FROM hr
WHERE age >= 18 AND termdate <> '0000-00-00' AND termdate <= curdate()
GROUP BY department;

select * from v_undecima_vista;

-- link de youtube ejercicos : https://www.youtube.com/watch?v=PzyZI9uLXvY&ab_channel=HerDataProject

-- link de youtube para conexión de BI con MySQL: https://www.youtube.com/watch?v=yCZPdzSnVXQ&ab_channel=TSUSoftware



