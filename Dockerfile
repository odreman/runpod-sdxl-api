# Dockerfile - VERSIÓN SERVERLESS SEGURA
# Usamos la imagen base oficial de RunPod que coincide con tu entorno.
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

# Variables de entorno para una instalación sin interrupciones.
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema (git, wget, psmisc para 'killall').
RUN apt-get update && apt-get install -y git wget psmisc && rm -rf /var/lib/apt/lists/*

# Crear el directorio de trabajo y clonar ComfyUI.
WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# --- GESTIÓN DE MODELOS (ENFOQUE DE VOLUMEN DE RED) ---
# Aquí está la magia: enlazamos los directorios de ComfyUI al volumen de red (/workspace)
# para que tus modelos y custom nodes sean persistentes y no estén en la imagen.
# Esto hace que la imagen sea pequeña y los arranques muy rápidos.
RUN mkdir -p /workspace/ComfyUI/models && \
    rm -rf /ComfyUI/models && \
    ln -s /workspace/ComfyUI/models /ComfyUI/models

RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    rm -rf /ComfyUI/custom_nodes && \
    ln -s /workspace/ComfyUI/custom_nodes /ComfyUI/custom_nodes
# --------------------------------------------------------

# Copiar el archivo de requisitos.
COPY requirements.txt /requirements.txt

# Instalar las dependencias de Python.
RUN pip install --no-cache-dir -r /requirements.txt

# --- INSTALAR CUSTOM NODES (EN LA IMAGEN) ---
# Basado en tu Dockerfile anterior, instalaremos Impact Pack.
# Es buena idea tenerlo en la imagen si es fundamental para tus workflows.
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
# Algunos nodos pueden tener sus propios requisitos.
RUN pip install -r requirements.txt
# -----------------------------

# Volver al directorio raíz.
WORKDIR /

# Copiar el handler y el script de inicio.
COPY handler.py /handler.py
COPY start.sh /start.sh

# Dar permisos de ejecución al script.
RUN chmod +x /start.sh

# Comando final que RunPod ejecutará.
CMD ["/bin/bash", "/start.sh"]