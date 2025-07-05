#!/bin/bash
# start.sh - MODO DIAGNÓSTICO: NO INICIARÁ COMFYUI

echo "============================================================"
echo "INICIANDO SCRIPT DE DIAGNÓSTICO. WORKER NO SERÁ FUNCIONAL."
echo "EL OBJETIVO ES MAPEAR LA ESTRUCTURA DE ARCHIVOS."
date
echo "============================================================"

echo -e "\n\n--- 1. CONTENIDO DE / (RAÍZ) ---"
ls -la /

echo -e "\n\n--- 2. CONTENIDO DE /ComfyUI ---"
ls -la /ComfyUI/
echo "(Deberíamos ver extra_model_paths.yaml aquí)"

echo -e "\n\n--- 3. VERIFICANDO extra_model_paths.yaml ---"
echo "Contenido del archivo de configuración:"
cat /ComfyUI/extra_model_paths.yaml || echo "ERROR: /ComfyUI/extra_model_paths.yaml NO ENCONTRADO."

echo -e "\n\n--- 4. MAPA COMPLETO DEL VOLUMEN /workspace ---"
echo "Listado recursivo de /workspace/. Esto puede tardar un momento."
ls -laR /workspace/
echo "(Deberíamos ver la ruta completa a nuestro modelo aquí)"

echo -e "\n\n--- 5. MAPA COMPLETO DE /ComfyUI/models (LOCAL) ---"
ls -laR /ComfyUI/models/

echo -e "\n\n============================================================"
echo "DIAGNÓSTICO COMPLETADO. EL WORKER PERMANECERÁ VIVO."
echo "Ahora puedes revisar los logs en la interfaz de RunPod."
echo "Este worker se detendrá por el timeout de inactividad."
echo "============================================================"

# Este comando mantiene el contenedor vivo para que podamos leer los logs
# sin que entre en un bucle de reinicio.
sleep infinity