import runpod
import os

def handler(job):
    """
    Handler function following RunPod official format
    """
    
    print(f"Worker Start")
    
    # Extract input data (RunPod official format)
    job_input = job["input"]
    
    prompt = job_input.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Check if model volume is mounted
    model_path = "/workspace/my-models-storage/models/fortnite-model"
    model_exists = os.path.exists(model_path)
    
    # List workspace contents
    workspace_contents = []
    if os.path.exists("/workspace"):
        workspace_contents = os.listdir("/workspace")
    
    # Return result
    result = {
        "status": "success",
        "prompt_received": prompt,
        "model_path_exists": model_exists,
        "workspace_contents": workspace_contents,
        "message": "RunPod official handler working!"
    }
    
    print(f"Returning result: {result}")
    
    return result

# Start the Serverless function (RunPod official format)
runpod.serverless.start({"handler": handler})