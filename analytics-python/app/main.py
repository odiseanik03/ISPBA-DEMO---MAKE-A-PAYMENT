from fastapi import FastAPI
from app.api.routes_analytics import router as analytics_router

app = FastAPI(title="AccountFlow Analytics", version="0.1.0")
app.include_router(analytics_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "UP", "service": "analytics-python"}
