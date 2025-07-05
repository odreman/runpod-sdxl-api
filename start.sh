#!/bin/bash
# start.sh - VERSIÓN FINAL CON ESPERA ADICIONAL

cd /ComfyUI
echo ">>> Iniciando ComfyUI en segundo plano..."
python main.py --listen 127.0.0.1 --port 8188 &

echo ">>> Esperando a que el puerto de ComfyUI (8188) esté abierto..."
while ! curl -s --head http://127.0.0.1:8188/system_stats | head -n 1 | grep "200 OK" > /dev/null; do
    echo "    Esperando..."
    sleep 1
done

echo ">>> ✅ Puerto de ComfyUI está abierto."
echo ">>> Dando 15 segundos adicionales para que ComfyUI termine de cargar todos los modelos..."
sleep 15

echo ">>> ✅ ComfyUI debería estar completamente listo. Iniciando el handler de RunPod..."
cd /
python -u /handler.py