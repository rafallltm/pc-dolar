#!/bin/bash

# Nome da imagem
IMAGE_NAME="c-dolar"

# Cria o Dockerfile
cat <<EOF > Dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "dolar.py"]
EOF

echo "[✔] Dockerfile criado!"

# Verifica se já existe .env ou pede a chave da API
if [ ! -f .env ]; then
  echo -n "Digite sua chave da API ExchangeRate: "
  read CHAVE_API
  echo "EXCHANGE_TAXA_API_KEY=$CHAVE_API" > .env
  echo "[✔] .env criado com a chave da API!"
else
  echo "[!] .env já existe, usando chave existente."
fi

# Build da imagem
docker build -t $IMAGE_NAME .

# Roda o container em modo interativo
docker run -it --env-file .env $IMAGE_NAME
