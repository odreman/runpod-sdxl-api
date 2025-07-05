#!/bin/bash
# start.sh - VERSIÓN DE PRODUCCIÓN
cd /ComfyUI
echo ">>> Iniciando ComfyUI en segundo plano..."
python main.py --listen 127.0.0.1 --port 8188 &
echo ">>> Esperando a que ComfyUI esté disponible..."
while ! curl -s --head http://127.0.0.1:8188/system_stats | head -n 1 | grep "200 OK" > /dev/null; do
    echo "    Esperando..."
    sleep 1
done
echo ">>> ✅ ComfyUI está listo!"
echo ">>> Iniciando el handler de RunPod..."
cd /
python -u /handler.py