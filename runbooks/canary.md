# Canary failure

SLO: at least 99% successful HTTP responses over five minutes. The rollout samples the same ratio every 15 seconds; one failed sample aborts the canary.

1. Inspect `kubectl argo rollouts get rollout budgetbot -n demo` and the failed AnalysisRun.
2. Compare 5xx rate, latency, and logs for old/new ReplicaSets.
3. Fix forward through Git, or `git revert <bad-commit>` and push. Do not use `kubectl rollout undo`; Argo CD would restore Git state.
4. Verify Argo CD is Synced/Healthy and the stable revision serves traffic.

Alert delivery credentials are not committed. Configure the kube-prometheus-stack Alertmanager receiver from a Kubernetes Secret; test it by temporarily lowering the SLO threshold, then restore it through Git.
