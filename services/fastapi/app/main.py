from http.client import HTTPException
from typing import List

import requests

from db.config import get_db
from db.service import userService
from fastapi import Depends, FastAPI, HTTPException
from fastapi.app.db.tables import models, schemas
from sqlalchemy.orm import Session

# TODO(tobi): Usar ApiRouter
# app.include_router(public)
# app.include_router(private)
# public = APIRouter(prefix="/api/fastapi")
app = FastAPI()


@app.get("/")
def healthcheck():
    return "Healthcheck"


@app.get("/api/fastapi")
def home():
    return "FastApi says: Hello World!"


@app.get("/api/fastapi/apicall")
def api_call():
    try:
        return requests.get("http://services.private.cloud.com/fastapi2").text
    except Exception as e:
        return str(e)


@app.get("/api/fastapi/apicall2")
def api_call2():
    try:
        return requests.get("http://services.private.cloud.com/api/fastapi2").text
    except Exception as e:
        return str(e)


@app.get("/api/fastapi/echo")
def echo():
    try:
        return requests.get("http://internal-discovery-alb-1248751842.us-east-1.elb.amazonaws.com/fastapi").text
    except Exception as e:
        return str(e)


@app.get("/api/fastapi/echo2")
def echo2():
    try:
        return requests.get("http://internal-discovery-alb-1248751842.us-east-1.elb.amazonaws.com/api/fastapi").text
    except Exception as e:
        return str(e)


# private = APIRouter(prefix="/fastapi")


@app.get("/fastapi")
def private_home():
    return "Private FastApi says: Hello World Privately!"


@app.post("/api/fastapi/users", response_model=schemas.User)
def create_user(user: schemas.User, db: Session = Depends(get_db)):
    db_user = userService.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return userService.create_user(db=db, user=user)


@app.get("/api/fastapi/users", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = userService.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/api/fastapi/users/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = userService.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
