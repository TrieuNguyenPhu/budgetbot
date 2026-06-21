# Business rules

- CSV columns are `date, description, amount`; a header is optional. Invalid/short rows are skipped.
- Amount parses after comma removal. Positive values normally represent income; negative values represent expense.
- Categories are fixed: Food, Transport, Shopping, Utilities, Entertainment, Health, Subscriptions, Income, Transfer, Other.
- Local categorization is ordered keyword matching; first match wins. Positive unmatched amounts fall back to Income, otherwise Other.
- LLM output is accepted only when it is valid JSON with an allowed category; invalid output becomes Other/low confidence.
- Raw upload is stored before rows are categorized. Each accepted row is persisted once per upload; uploads are not deduplicated.
- All transaction reads and aggregates are scoped by user. Month filter uses `YYYY-MM` prefix/format.
- Summary total is the signed sum. Top drivers are sorted by absolute category total and limited to three.
