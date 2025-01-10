FROM python:3.10-slim-bullseye

# Dodajemy narzędzia kompilacyjne (gcc), żeby można było zbudować "backports.zoneinfo" czy inne paczki wymagające C
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
