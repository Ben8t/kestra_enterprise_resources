from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, PlainTextResponse


app = FastAPI(title="Kestra EE Prod HTTP API", version="0.1.0")


BASE_DIR = Path(__file__).parent
DATA_FILE = BASE_DIR / "data" / "data.json"


@app.get("/health", response_class=PlainTextResponse)
def health() -> str:
    return "ok"


@app.get("/data", response_class=FileResponse, summary="Serve data.json")
def get_data() -> FileResponse:
    if not DATA_FILE.exists():
        raise HTTPException(status_code=404, detail="data.json not found")
    return FileResponse(path=DATA_FILE, media_type="text/json", filename="data.json")


# Optional root for quick discovery
@app.get("/")
def root() -> dict:
    return {
        "message": "Welcome to the Kestra EE Prod HTTP API",
        "endpoints": ["/health", "/data", "/docs", "/openapi.json", "/redoc"],
    }


