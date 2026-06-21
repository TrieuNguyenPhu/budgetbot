# Secret rotation

1. Change `budgetbot/dev/database` in AWS Secrets Manager.
2. Within 30 seconds, verify the decoded `budgetbot-db` Secret value changes.
3. Verify the BudgetBot Pod UID/age is unchanged. Secret volumes update in place; environment variables would require a restart.
4. If sync fails, inspect ExternalSecret conditions and SecretStore authentication. Never paste credentials into Git or logs.
