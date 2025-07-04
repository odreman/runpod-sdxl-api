import runpod
import os

def handler(event):
    """
    Handler function following RunPod official format
    
    Args:
        event (dict): Contains the input data and request metadata
        
    Returns:
        Any: The result to be returned to the client
    """
    
    print(f"Worker Start")
    
    # Extract input data (RunPod official format)
    input_data = event['input']
    
    prompt = input_data.get('prompt', 'test')
    
    print(f"Received prompt: {prompt}")
    
    # Check if model volume is mounted
    model_path = "/workspace/my-models-storage/models/fortnite-model"
    model_exists = os.path.exists(model_path)
    
    # List workspace contents
    workspace_contents = []
    if os.path.exists("/workspace"):
        workspace_contents = os.listdir("/workspace")
    
    # Return result in RunPod format
    result = {
        "status": "success",
        "prompt_received": prompt,
        "model_path_exists": model_exists,
        "workspace_contents": workspace_contents,
        "message": "RunPod official handler working!"
    }
    
    print(f"Returning result: {result}")
    
    return result

# Start the Serverless function when the script is run
if __name__ == '__main__':
    runpod.serverless.start({'handler': handler})