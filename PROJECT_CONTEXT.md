# Project context

BudgetBot là FastAPI FinTech service: upload sao kê CSV, phân loại từng giao dịch, lưu theo user và tổng hợp chi tiêu. Repo cũng chứa GitOps platform và Terraform AWS deployment lab.

## Stable boundaries

- `src/app.py`: HTTP boundary; `src/handlers.py`: use cases.
- `src/adapters/`: AI, raw-file storage và transaction-store ports/adapters.
- `frontend/`: SPA tĩnh do API có thể serve.
- `k8s/`, `argocd/`, `rbac/`, `gatekeeper/`, `eso/`, `policies/`, `tenants/`: desired state.
- `terraform/`: one-click disposable AWS lab stack.

## Commands

```powershell
.\.venv\Scripts\python -m pytest -q
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform validate
```

Defaults chạy hoàn toàn local: rule AI + filesystem + SQLite. Production backends được chọn bằng env; không đổi interface handler khi thêm adapter.
