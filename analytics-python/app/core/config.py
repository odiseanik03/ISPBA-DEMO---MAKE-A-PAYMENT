import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+psycopg://accountflow:accountflow@localhost:5432/accountflow")
