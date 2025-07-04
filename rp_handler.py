import runpod
import os

def handler(job):
    print(f"Worker Start")
    
    job_input = job["input"]
    prompt = job_input.get('prompt', 'test')
    
    # Verificar múltiples rutas posibles
    paths_to_check = ["/", "/workspace", "/app", "/usr/src/app"]
    
    result = {
        "status": "success",
        "prompt_received": prompt,
        "current_working_directory": os.getcwd(),
        "paths_checked": {}
    }
    
    for path in paths_to_check:
        if os.path.exists(path):
            try:
                contents = os.listdir(path)
                result["paths_checked"][path] = {
                    "exists": True,
                    "contents": contents
                }
            except Exception as e:
                result["paths_checked"][path] = {
                    "exists": True,
                    "error": str(e)
                }
        else:
            result["paths_checked"][path] = {"exists": False}
    
    return result

runpod.serverless.start({"handler": handler})