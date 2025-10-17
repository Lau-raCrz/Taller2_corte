# Taller2


---

##  Ejecución del despliegue de drones


En este punto se busca ejecutar una simulación de varios drones utilizando el simulador físico PyBullet, dentro de un entorno aislado creado con Docker. La práctica se basa en el repositorio gym-pybullet-drones, que permite modelar y visualizar el vuelo coordinado de múltiples drones en un entorno 3D.

## Objetivo:
Desarrollar y ejecutar un contenedor Docker que despliegue la simulación de drones con PyBullet, asegurando que los modelos puedan volar, interactuar con el entorno y visualizarse correctamente en una interfaz gráfica.


### Dockerfile base
```

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
```



### Construcción de la imagen

```
sudo docker build -t drones_pybullet .
```

Antes de ejecutar cualquier contenedor con GUI, se debe habilitar el acceso gráfico:

```
xhost +local:root
```

### Ejecutar el contenedor

```
sudo docker run --rm -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    drones_pybullet
```


##  Ejecución del despliegue de Baxter

Este punto se enfoca en la simulación del robot colaborativo Baxter mediante la biblioteca PyBullet, que permite modelar sus articulaciones, movimientos y cinemática inversa. La práctica se implementa también dentro de un contenedor Docker para garantizar la portabilidad y el control del entorno de ejecución.

## Objetivo:
Simular el robot Baxter usando PyBullet y desplegarlo en un contenedor Docker, comprendiendo su funcionamiento, estructura y la aplicación de técnicas de control mediante el script baxter_ik_demo.py.

### Dockerfile base

```
FROM python:3.9-slim

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


CMD ["python", "baxter_ik_demo.py"]

```


### Construcción de la imagen

```
docker build -t baxter-simulation .
```

Antes de ejecutar cualquier contenedor con GUI, se debe habilitar el acceso gráfico:

```
xhost +local:root
```

### Ejecutar el contenedor
```
docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/dri \
  baxter-simulation
```


## Simulación del robot ATLAS en Docker

En este apartado se busca simular el robot humanoide ATLAS, reconocido por sus capacidades de locomoción y manipulación avanzada. La simulación se realiza en PyBullet para observar sus movimientos y estabilidad, corriendo igualmente dentro de un entorno Dockerizado.

## Objetivo:
Implementar y ejecutar un contenedor Docker que permita la simulación del robot ATLAS en PyBullet, analizando su comportamiento dinámico y la interacción con el entorno virtual.
