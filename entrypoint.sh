#!/bin/sh
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_NAME" ]; then
  echo "Erro: Variáveis DB_HOST, DB_PORT, DB_NAME não configuradas."
  exit 1
fi
echo "Aguardando banco de dados em ${DB_HOST}:${DB_PORT}..."
while ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -q -U "$DB_USER"; do
  echo "Banco indisponível - aguardando..."
  sleep 1
done
echo "Banco disponível!"
echo "Inicializando banco de dados..."
python3 -c "from app import init_db; init_db()"
echo "Iniciando Gunicorn..."
exec gunicorn --bind 0.0.0.0:5000 app:app