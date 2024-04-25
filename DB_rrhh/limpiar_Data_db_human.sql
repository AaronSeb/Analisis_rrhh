create database data_Human;
select * from hr;

-- ----------EMPEZAMOS A LIMPIAR LOS DATOS
-- cambiamos el nombre de la columna id
alter table hr
change column ï»¿id emp_id VARCHAR(20)NULL;

-- -identificamos que la fecha es de tipo text
describe hr;

select birthdate from hr;

-- habilitamos el modo seguro
set sql_safe_updates = 0;
-- Aquí actualizamos para que la fecha sea formato año mes dia 
UPDATE hr 
SET birthdate = 
    CASE 
        WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%y'), '%Y-%m-%d')
        ELSE NULL
    END;
-- Aquí modificamos birthdate para que sea tipo date
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
describe hr;

-- hacemos lo mismo para hiredate
UPDATE hr 
SET hire_date = 
    CASE 
        WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
        ELSE NULL
    END;
select termdate from hr;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
describe hr;

-- lo hacemos con termdate

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL OR termdate = '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;
describe hr;

-- agregando columna edad
ALTER TABLE hr ADD COLUMN age INT;
select * from hr;

-- Agregando la edad a la columna edad
UPDATE hr
SET age = timestampdiff(YEAR,birthdate,CURDATE());

-- observamos que hay valores negativos
SELECT 
MIN(age) as joven,
MAX(age) as viejo
FROM hr;

select count(*) from hr
where age<18;

