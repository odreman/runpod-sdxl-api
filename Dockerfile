# Dockerfile - VERSIÓN FINAL CORREGIDA PARA LA ESTRUCTURA DE HF
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget psmisc git-lfs && rm -rf /var/lib/apt/lists/*

# Fijar la versión de numpy para evitar conflictos
RUN echo "numpy==1.26.4" > /tmp/numpy_req.txt && \
    pip install --no-cache-dir -r /tmp/numpy_req.txt

WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# Instalar requisitos internos de ComfyUI (incluye el frontend)
RUN pip install --no-cache-dir -r requirements.txt

# --- PASO CLAVE: CLONAR Y MOVER EL MODELO CORRECTAMENTE ---
# 1. Creamos la carpeta de destino final.
# 2. Clonamos el repo de HF en una carpeta temporal.
# 3. Movemos la subcarpeta del modelo desde la temporal al destino final.
# 4. Limpiamos la carpeta temporal.
RUN mkdir -p /ComfyUI/models/diffusers/ && \
    git lfs install && \
    git clone https://huggingface.co/Odreman/SkinGen_Fortnite_SDXL /tmp/skin-gen-model && \
    mv /tmp/skin-gen-model/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005 /ComfyUI/models/diffusers/ && \
    rm -rf /tmp/skin-gen-model
# -------------------------------------------------------------

# El resto de nuestras dependencias personalizadas
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Instalar Custom Nodes (ej. Impact Pack)
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
RUN pip install -r requirements.txt

# Copiar nuestros scripts
WORKDIR /
COPY handler.py /handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]