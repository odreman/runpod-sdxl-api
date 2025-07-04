import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Test torch import
    try:
        import torch
        torch_available = True
        cuda_available = torch.cuda.is_available()
        torch_version = torch.__version__
    except ImportError as e:
        torch_available = False
        cuda_available = False
        torch_version = f"Import error: {str(e)}"
    
    # Verificar modelo
    model_path = "/runpod-volume/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
    model_exists = os.path.exists(model_path)
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "model_exists": model_exists,
        "torch_available": torch_available,
        "cuda_available": cuda_available,
        "torch_version": torch_version,
        "message": "Testing torch import!"
    }
    
    return result

runpod.serverless.start({"handler": handler})