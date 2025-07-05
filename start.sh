#!/bin/bash
# start.sh - VERSIÓN DE AUDITORÍA MÁXIMA

echo "=============================================="
echo "INICIANDO SCRIPT DE AUDITORÍA DEL SISTEMA"
date
echo "=============================================="

echo -e "\n[AUDIT] 1. Verificando el contenido de /ComfyUI..."
ls -la /ComfyUI/
# ESPERAMOS VER 'extra_model_paths.yaml' EN ESTA LISTA

echo -e "\n[AUDIT] 2. Verificando el contenido de 'extra_model_paths.yaml'..."
# SI EL ARCHIVO NO EXISTE, ESTE COMANDO FALLARÁ, LO CUAL ES BUENA INFORMACIÓN
cat /ComfyUI/extra_model_paths.yaml || echo "ERROR: No se pudo encontrar /ComfyUI/extra_model_paths.yaml"

echo -e "\n[AUDIT] 3. Verificando el contenido del volumen en /workspace..."
ls -la /workspace/
# ESPERAMOS VER LA CARPETA 'ComfyUI' AQUÍ

echo -e "\n[AUDIT] 4. Verificando el contenido de /workspace/ComfyUI/models/diffusers..."
ls -la /workspace/ComfyUI/models/diffusers/
# ESPERAMOS VER LA CARPETA DE NUESTRO MODELO 'v1x0_fortnite_...' EN ESTA LISTA

echo -e "\n[AUDIT] 5. Auditoría completada. Procediendo a iniciar ComfyUI en primer plano."
echo "----------------------------------------------------------------"
echo "TODA LA SALIDA A CONTINUACIÓN ES DIRECTAMENTE DE ComfyUI (main.py):"
echo "----------------------------------------------------------------\n"

cd /ComfyUI
# Ejecutamos ComfyUI en PRIMER PLANO para capturar todos sus logs sin interferencia.
python -u main.py --listen 127.0.0.1 --port 8188

echo "\n----------------------------------------------------------------"
echo "FIN DE LA EJECUCIÓN DE COMFYUI"
echo "Si ves este mensaje, ComfyUI terminó sin quedarse en modo escucha."
date
echo "=============================================="