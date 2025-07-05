# Dockerfile - VERSIÓN FINAL Y ROBUSTA
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git wget psmisc && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /ComfyUI

# Instalar los requisitos internos de ComfyUI (incluye el frontend)
RUN pip install --no-cache-dir -r requirements.txt

# --- PASO CLAVE: USAR CONFIGURACIÓN EXTERNA DE MODELOS ---
# Copiamos nuestro archivo de configuración. Esto es más robusto que los enlaces simbólicos.
COPY extra_model_paths.yaml .
# --------------------------------------------------------

# Instalar nuestras dependencias personalizadas
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Instalar Custom Nodes
WORKDIR /ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
WORKDIR ComfyUI-Impact-Pack
RUN pip install -r requirements.txt

# Copiar scripts y configurar permisos
WORKDIR /
COPY handler.py /handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]