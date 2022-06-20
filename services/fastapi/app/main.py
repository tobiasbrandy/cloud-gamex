from fastapi import APIRouter, FastAPI
import requests

# TODO(tobi): Usar ApiRouter
app     = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

# public = APIRouter(prefix="/api/fastapi")


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
    return requests.get("http://services.private.cloud.com/fastapi").text
  except Exception as e:
    return str(e)


@app.get("/api/fastapi/echo2")
def echo2():
  try:
    return requests.get("http://services.private.cloud.com/api/fastapi").text
  except Exception as e:
    return str(e)

# private = APIRouter(prefix="/fastapi")


@app.get("/fastapi")
def private_home():
    return "Private FastApi says: Hello World Privately!"

# app.include_router(public)
# app.include_router(private)