import os
from core.config import settings
from db.session import engine  # new
from db.base_class import Base  # new
from app.main import app
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from fastapi.app.db.tables import models


class Settings:
    DB_USER: str = os.getenv("DB_USER")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD")
    DB_ADRESS: str = os.getenv("DB_ADRESS", "localhost")
    DB_PORT: str = os.getenv("DB_PORT", 5432)  # default postgres port is 5432
    DB_NAME: str = os.getenv("DB_NAME")
    DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_ADRESS}:{DB_PORT}/{DB_NAME}"


settings = Settings()
engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
models.Base.metadata.create_all(bing=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    except:
        db.close()


"""     primary.csros2irtdwe.us-east-1.rds.amazonaws.com:port """
