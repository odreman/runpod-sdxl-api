#!/bin/bash
# start.sh - VERSIÓN DE DEPURACIÓN

echo ">>> [DEBUG] Iniciando start.sh..."

# 1. Cambiar al directorio de ComfyUI
cd /ComfyUI

# 2. Iniciar ComfyUI en segundo plano Y guardar su log de inicio
echo ">>> [DEBUG] Intentando iniciar ComfyUI en segundo plano..."
python main.py --listen 127.0.0.1 --port 8188 > /tmp/comfyui_startup.log 2>&1 &
COMFYUI_PID=$!
echo ">>> [DEBUG] ComfyUI lanzado con PID: $COMFYUI_PID"

# 3. Esperar un poco para que ComfyUI intente arrancar y posiblemente falle.
echo ">>> [DEBUG] Esperando 45 segundos para que ComfyUI se estabilice o falle..."
sleep 45

echo ">>> [DEBUG] Revisando el estado de ComfyUI..."

# Comprobar si el proceso de ComfyUI sigue corriendo
if ps -p $COMFYUI_PID > /dev/null; then
    echo ">>> [DEBUG] El proceso de ComfyUI (PID: $COMFYUI_PID) sigue corriendo."
    # Ahora verificamos si el puerto está escuchando
    if curl -s --head http://127.0.0.1:8188/system_stats | head -n 1 | grep "200 OK" > /dev/null; then
        echo ">>> ✅ ComfyUI está listo y respondiendo!"
        
        echo "--- Log de inicio de ComfyUI (últimas 15 líneas) ---"
        tail -n 15 /tmp/comfyui_startup.log
        echo "------------------------------------------------"
        
        echo ">>> Iniciando el handler de RunPod..."
        cd /
        python -u /handler.py
        
    else
        echo ">>> ❌ ERROR: El proceso de ComfyUI está corriendo, pero no responde en el puerto 8188."
        echo ">>> [DEBUG] Esto podría significar que se colgó durante el inicio."
        echo "--- Contenido completo del log de inicio de ComfyUI ---"
        cat /tmp/comfyui_startup.log
        echo "-----------------------------------------------------"
        sleep 300 
    fi
else
    echo ">>> ❌ ERROR FATAL: ¡El proceso de ComfyUI ha terminado inesperadamente!"
    echo ">>> [DEBUG] Esto casi siempre se debe a un error durante la carga de nodos o modelos."
    echo "--- Contenido completo del log de inicio de ComfyUI ---"
    cat /tmp/comfyui_startup.log
    echo "-----------------------------------------------------"
    sleep 300
fi