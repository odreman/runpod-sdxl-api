import runpod
import torch
from diffusers import StableDiffusionXLPipeline
import base64
from io import BytesIO
from PIL import Image
import os

# Global variables to store the pipeline
pipe = None

def load_model():
    """Load the SDXL model from the network volume"""
    global pipe
    
    if pipe is None:
        print("Loading SDXL model...")
        
        # Path to your model in the network volume
        model_path = "/workspace/my-models-storage/models/fortnite-model"
        
        # Check if model exists
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found at {model_path}")
        
        # Load the pipeline
        pipe = StableDiffusionXLPipeline.from_pretrained(
            model_path,
            torch_dtype=torch.float16,
            use_safetensors=True,
            variant="fp16"
        ).to("cuda")
        
        # Enable memory efficient attention
        pipe.enable_memory_efficient_attention()
        
        print("Model loaded successfully!")
    
    return pipe

def image_to_base64(image):
    """Convert PIL image to base64 string"""
    buffered = BytesIO()
    image.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    return img_str

def handler(job):
    """
    RunPod handler function
    """
    try:
        # Get job input
        job_input = job["input"]
        
        # Extract parameters
        prompt = job_input.get("prompt", "a beautiful landscape")
        negative_prompt = job_input.get("negative_prompt", "blurry, bad quality")
        num_inference_steps = job_input.get("num_inference_steps", 25)
        guidance_scale = job_input.get("guidance_scale", 7.5)
        width = job_input.get("width", 1024)
        height = job_input.get("height", 1024)
        seed = job_input.get("seed", None)
        
        print(f"Generating image with prompt: {prompt}")
        
        # Load model
        pipeline = load_model()
        
        # Set seed if provided
        if seed is not None:
            torch.manual_seed(seed)
        
        # Generate image
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
        
        # Get the generated image
        image = result.images[0]
        
        # Convert to base64
        image_base64 = image_to_base64(image)
        
        return {
            "image": image_base64,
            "prompt": prompt,
            "seed": seed,
            "status": "success"
        }
        
    except Exception as e:
        print(f"Error in handler: {str(e)}")
        return {
            "error": str(e),
            "status": "error"
        }

if __name__ == "__main__":
    print("Starting RunPod serverless handler...")
    runpod.serverless.start({"handler": handler})