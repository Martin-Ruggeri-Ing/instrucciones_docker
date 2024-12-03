#!/bin/bash

# Confirmación de limpieza completa
read -p "¿Estás seguro de que deseas eliminar TODOS los recursos de Docker (contenedores, imágenes, volúmenes, redes)? Esto no se puede deshacer. (sí/no): " confirm

if [[ "$confirm" != "si" ]]; then
  echo "Operación cancelada."
  exit 0
fi

# Detener todos los contenedores
echo "Deteniendo todos los contenedores..."
docker stop $(docker ps -q) 2>/dev/null

# Eliminar todos los contenedores
echo "Eliminando todos los contenedores..."
docker rm $(docker ps -aq) 2>/dev/null

# Eliminar todas las imágenes
echo "Eliminando todas las imágenes..."
docker rmi $(docker images -q) -f 2>/dev/null

# Eliminar todos los volúmenes
echo "Eliminando todos los volúmenes..."
docker volume rm $(docker volume ls -q) 2>/dev/null

# Limpiar volúmenes huérfanos
echo "Limpiando volúmenes huérfanos..."
docker volume prune -f 2>/dev/null

# Eliminar todas las redes excepto las predeterminadas
echo "Eliminando todas las redes personalizadas..."
docker network rm $(docker network ls -q | grep -v "bridge\|host\|none") 2>/dev/null

# Limpiar redes huérfanas
echo "Limpiando redes huérfanas..."
docker network prune -f 2>/dev/null

# Realizar una limpieza completa
echo "Ejecutando limpieza final..."
docker system prune -a --volumes -f

echo "Limpieza completa de Docker realizada con éxito."
