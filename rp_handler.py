import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Ruta correcta basada en tu estructura
    model_path = "/workspace/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
    model_exists = os.path.exists(model_path)
    
    # Verificar contenido
    workspace_contents = os.listdir("/workspace") if os.path.exists("/workspace") else []
    
    models_contents = []
    if os.path.exists("/workspace/models"):
        models_contents = os.listdir("/workspace/models")
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "workspace_contents": workspace_contents,
        "models_contents": models_contents,
        "model_path_exists": model_exists,
        "model_path": model_path,
        "message": "Found the correct model path!"
    }
    
    return result

runpod.serverless.start({"handler": handler})