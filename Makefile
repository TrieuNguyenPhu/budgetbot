.PHONY: install run test clean

PYTHON ?= python
VENV ?= .venv

ifeq ($(OS),Windows_NT)
VENV_PY := $(VENV)/Scripts/python.exe
else
VENV_PY := $(VENV)/bin/python
endif

install:
	$(PYTHON) -m venv $(VENV)
	$(VENV_PY) -m pip install --upgrade pip
	$(VENV_PY) -m pip install -r requirements.txt

run:
	$(VENV_PY) -m uvicorn src.app:app --reload --host 0.0.0.0 --port 8000

test:
	$(VENV_PY) -m pytest -v tests/

clean:
	rm -rf _data __pycache__ .pytest_cache src/__pycache__ src/adapters/__pycache__ tests/__pycache__
