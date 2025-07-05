# Dockerfile - VERSIÓN CORREGIDA Y FINAL
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget psmisc && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# --- PASO CRÍTICO AÑADIDO ---
# Instalar los requisitos que vienen DENTRO del repo de ComfyUI,
# esto incluye el nuevo 'comfyui-frontend-package'.
RUN pip install --no-cache-dir -r requirements.txt
# -----------------------------

# --- GESTIÓN DE MODELOS (ENFOQUE DE VOLUMEN DE RED) ---
RUN mkdir -p /workspace/ComfyUI/models && \
    rm -rf /ComfyUI/models && \
    ln -s /workspace/ComfyUI/models /ComfyUI/models

RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    rm -rf /ComfyUI/custom_nodes && \
    ln -s /workspace/ComfyUI/custom_nodes /ComfyUI/custom_nodes
# --------------------------------------------------------

# Copiar NUESTRO archivo de requisitos para dependencias adicionales
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# --- INSTALAR CUSTOM NODES (EN LA IMAGEN) ---
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
RUN pip install -r requirements.txt
# -----------------------------

WORKDIR /
COPY handler.py /handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]