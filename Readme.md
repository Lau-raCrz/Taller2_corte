# Taller2

---

##  Objetivo del laboratorio

El objetivo de este laboratorio fue implementar y ejecutar un robot TurtleBot3 con sensor LIDAR dentro de un contenedor Docker, utilizando ROS Noetic y el paquete gmapping para realizar SLAM (Simultaneous Localization and Mapping) en tiempo real.  
El sistema debía mostrar el entorno simulado en Gazebo, construir el mapa en RViz, y permitir el control manual del robot mediante teleoperación desde el teclado.

---

##  Ejecución del despliegue de drones

Para construir el entorno, se utilizó una imagen base con ROS Noetic, sobre la cual se instalaron los paquetes necesarios para TurtleBot3, simulaciones y SLAM.

### Dockerfile base


FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    xvfb \
    libgl1 \
    libgl1-mesa-dev \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN pip install --upgrade pip setuptools wheel
RUN pip install -e .

CMD ["python3", "gym_pybullet_drones/examples/pid.py"]




### Construcción de la imagen


sudo docker build -t drones_pybullet .


Antes de ejecutar cualquier contenedor con GUI, se debe habilitar el acceso gráfico:


xhost +local:root


### Ejecutar el contenedor


sudo docker run --rm -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    drones_pybullet



##  Ejecución del despliegue de Baxter

### Dockerfile base




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




### Construcción de la imagen


docker build -t baxter-simulation .


Antes de ejecutar cualquier contenedor con GUI, se debe habilitar el acceso gráfico:


xhost +local:root


### Ejecutar el contenedor

docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/dri \
  baxter-simulation