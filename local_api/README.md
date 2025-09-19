# HTTP API (FastAPI + uv)

Serve `data/data.json` over HTTP.

## Quick start

```bash
# from repo root, go into this folder (recommended)
cd local_api

# install uv if needed
curl -LsSf https://astral.sh/uv/install.sh | sh

# create & use a virtualenv (optional but recommended)
uv venv
. .venv/bin/activate

# run with uvicorn via uv (reload for dev)
uv run uvicorn main:app --host 0.0.0.0 --port 28080 --reload
# or without reload
uv run uvicorn main:app --host 0.0.0.0 --port 28080

# If you prefer to stay at repo root, target the project path:
cd ..
uv run --project http_api uvicorn http_api.main:app --host 0.0.0.0 --port 28080 --reload
```

- **API**: `http://localhost:28080`
- **Docs**: `http://localhost:28080/docs`
- **Health**: `GET /health` → `ok`
- **JSON**: `GET /data` → serves `data.json`

## Notes
- Uses FastAPI and Uvicorn.
- `uv` handles dependency resolution and running scripts.
