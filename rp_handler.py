import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    # Verificar el volumen en su ubicación real
    runpod_volume_exists = os.path.exists("/runpod-volume")
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "runpod_volume_exists": runpod_volume_exists
    }
    
    if runpod_volume_exists:
        try:
            volume_contents = os.listdir("/runpod-volume")
            result["volume_contents"] = volume_contents
            
            # Verificar si hay la carpeta models
            models_path = "/runpod-volume/models"
            if os.path.exists(models_path):
                models_contents = os.listdir(models_path)
                result["models_exists"] = True
                result["models_contents"] = models_contents
                
                # Verificar el modelo específico
                fortnite_path = "/runpod-volume/models/fortnite-model"
                result["fortnite_model_exists"] = os.path.exists(fortnite_path)
            else:
                result["models_exists"] = False
                
        except Exception as e:
            result["volume_error"] = str(e)
    
    return result

runpod.serverless.start({"handler": handler})