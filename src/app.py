"""FastAPI app for BudgetBot. Runtime-agnostic."""
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, File, Header, HTTPException, Request, Response, UploadFile
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware

from src.config import config
from src.adapters import factory
from src import handlers
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest


app = FastAPI(title="BudgetBot — W7 Capstone Starter")

REQUESTS = Counter(
    "budgetbot_http_requests_total",
    "HTTP requests handled by BudgetBot.",
    ("method", "path", "status"),
)
LATENCY = Histogram(
    "budgetbot_http_request_duration_seconds",
    "BudgetBot HTTP request latency.",
    ("method", "path"),
)


# CORS — allow frontend to live on a different origin (CloudFront / Amplify / separate ALB).
# CORS_ORIGINS env var controls this; default '*' is permissive for hackathon.
_allowed = ["*"] if config.cors_origins == "*" else [o.strip() for o in config.cors_origins.split(",") if o.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=_allowed,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

ai_client = factory.make_ai()
storage = factory.make_storage()
userstore = factory.make_userstore()


@app.middleware("http")
async def observe_requests(request: Request, call_next):
    path = request.url.path
    with LATENCY.labels(request.method, path).time():
        response = await call_next(request)
    REQUESTS.labels(request.method, path, str(response.status_code)).inc()
    return response


def _resolve_user_id(x_user_id: Optional[str]) -> str:
    return x_user_id or config.default_user_id


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "backends": {
            "ai": config.ai_backend,
            "storage": config.storage_backend,
            "userstore": config.userstore_backend,
        },
    }


@app.get("/ready")
def ready() -> dict:
    return {"status": "ready"}


@app.get("/metrics", include_in_schema=False)
def metrics() -> Response:
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.post("/upload")
async def upload(
    file: UploadFile = File(...),
    x_user_id: Optional[str] = Header(default=None),
) -> dict:
    user_id = _resolve_user_id(x_user_id)
    data = await file.read()
    if not data:
        raise HTTPException(status_code=400, detail="Empty file")
    return handlers.handle_upload(
        user_id=user_id,
        filename=file.filename or "statement.csv",
        data=data,
        ai_client=ai_client,
        storage=storage,
        userstore=userstore,
    )


@app.get("/summary")
def summary(
    month: Optional[str] = None,
    x_user_id: Optional[str] = Header(default=None),
) -> dict:
    """`month` format: YYYY-MM. Omit for all-time summary."""
    return handlers.handle_summary(_resolve_user_id(x_user_id), month, userstore)


@app.get("/transactions")
def transactions(
    month: Optional[str] = None,
    x_user_id: Optional[str] = Header(default=None),
) -> dict:
    return handlers.handle_list_transactions(_resolve_user_id(x_user_id), month, userstore)


# ---- Static frontend ----
FRONTEND_DIR = Path(__file__).resolve().parent.parent / "frontend"


if config.serve_frontend:
    @app.get("/")
    def index() -> FileResponse:
        """Convenience: serves frontend/index.html at /. Set SERVE_FRONTEND=false
        if you deploy the frontend separately (CloudFront+S3, Amplify, ALB)."""
        return FileResponse(FRONTEND_DIR / "index.html")
