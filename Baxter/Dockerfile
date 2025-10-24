FROM python:3.9-slim

# Instalar dependencias para GUI y OpenGL
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgomp1 \
    libglu1-mesa \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY baxter_ik_demo.py .
COPY data/ ./data/

# No necesitamos CMD porque lo especificaremos al ejecutar
CMD ["python", "baxter_ik_demo.py"]
