Create DATABASE data_job_analytics;
USE data_job_analytics;
# 1.
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

# 2.
CREATE TABLE skills_dim (
    skill_id INT PRIMARY KEY,
    skills VARCHAR(100),
    skill_type VARCHAR(50)
);

# 3.
CREATE TABLE company_dim (
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

# 4.
CREATE TABLE skills_job_dim (
    job_id INT,
    skill_id INT 
);

---------------------------------------------------

-- a,b,c tables for clear analysis of Data Analyst job analysis

# a
CREATE TABLE analyst_jobs AS
SELECT job_id, salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst';

# b
CREATE TABLE analyst_skill_demand AS
SELECT
  sj.skill_id,
  COUNT(*) AS demand_count
FROM analyst_jobs j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
GROUP BY sj.skill_id;

# c
CREATE TABLE analyst_skill_salary AS
SELECT
  sj.skill_id,
  ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
FROM analyst_jobs j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
WHERE j.salary_year_avg IS NOT NULL
GROUP BY sj.skill_id;


--------------------------------------------
-- Checking whether the dataset is imported
USE data_job_analytics;
SELECT COUNT(*) FROM job_postings_fact;
SELECT COUNT(*) FROM skills_dim;
SELECT COUNT(*) FROM skills_job_dim;
SELECT COUNT(*) FROM company_dim;

---------------------------------------------------

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
