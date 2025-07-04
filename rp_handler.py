import runpod
import os

def handler(job):
    print(f"Worker Start - Testing Vast.ai versions")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    try:
        # Test all imports with exact versions
        import torch
        print(f"✅ Torch: {torch.__version__}")
        
        from diffusers import StableDiffusionXLPipeline
        import diffusers
        print(f"✅ Diffusers: {diffusers.__version__}")
        
        import transformers
        print(f"✅ Transformers: {transformers.__version__}")
        
        # Test model loading
        model_path = "/runpod-volume/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
        print(f"✅ Model path exists: {os.path.exists(model_path)}")
        
        return {
            "status": "success",
            "message": "All Vast.ai versions imported successfully!",
            "versions": {
                "torch": torch.__version__,
                "diffusers": diffusers.__version__,
                "transformers": transformers.__version__
            }
        }
        
    except Exception as e:
        return {
            "status": "error", 
            "error": str(e)
        }

runpod.serverless.start({"handler": handler})