# Usa una imagen base ligera con Python 3.10
FROM python:3.10-slim

# Instala dependencias del sistema necesarias para PyBullet, NumPy y renderizado
RUN apt-get update && apt-get install -y \
    python3-opengl \
    xvfb \
    ffmpeg \
    libgl1 \
    libglu1-mesa \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instala dependencias de Python
RUN pip install --no-cache-dir \
    numpy \
    pybullet \
    matplotlib

# Copia tu código al contenedor
WORKDIR /app
COPY . /app

# Comando por defecto al iniciar el contenedor
CMD ["python3", "atlas.py"]
