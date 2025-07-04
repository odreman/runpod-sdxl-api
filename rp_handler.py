import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Paso 1: Verificar workspace existe
    workspace_exists = os.path.exists("/workspace")
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "step": "1_workspace_check",
        "workspace_exists": workspace_exists
    }
    
    # Solo si workspace existe, continuar
    if workspace_exists:
        try:
            workspace_contents = os.listdir("/workspace")
            result["workspace_contents"] = workspace_contents
            result["workspace_count"] = len(workspace_contents)
        except Exception as e:
            result["workspace_error"] = str(e)
    else:
        result["message"] = "ERROR: /workspace does not exist!"
        return result
    
    # Paso 2: Si hay carpeta models, verificar
    if "models" in workspace_contents:
        try:
            models_contents = os.listdir("/workspace/models")
            result["models_exists"] = True
            result["models_contents"] = models_contents
        except Exception as e:
            result["models_error"] = str(e)
    else:
        result["models_exists"] = False
    
    # Paso 3: Verificar my-models-storage si existe
    if "my-models-storage" in workspace_contents:
        try:
            storage_contents = os.listdir("/workspace/my-models-storage")
            result["storage_exists"] = True
            result["storage_contents"] = storage_contents
        except Exception as e:
            result["storage_error"] = str(e)
    else:
        result["storage_exists"] = False
    
    return result

runpod.serverless.start({"handler": handler})