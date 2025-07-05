# Dockerfile - VERSIÓN FINAL REFORZADA
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget psmisc && rm -rf /var/lib/apt/lists/*

# 1. ACTUALIZAR PIP PRIMERO
RUN pip install --upgrade pip

# 2. CLONAR COMFYUI
WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# 3. INSTALAR LOS REQUISITOS INTERNOS DE COMFYUI (¡EL PASO CLAVE!)
#    Esto instalará el 'comfyui-frontend-package' y otras dependencias base.
RUN pip install --no-cache-dir -r requirements.txt

# 4. INSTALAR NUESTRAS DEPENDENCIAS ADICIONALES
#    Copiamos nuestro requirements.txt y lo instalamos.
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# 5. CONFIGURAR ENLACES SIMBÓLICOS PARA ALMACENAMIENTO
RUN mkdir -p /workspace/ComfyUI/models && \
    rm -rf /ComfyUI/models && \
    ln -s /workspace/ComfyUI/models /ComfyUI/models

RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    rm -rf /ComfyUI/custom_nodes && \
    ln -s /workspace/ComfyUI/custom_nodes /ComfyUI/custom_nodes

# 6. INSTALAR CUSTOM NODES (OPCIONAL, PERO LO MANTENEMOS)
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
RUN pip install -r requirements.txt

# 7. COPIAR SCRIPTS Y CONFIGURAR PERMISOS
WORKDIR /
COPY handler.py /handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 8. COMANDO DE INICIO
CMD ["/bin/bash", "/start.sh"]