FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    STORAGE_LOCAL_DIR=/data/uploads \
    USERSTORE_SQLITE_PATH=/data/transactions.db

RUN groupadd --system --gid 10001 budgetbot \
    && useradd --system --uid 10001 --gid budgetbot --home /app budgetbot
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY src ./src
COPY frontend ./frontend
RUN mkdir -p /data && chown -R budgetbot:budgetbot /app /data
USER 10001:10001
EXPOSE 8000
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
