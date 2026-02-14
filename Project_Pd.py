import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus
from sqlalchemy import text
# 🔴 PUT YOUR REAL MYSQL PASSWORD HERE (with @ in it)
RAW_PASSWORD = "Chinna@11"

# ✅ Encode password (this is mandatory)
ENCODED_PASSWORD = quote_plus(RAW_PASSWORD)

# ✅ Build connection string
DATABASE_URL = (
    f"mysql+pymysql://root:{ENCODED_PASSWORD}"
    f"@localhost:3306/data_job_analytics"
)

print("DEBUG URL (password hidden):", DATABASE_URL.replace(ENCODED_PASSWORD, "*****"))

# ✅ Try connecting
engine = create_engine(DATABASE_URL)

with engine.connect() as conn:
    print("✅ CONNECTED TO MYSQL SUCCESSFULLY")


# -------------------------------------------------
# 2. Load job_postings_fact
# -------------------------------------------------
jobs = pd.read_csv("job_postings_fact.csv")


jobs["job_work_from_home"] = jobs["job_work_from_home"].map({"True": 1, "False": 0})
jobs["job_no_degree_mention"] = jobs["job_no_degree_mention"].map({"True": 1, "False": 0})
jobs["job_health_insurance"] = jobs["job_health_insurance"].map({"True": 1, "False": 0})


# Convert boolean columns
bool_cols = [
    "job_work_from_home",
    "job_no_degree_mention",
    "job_health_insurance"
]

for col in bool_cols:
    jobs[col] = jobs[col].map({"True": 1, "False": 0})

# Fix Dates + Text (Prevent SQL Errors)
jobs["job_posted_date"] = pd.to_datetime(
    jobs["job_posted_date"],
    dayfirst=True,
    errors="coerce"
)



jobs.to_sql(
    "job_postings_fact",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=10000,
    method = 'multi'
)

print("✅ job_postings_fact loaded")

# -------------------------------------------------
# 3. Load skills_dim
# -------------------------------------------------
skills = pd.read_csv("skills_dim.csv")

skills.to_sql(
    "skills_dim",
    con=engine,
    if_exists="append",
    index=False
)

print("✅ skills_dim loaded")

# -------------------------------------------------
# 4. Load skills_job_dim
# -------------------------------------------------
skills_jobs = pd.read_csv("skills_job_dim.csv")

skills_jobs.to_sql(
    "skills_job_dim",
    con=engine,
    if_exists="append",
    index=False
)

print("✅ skills_job_dim loaded")

# -------------------------------------------------
# 5. Load company_dim
# -------------------------------------------------
company = pd.read_csv("company_dim.csv")

# avoid long text crashes
jobs["job_via"] = jobs["job_via"].astype(str).str.slice(0, 100)

company["name"] = company["name"].astype(str).str.slice(0, 255)
company["link"] = company["link"].astype(str).str.slice(0, 500)
company["link_google"] = company["link_google"].astype(str).str.slice(0, 500)
company["thumbnail"] = company["thumbnail"].astype(str).str.slice(0, 500)

company.to_sql(
    "company_dim",
    con=engine,
    if_exists="append",
    index=False
)

print("✅ company_dim loaded")


print("\n🎯 ALL 4 DATASETS SUCCESSFULLY LOADED INTO MYSQL")


# Row Count Validation (SQL)
with engine.connect() as conn:
    for table in [
        "job_postings_fact",
        "skills_dim",
        "skills_job_dim",
        "company_dim"
    ]:
        count = conn.execute(
            text(f"SELECT COUNT(*) FROM {table}")
        ).scalar()
        print(table, "→", count)
     
# Indexes
tables = [
    "job_postings_fact",
    "skills_dim",
    "skills_job_dim",
    "company_dim"
]

with engine.connect() as conn:
    conn.execute(text("CREATE INDEX idx_job_id ON job_postings_fact(job_id)"))
    conn.execute(text("CREATE INDEX idx_job_role ON job_postings_fact(job_title_short)"))
    conn.execute(text("CREATE INDEX idx_job_salary ON job_postings_fact(salary_year_avg)"))

    conn.execute(text("CREATE INDEX idx_sj_job ON skills_job_dim(job_id)"))
    conn.execute(text("CREATE INDEX idx_sj_skill ON skills_job_dim(skill_id)"))

    conn.execute(text("CREATE INDEX idx_skill_id ON skills_dim(skill_id)"))

print("✅ Indexes created")


