from sqlalchemy import Integer,String
from sqlalchemy.sql.schema import Column
from app.db.config import Base

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer,primary_key = True)
    email = Column(String,nullable=False)
    password = Column(String,nullable=False)
    
    