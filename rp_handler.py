import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Solo verificar que el modelo existe, NO cargarlo
    model_path = "/runpod-volume/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
    model_exists = os.path.exists(model_path)
    
    # Verificar componentes del modelo
    model_components = []
    if model_exists:
        model_components = os.listdir(model_path)
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "model_path": model_path,
        "model_exists": model_exists,
        "model_components": model_components,
        "message": "Model found but not loaded yet!"
    }
    
    print(f"Returning result: {result}")
    return result

runpod.serverless.start({"handler": handler})