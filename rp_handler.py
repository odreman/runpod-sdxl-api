import runpod
import torch
from diffusers import StableDiffusionXLPipeline, DPMSolverMultistepScheduler
import base64
from io import BytesIO
from PIL import Image
import os

# Global variables
pipe = None

def load_model():
    """Load the Fortnite SDXL model"""
    global pipe
    
    if pipe is None:
        print("Loading Fortnite SDXL model...")
        
        # Ruta correcta del modelo
        model_path = "/runpod-volume/models/v1x0_fortnite_humanoid_sdxl1_vae_fix-000005"
        
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found at {model_path}")
        
        # Cargar el pipeline
        pipe = StableDiffusionXLPipeline.from_pretrained(
            model_path,
            torch_dtype=torch.float16,
            use_safetensors=True
        ).to("cuda")
        
        # Configurar scheduler como en ComfyUI (dpmpp_sde_gpu)
        pipe.scheduler = DPMSolverMultistepScheduler.from_config(
            pipe.scheduler.config,
            algorithm_type="sde-dpmsolver++",
            use_karras_sigmas=True
        )
        
        print("Fortnite model loaded successfully!")
    
    return pipe

def image_to_base64(image):
    """Convert PIL image to base64"""
    buffered = BytesIO()
    image.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    return img_str

def handler(job):
    """
    RunPod handler - Fortnite style image generation
    """
    try:
        print("Starting Fortnite image generation...")
        
        job_input = job["input"]
        
        # Parámetros de tu ComfyUI
        prompt = job_input.get("prompt", "jonesy, fortnite style, vibrant colors, cartoon shading, cel shading, bright lighting, colorful, game art style")
        negative_prompt = job_input.get("negative_prompt", "realistic, photorealistic, real life, photography, photo, hyperrealistic, detailed skin texture, skin pores, wrinkles, scars, moles, realistic lighting, harsh shadows, dark colors, muted colors, desaturated, black and white, grayscale, blurry, low quality, jpeg artifacts, watermark, signature, text, ugly, deformed, mutated, extra limbs, missing limbs, floating limbs, disconnected limbs, malformed hands, poorly drawn hands, mutated hands, extra fingers, fewer fingers, extra arms, extra legs, malformed face, cross-eyed, malformed lips, mutation, deformed eyes, heterochromia, bad anatomy, bad proportions, gross proportions")
        
        # Parámetros exactos de tu ComfyUI
        num_inference_steps = job_input.get("steps", 20)
        guidance_scale = job_input.get("cfg", 5.0)
        width = job_input.get("width", 1024)
        height = job_input.get("height", 1024)
        seed = job_input.get("seed", 732219914095253)
        
        print(f"Generating: {prompt[:50]}...")
        print(f"Steps: {num_inference_steps}, CFG: {guidance_scale}, Seed: {seed}")
        
        # Cargar modelo
        pipeline = load_model()
        
        # Configurar seed
        torch.manual_seed(seed)
        
        # Generar imagen (exactamente como tu ComfyUI)
        with torch.autocast("cuda"):
            result = pipeline(
                prompt=prompt,
                negative_prompt=negative_prompt,
                num_inference_steps=num_inference_steps,
                guidance_scale=guidance_scale,
                width=width,
                height=height,
                num_images_per_prompt=1
            )
        
        image = result.images[0]
        image_base64 = image_to_base64(image)
        
        return {
            "image": image_base64,
            "prompt": prompt,
            "seed": seed,
            "steps": num_inference_steps,
            "cfg": guidance_scale,
            "status": "success",
            "message": "Fortnite style image generated!"
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "error": str(e),
            "status": "error"
        }

runpod.serverless.start({"handler": handler})