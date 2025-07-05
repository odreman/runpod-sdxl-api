#!/bin/bash
# start.sh - VERSIÓN FINAL FUNCIONAL

# 1. Navegar al directorio de ComfyUI
cd /ComfyUI

# 2. Iniciar ComfyUI en segundo plano
echo ">>> Iniciando ComfyUI en segundo plano..."
python main.py --listen 127.0.0.1 --port 8188 &

# 3. Esperar a que ComfyUI esté listo y responda
echo ">>> Esperando a que ComfyUI esté disponible en el puerto 8188..."
while ! curl -s --head http://127.0.0.1:8188/system_stats | head -n 1 | grep "200 OK" > /dev/null; do
    echo "    Esperando..."
    sleep 1
done

echo ">>> ✅ ComfyUI está listo!"

# 4. Iniciar el handler de RunPod para procesar los trabajos
echo ">>> Iniciando el handler de RunPod..."
cd /
python -u /handler.py