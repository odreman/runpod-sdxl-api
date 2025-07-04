import runpod
import os

def handler(job):
    """
    Simple test handler - just echo back the input
    """
    try:
        # Get job input
        job_input = job.get("input", {})
        
        # Check if model path exists
        model_path = "/workspace/my-models-storage/models/fortnite-model"
        model_exists = os.path.exists(model_path)
        
        # List contents of workspace
        workspace_contents = []
        if os.path.exists("/workspace"):
            workspace_contents = os.listdir("/workspace")
        
        return {
            "status": "success",
            "input_received": job_input,
            "model_path_exists": model_exists,
            "workspace_contents": workspace_contents,
            "message": "Handler is working! Model loading disabled for testing."
        }
        
    except Exception as e:
        return {
            "error": str(e),
            "status": "error"
        }

if __name__ == "__main__":
    print("Starting simple test handler...")
    runpod.serverless.start({"handler": handler})