# Architecture

```text
Browser/API client → FastAPI → upload/summary handlers
                         ├→ AI adapter (local rules | Bedrock)
                         ├→ file adapter (local | S3)
                         └→ transaction adapter (SQLite | SQL | DynamoDB | DocumentDB)

Git → Argo CD root → platform apps → BudgetBot Rollout
                                   ├→ Prometheus/SLO/analysis
                                   ├→ Gatekeeper + signature admission
                                   └→ ESO → Kubernetes Secret volume
```

Runtime is stateless except selected adapters. User isolation is enforced by every store query. Kubernetes uses Service discovery, probes, resource bounds, HPA and progressive delivery. Git is desired state; rollback is `git revert`, not live-cluster mutation.

AWS lab path: Internet → ALB → EC2 NodePort → minikube Service → BudgetBot Pods. Terraform wires AWS infrastructure to SSH-based Kubernetes deployment and is designed to be destroyed after verification.
