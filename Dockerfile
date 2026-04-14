FROM python:3.9-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

CMD sh -c 'while ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -q -U "$DB_USER"; do sleep 1; done && python3 -c "from app import init_db; init_db()" && gunicorn --bind 0.0.0.0:5000 app:app'