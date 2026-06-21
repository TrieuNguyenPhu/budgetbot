# AI notes

Start with `PROJECT_CONTEXT.md`, then inspect only the boundary being changed. Preserve adapter interfaces and user scoping. Add tests for business-rule changes.

Operational invariants:

- Git manifests are source of truth; do not patch a managed cluster as a durable fix.
- Never commit `.env`, AWS credentials, database passwords, Cosign private keys or Terraform state.
- Workloads must use pinned non-`latest` images, limits, non-root security and `owner` labels.
- Secrets that must rotate without Pod restart are mounted as volumes, not environment variables.
- Canary quality gate is the 99% HTTP success ratio; bad revisions must abort automatically.
- Tenant roles stay namespace-scoped; do not broaden them with ClusterRoleBinding. Network isolation needs an enforcing CNI.
- Any AWS deploy is disposable: verify URL/health, run `terraform destroy`, then confirm state and tagged cloud resources are empty.

Known external setup: publish/sign the production image, configure GitHub secrets and branch protection, create ESO credentials out-of-band, and configure Alertmanager email receiver from a Secret.
