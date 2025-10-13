# Imagen base con Python
FROM python:3.10-slim

# Instalar dependencias del sistema necesarias para PyBullet y renderizado
RUN apt-get update && apt-get install -y \
    xvfb \
    libgl1 \
    libgl1-mesa-dev \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Crear carpeta de trabajo
WORKDIR /app

# Copiar el proyecto al contenedor
COPY . /app

# Instalar dependencias de Python (usando pyproject.toml)
RUN pip install --upgrade pip setuptools wheel
RUN pip install -e .

# Comando por defecto (puedes cambiarlo luego)
CMD ["python3", "gym_pybullet_drones/examples/pid.py"]
