# Simulación TurtleBot3 con LIDAR y SLAM (gmapping) en Docker

---

##  Objetivo del laboratorio

El objetivo de este laboratorio fue implementar y ejecutar un robot TurtleBot3 con sensor LIDAR dentro de un contenedor Docker, utilizando ROS Noetic y el paquete gmapping para realizar SLAM (Simultaneous Localization and Mapping) en tiempo real.  
El sistema debía mostrar el entorno simulado en Gazebo, construir el mapa en RViz, y permitir el control manual del robot mediante teleoperación desde el teclado.

---

##  Ejecución del sistema paso a paso

Para construir el entorno, se utilizó una imagen base con ROS Noetic, sobre la cual se instalaron los paquetes necesarios para TurtleBot3, simulaciones y SLAM.

### Dockerfile base

```Dockerfile
FROM osrf/ros:noetic-desktop-full

RUN apt-get update && apt-get install -y \
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-simulations \
    ros-noetic-slam-gmapping \
    libgl1-mesa-glx \
    libglu1-mesa \
    libxrender1 \
    libxext6 \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libqt5x11extras5

ENV TURTLEBOT3_MODEL=burger
```

### Construcción de la imagen

```
sudo docker build -t turtlebot3-slam .
```
Antes de ejecutar cualquier contenedor con GUI, se debe habilitar el acceso gráfico:

```
xhost +local:root
```


### Paso 1: Verificación del contenedor activo
En otra terminal se verificó el contenedor en ejecución:


```
docker ps -a
```

El resultado mostró el contenedor activo llamado slam-bot:

```
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS     NAMES
948c7eae2af1   turtlebot3-slam:latest   "/ros_entrypoint.sh …"   19 minutes ago   Up 19 minutes             slam-bot

```


### Paso 2: Iniciar el entorno gráfico (Gazebo y SLAM)

Luego se ejecutó el siguiente comando para correr un nuevo contenedor con soporte gráfico:


```
sudo docker run -it --rm \
  --network=host \
  -e DISPLAY=$DISPLAY \
  -e TURTLEBOT3_MODEL=burger \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  turtlebot3-slam
```

Dentro del contenedor  
```
root@lau-crz-HP-Pavilion-x360-2-in-1-Laptop-14-ek0xxx:/#
```
Se corrieron los siguientes pasos:

```
export LIBGL_ALWAYS_SOFTWARE=1
source /opt/ros/noetic/setup.bash
export TURTLEBOT3_MODEL=burger

```



### Paso 3: Lanzar la simulación en Gazebo

Lo siguiente que se hace es lanzar el entorno de simulación Gazebo con el mundo por defecto de TurtleBot3. Se redirige los logs al archivo /root/gazebo.log y espera 6 segundos para asegurar que el entorno esté completamente cargado antes de iniciar los siguientes nodos.

```
roslaunch turtlebot3_gazebo turtlebot3_world.launch >/root/gazebo.log 2>&1 & sleep 6

```
### Paso 4: Iniciar el proceso de SLAM (gmapping)


Con este comando se inicia el nodo de SLAM usando el método gmapping. Con esto abre automáticamente una ventana de RViz para visualizar el mapa generado en tiempo real mientras el robot se desplaza por el entorno.

```
roslaunch turtlebot3_slam turtlebot3_slam.launch slam_methods:=gmapping
```

---
### Paso 4: Teleoperación del robot

---

##  Teleoperación del robot

En una terminal se ejecutó el siguiente comando para correr el nodo de teleoperación del TurtleBot3 para mover el robot manualmente con el teclado:

```
sudo docker run -it --rm \
  --network=host \
  -e TURTLEBOT3_MODEL=burger \
  turtlebot3-slam bash -c \
  "source /opt/ros/noetic/setup.bash && \
  rosrun turtlebot3_teleop turtlebot3_teleop_key"

```


---

## Posibles Mejoras y Trayectorias del Robot con LiDAR y SLAM en Docker

### Trayectorias

Durante la simulación, se realizaron trayectos de prueba para validar el mapeo:

- Movimientos rectos hacia adelante y hacia atrás
- Trayectorias en curva (combinación de avance con rotación)
- Giros sobre el eje
- Exploración de una estructura hexagonal virtual
- Verificación de la actualización del mapa SLAM en tiempo real

Durante el desarrollo del laboratorio se pudo observar que el uso del contenedor Docker permitió un entorno de ejecución limpio, reproducible y libre de conflictos entre dependencias, lo cual resulta esencial cuando se trabaja con herramientas complejas como ROS (Robot Operating System) y Gazebo.
Sin embargo, existen varias posibles mejoras y optimizaciones tanto a nivel del sistema como del comportamiento del robot.

---

###  Posibles mejoras

#### Mejoras técnicas del sistema

- Persistencia de datos: actualmente, los mapas generados por SLAM se pierden al cerrar el contenedor. Se podría montar un volumen externo (-v) para guardar los mapas y reutilizarlos en futuras sesiones.

- Automatización de lanzamiento: usar un script o launch file que ejecute todos los procesos de forma secuencial (Gazebo, SLAM y teleoperación) reduciría la cantidad de comandos manuales y evitaría errores.

- Uso de imágenes livianas: crear una imagen personalizada de Docker con solo los paquetes necesarios para TurtleBot3, reduciendo tiempos de carga y uso de memoria.

- Integración con ROS2 o micro-ROS: migrar hacia ROS2 permitiría un middleware más eficiente basado en DDS y mejor manejo de nodos distribuidos.

#### Mejoras del comportamiento del robot

- Optimización de trayectorias: el algoritmo de gmapping puede complementarse con planeadores de trayectoria más eficientes, como Dijkstra, A* o NavFn, para mejorar el movimiento del TurtleBot dentro del entorno.

- Fusión sensorial: además del LiDAR, se podrían integrar sensores IMU y cámaras RGB-D para obtener una localización más precisa y robusta frente a entornos dinámicos.

- Control adaptativo: aplicar estrategias de control que ajusten la velocidad o dirección del robot según la densidad de obstáculos o calidad del mapeo en tiempo real.

- Simulación avanzada: modificar el entorno de Gazebo agregando obstáculos o zonas dinámicas para probar la robustez del algoritmo SLAM bajo condiciones más realistas.





### Reflexión final

El uso conjunto de ROS, Gazebo, LiDAR y Docker demuestra el potencial de las herramientas de simulación moderna en robótica. Docker simplifica el despliegue, ROS facilita la comunicación entre nodos, y el LiDAR junto con SLAM permiten que el robot desarrolle la capacidad de percibir, mapear y entender su entorno.
Estas tecnologías, al integrarse correctamente, abren la puerta a sistemas más inteligentes, modulares y escalables, tanto en simulación como en robots físicos reales.
