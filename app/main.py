from fastapi import FastAPI

from settings.config import settings


app = FastAPI(
    title=settings.title,
    description=settings.description,
    version=settings.version,
    openapi_url=settings.openapi_url,
    docs_url=settings.docs_url,
    redoc_url=None,
)


@app.get("/")
def root():
    return {"message": "Hello World"}