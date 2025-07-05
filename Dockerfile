# Dockerfile - VERSIÓN DE PRUEBA UNIVERSAL (PARA PRUEBA TONTA Y PRUEBA BÁSICA)
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget psmisc git-lfs && rm -rf /var/lib/apt/lists/*

# Fijar la versión de numpy
RUN echo "numpy==1.26.4" > /tmp/numpy_req.txt && \
    pip install --no-cache-dir -r /tmp/numpy_req.txt

WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# Instalar requisitos internos de ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# --- PASO DE PRUEBA: AÑADIR MODELO ESTÁNDAR PARA LA PRUEBA 2 ---
RUN mkdir -p /ComfyUI/models/checkpoints && \
    wget -O /ComfyUI/models/checkpoints/v1-5-pruned-emaonly.safetensors https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors
# ----------------------------------------------------------------

# Dependencias personalizadas
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Instalar Custom Nodes (Impact Pack es necesario para la imagen en blanco)
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
RUN pip install -r requirements.txt

# Copiar scripts
WORKDIR /
COPY handler.py /handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]