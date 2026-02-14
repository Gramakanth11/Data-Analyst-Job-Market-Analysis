# Data-Analyst-Job-Market-Analysis

## Project Overview

This project analyzes 1.02 million+ global job postings to identify:
- Most in-demand skills
- Skills with the highest salaries
- Skills offering the best market opportunity

The project follows a real-world analyst workflow:
- Data ingestion → Cleaning → Database modeling → Indexing → SQL analytics.

The focus is entirely on SQL-driven insights at scale.


## ⚙️ Data Pipeline

1. Loaded raw CSV files using Pandas
2. Cleaned null values and handled string length constraints
3. Imported datasets into MySQL
4. Created relational structure (fact + dimension tables)
5. Added indexes to optimize large joins
6. Built SQL queries for business insights


## Business Problem

Aspiring data professionals often ask:
- Which skills are most demanded in the job market?
- Which skills pay the highest salaries?
- Which skills provide the best balance between demand and compensation?

This project answers those questions using structured SQL analysis.


## 📈 SQL Analysis & What Each Query Reveals

1. Job Volume by Role:
-- What This Shows:
- Identifies the most common data-related roles.
- Helps understand market demand distribution across roles.
- Example insight: Data Analyst, Data Engineer, and Data Scientist dominate postings.

2. Most In-Demand Skills (For Data Analyst Roles):
-- What This Shows:
- Which skills appear most frequently in analyst job postings.
- Reveals core technical expectations of the market.
- Example insight: SQL, Excel, Python, and BI tools dominate demand.

3. Highest Paying Skills:
-- What This Shows:
- Average salary associated with each skill.
- Identifies premium skills valued by employers.
- Shows that some skills are high-paying but may not be high-demand.

4. Opportunity Score (Demand × Salary):
-- What This Shows:
- Combines demand and salary into one metric.
- Identifies skills with strong market demand AND strong pay.
- Helps prioritize skills for career growth.
- Example insight: SQL and Python provide strong ROI due to both demand and salary.


## 🧠 Key Insights

- SQL is the most consistently demanded analyst skill.
- Python provides strong salary upside.
- BI tools offer high practical market value.
- High salary alone does not guarantee strong opportunity — demand matters.
- Balanced skills provide better long-term market positioning.


## 🛠 Tech Stack

1. Python (Pandas, SQLAlchemy) – Data ingestion
2. MySQL – Data storage & analytics
3. SQL – Business insight generation
4. Star-schema modeling approach
