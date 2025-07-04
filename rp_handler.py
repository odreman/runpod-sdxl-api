import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    try:
        # Paso 1: Verificar torch
        print("Step 1: Testing torch import...")
        import torch
        print(f"✅ Torch imported: {torch.__version__}")
        print(f"✅ CUDA available: {torch.cuda.is_available()}")
        
        # Paso 2: Verificar diffusers
        print("Step 2: Testing diffusers import...")
        from diffusers import StableDiffusionXLPipeline
        print("✅ Diffusers imported successfully")
        
        # Paso 3: Verificar modelo existe
        print("Step 3: Checking model path...")
        model_path = "/runpod-volume/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
        model_exists = os.path.exists(model_path)
        print(f"✅ Model exists: {model_exists}")
        
        if model_exists:
            # Paso 4: Verificar contenido del modelo
            print("Step 4: Checking model contents...")
            model_contents = os.listdir(model_path)
            print(f"✅ Model contents: {model_contents}")
            
            # Paso 5: Intentar cargar (SIN mover a GPU)
            print("Step 5: Testing model loading (CPU only)...")
            pipe = StableDiffusionXLPipeline.from_pretrained(
                model_path,
                torch_dtype=torch.float16,
                use_safetensors=True
            )
            print("✅ Model loaded to CPU successfully!")
            
            # Paso 6: Intentar mover a GPU
            print("Step 6: Moving model to GPU...")
            pipe = pipe.to("cuda")
            print("✅ Model moved to GPU successfully!")
            
            return {
                "status": "success",
                "prompt": prompt,
                "message": "All steps completed successfully!",
                "model_loaded": True
            }
        else:
            return {
                "status": "error",
                "prompt": prompt,
                "message": "Model path not found",
                "model_loaded": False
            }
            
    except Exception as e:
        print(f"❌ Error at step: {str(e)}")
        return {
            "status": "error",
            "prompt": prompt,
            "error": str(e),
            "message": f"Failed during model loading: {str(e)}"
        }

runpod.serverless.start({"handler": handler})