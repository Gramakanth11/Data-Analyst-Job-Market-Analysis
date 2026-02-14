# 1 -- Inspect Raw Data
SELECT *
FROM job_postings_fact
LIMIT 10;

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    job_work_from_home,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 20;


# 2 -- Filter to Relevant Roles (Data Analyst + Remote)
SELECT
job_id,
job_title,
job_location,
job_work_from_home,
salary_year_avg
FROM job_postings_fact
WHERE
salary_year_avg IS NOT NULL
AND job_title_short = 'Data Analyst'
AND job_work_from_home = 'True'
ORDER BY
salary_year_avg DESC;

# 3 -- Top-paying Data Analyst jobs (no remote filter yet)
SELECT
  job_id,
  job_title,
  job_location,
  salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

# 4 -- Most In-Demand Skills (JOIN)
SELECT
  s.skills,
  d.demand_count
FROM analyst_skill_demand d
JOIN skills_dim s ON d.skill_id = s.skill_id
ORDER BY d.demand_count DESC
LIMIT 10;

# 5 -- Highest-Paying Skills (Salary + Demand)
SELECT
  s.skills,
  ROUND(AVG(j.salary_year_avg), 0) AS avg_salary,
  COUNT(*) AS job_count
FROM job_postings_fact j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
GROUP BY s.skills
HAVING COUNT(*) >= 20
ORDER BY avg_salary DESC;

# 6 -- OPTIMAL Skills (Demand + Salary)
SELECT
  s.skills,
  d.demand_count,
  sal.avg_salary,
  ROUND(d.demand_count * sal.avg_salary / 1000, 0) AS opportunity_score
FROM analyst_skill_demand d
JOIN skills_dim s ON d.skill_id = s.skill_id
LEFT JOIN analyst_skill_salary sal ON d.skill_id = sal.skill_id
WHERE d.demand_count >= 50
ORDER BY opportunity_score DESC;

####
SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;
SET SESSION wait_timeout = 600;
SET SESSION interactive_timeout = 600;
