Create DATABASE data_job_analytics;
USE data_job_analytics;

CREATE TABLE job_postings_fact (
    job_id INT PRIMARY KEY,
    company_id INT,
    job_title_short VARCHAR(100),
    job_title VARCHAR(500),
    job_location VARCHAR(255),
    job_via VARCHAR(255),
    job_schedule_type VARCHAR(100),
    job_work_from_home BOOLEAN,
    search_location VARCHAR(255),
    job_posted_date DATETIME,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR(100),
    salary_rate VARCHAR(50),
    salary_year_avg DECIMAL(10,2),
    salary_hour_avg DECIMAL(10,2)
);

CREATE TABLE skills_dim (
    skill_id INT PRIMARY KEY,
    skills VARCHAR(100),
    skill_type VARCHAR(50)
);

CREATE TABLE company_dim (
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

CREATE TABLE skills_job_dim (
    job_id INT,
    skill_id INT 
);

#4
CREATE TABLE analyst_jobs AS
SELECT job_id, salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst';
#4
CREATE TABLE analyst_skill_demand AS
SELECT
  sj.skill_id,
  COUNT(*) AS demand_count
FROM analyst_jobs j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
GROUP BY sj.skill_id;
#6
CREATE TABLE analyst_skill_salary AS
SELECT
  sj.skill_id,
  ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
FROM analyst_jobs j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY sj.skill_id;


--------------------------------------------

USE data_job_analytics;
SELECT COUNT(*) FROM job_postings_fact;
SELECT COUNT(*) FROM skills_dim;
SELECT COUNT(*) FROM skills_job_dim;
SELECT COUNT(*) FROM company_dim;

---------------------------------------------------
ALTER TABLE job_postings_fact
ADD PRIMARY KEY (job_id);

ALTER TABLE skills_dim
ADD PRIMARY KEY (skill_id);

ALTER TABLE company_dim
ADD PRIMARY KEY (company_id);


CREATE INDEX idx_job_title_short
ON job_postings_fact (job_title_short);

CREATE INDEX idx_job_remote
ON job_postings_fact (job_work_from_home);

CREATE INDEX idx_salary
ON job_postings_fact (salary_year_avg);

CREATE INDEX idx_sj_job
ON skills_job_dim (job_id);

CREATE INDEX idx_sj_skill
ON skills_job_dim (skill_id);

---------------------------------------------------------------------------------

SELECT j.job_title, c.name
FROM job_postings_fact j
JOIN company_dim c
  ON j.company_id = c.company_id
LIMIT 5;

SELECT j.job_title, s.skills
FROM job_postings_fact j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
LIMIT 5;


----------------------------------------------------------------------------
USE data_job_analytics;

DESCRIBE job_postings_fact; -- shows the schemes rows in table
DROP TABLE IF EXISTS skills_job_dim; -- deletes the entire table
TRUNCATE TABLE job_postings_fact; -- to avoid duplicates

ALTER TABLE job_postings_fact
MODIFY COLUMN job_via VARCHAR(255); -- If in case any edit for table columns


SELECT job_work_from_home, COUNT(*)
FROM job_postings_fact
GROUP BY job_work_from_home;

-----------------------------------------------------------------------------------------------------

'''
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:\Sql_Job_Market_Analysis\data_job_analysis\job_postings_fact.csv'
INTO TABLE job_postings_fact
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_postings_fact.csv'
INTO TABLE job_postings_fact
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;
