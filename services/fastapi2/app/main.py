from fastapi import APIRouter, FastAPI

# TODO(tobi): Usar ApiRouter
app     = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

# public = APIRouter(prefix="/api/fastapi2")

@app.get("/api/fastapi2")
def home():
    return "FastApi2 says: Hello World!"

# private = APIRouter(prefix="/fastapi")

@app.get("/fastapi2")
def private_home():
    return "Private FastApi2 says: Hello World Privately!"

# app.include_router(public)
# app.include_router(private)
