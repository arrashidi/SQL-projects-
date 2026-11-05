DROP TABLE IF EXISTS certified;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS aircraft;

CREATE DATABASE IF NOT EXISTS flights;
USE flights;

CREATE TABLE IF NOT EXISTS flight(
	flno INT,
    origin VARCHAR(20),
    destination VARCHAR(20),
    distance INT,
    departs TIME,
    arrives TIME,
    price REAL,
    PRIMARY KEY (flno) 
);

CREATE TABLE IF NOT EXISTS aircraft(
	aid INT,
    aname VARCHAR(20),
    cruisingrange INT,
    PRIMARY KEY (aid) 
);

CREATE TABLE IF NOT EXISTS employees(
	eid INT,
    ename VARCHAR(20),
    salary INT,
    PRIMARY KEY (eid) 
);

CREATE TABLE IF NOT EXISTS certified(
	eid INT,
    aid INT,
    PRIMARY KEY (eid,aid),
    FOREIGN KEY (eid) REFERENCES employees (eid),
    FOREIGN KEY (aid) REFERENCES aircraft (aid) 
);

INSERT INTO flight
	(flno,
	origin,
	destination,
	distance,
	departs,
	arrives,
	price) VALUES 
(1,'Bangalore','Mangalore',360,'10:45:00','12:00:00',10000),
(2,'Bangalore','Delhi',5000,'12:15:00','04:30:00',25000),
(3,'Bangalore','Mumbai',3500,'02:15:00','05:25:00',30000),
(4,'Delhi','Mumbai',4500,'10:15:00','12:05:00',35000),
(5,'Delhi','Frankfurt',18000,'07:15:00','05:30:00',90000),
(6,'Bangalore','Frankfurt',19500,'10:00:00','07:45:00',95000),
(7,'Bangalore','Frankfurt',17000,'12:00:00','06:30:00',99000);

INSERT INTO aircraft (aid,aname,cruisingrange) values 
(123,'Airbus',1000),
(302,'Boeing',5000),
(306,'Jet01',5000),
(378,'Airbus380',8000),
(456,'Aircraft',500),
(789,'Aircraft02',800),
(951,'Aircraft03',1000);

INSERT INTO employees (eid,ename,salary) VALUES
(1,'Ajay',30000),
(2,'Ajith',85000),
(3,'Arnab',50000),
(4,'Harry',45000),
(5,'Ron',90000),
(6,'Josh',95000),
(7,'Ram',100000);

INSERT INTO certified (eid,aid) VALUES
(1,123),
(2,123),
(1,302),
(5,302),
(7,302),
(1,306),
(2,306),
(1,378),
(2,378),
(3,456),
(5,789),
(3,951),
(1,951),
(1,789);
SELECT * FROM flight;
SELECT * FROM aircraft;
SELECT * FROM employees;
SELECT * FROM certified;
-- Q1. Names of aircrafts with salary higher than 80,000
SELECT DISTINCT a.aname
FROM aircraft a
WHERE a.aid NOT IN (
    SELECT c.aid
    FROM certified c
    JOIN employees e ON c.eid = e.eid
    WHERE e.salary <= 80000
);
-- Question 2
select ename
from employees e
where salary < (select MIN(price)
from flight
where origin= 'Bangalore'
AND Destination = 'Frankfurt'
);

-- Question 3

SELECT a.aname, AVG(e.salary) AS avg_pilot_salary
FROM aircraft a
JOIN certified c ON a.aid = c.aid
JOIN employees e ON c.eid = e.eid
WHERE a.cruisingrange > 1000
GROUP BY a.aid, a.aname;
-- Question 4
select flno, origin, destination, distance 
from flight 
where distance <(
    select min(ac.cruisingrange)
from aircraft ac
join Certified c on ac.aid= c.aid
join employees e on c.eid=e.eid
where e.salary > 70000
);

-- Question 5

SELECT DISTINCT e.ename
FROM employees e
JOIN certified c ON e.eid = c.eid
JOIN aircraft ac ON c.aid = ac.aid
WHERE ac.cruisingrange > 3000
AND e.eid NOT IN (
    SELECT c2.eid
    FROM certified c2
    JOIN aircraft ac2 ON c2.aid = ac2.aid
    WHERE ac2.aname = 'Boeing'
);

-- Question 6
SELECT
    (SELECT AVG(DISTINCT e.salary)
     FROM employees e
     JOIN certified c ON c.eid = e.eid)
    -
    (SELECT AVG(salary)
     FROM employees)
    AS salary_difference;

-- Question 7
SELECT e.ename, e.salary
FROM employees e
WHERE e.eid NOT IN (
    SELECT DISTINCT eid 
    FROM certified
)
AND e.salary > (
    SELECT AVG(DISTINCT e2.salary)
    FROM employees e2
    JOIN certified c ON c.eid = e2.eid
);
