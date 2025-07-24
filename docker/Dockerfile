FROM python:3.11-slim

# Instala dependências do sistema (útil para httpx e outros pacotes nativos)
RUN apt-get update && apt-get install -y build-essential

# Define diretório de trabalho
WORKDIR /app

# Copia e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código
COPY . .

# Expõe a porta (opcional, mas ajuda na documentação da imagem)
EXPOSE 80

# Comando para iniciar o servidor FastAPI com Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]