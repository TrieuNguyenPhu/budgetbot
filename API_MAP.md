# API map

| Method | Path | Input | Result |
|---|---|---|---|
| GET | `/` | — | Static SPA when enabled |
| GET | `/health` | — | Process health and selected backends |
| GET | `/ready` | — | Readiness signal |
| GET | `/metrics` | — | Prometheus exposition |
| POST | `/upload` | multipart `file`; optional `X-User-Id` | Parse, categorize, persist; counts + up to 5 samples |
| GET | `/summary` | optional `month=YYYY-MM`, `X-User-Id` | Totals by category and top 3 drivers |
| GET | `/transactions` | optional month/user header | User-scoped transaction list |

Errors currently surfaced explicitly: empty upload → `400`. Missing user header falls back to configured default user. OpenAPI is available at `/docs`.
