# handler.py
import runpod
import json
import time
import requests
import base64

class ComfyUIExecutor:
    def __init__(self):
        self.base_url = "http://127.0.0.1:8188"
        try:
            requests.get(f"{self.base_url}/system_stats", timeout=10).raise_for_status()
            print("ComfyUI Executor: Conexión con ComfyUI exitosa.")
        except requests.exceptions.RequestException as e:
            raise ConnectionError("No se pudo conectar a la API de ComfyUI en el backend.") from e

    def execute_workflow(self, workflow_json):
        response = requests.post(f"{self.base_url}/prompt", json={"prompt": workflow_json})
        response.raise_for_status()
        
        prompt_id = response.json().get("prompt_id")
        if not prompt_id:
            raise ValueError(f"La respuesta de la API no contiene 'prompt_id': {response.json()}")
        
        print(f"Workflow encolado. Prompt ID: {prompt_id}")
        
        timeout_seconds = 300 # 5 minutos
        start_time = time.time()
        
        while time.time() - start_time < timeout_seconds:
            history_response = requests.get(f"{self.base_url}/history/{prompt_id}")
            history_response.raise_for_status()
            history = history_response.json()

            if prompt_id in history:
                outputs = history[prompt_id].get("outputs", {})
                images = []
                
                for node_id, node_output in outputs.items():
                    if "images" in node_output:
                        for img_info in node_output["images"]:
                            image_url = f"{self.base_url}/view?filename={img_info['filename']}&subfolder={img_info.get('subfolder', '')}&type={img_info.get('type', 'output')}"
                            img_data_response = requests.get(image_url)
                            img_data_response.raise_for_status()
                            images.append(base64.b64encode(img_data_response.content).decode('utf-8'))
                
                if images:
                    return images
                
                raise RuntimeError("Workflow completado pero no se encontraron imágenes en la salida.")
            
            time.sleep(1)
        
        raise TimeoutError(f"Timeout esperando el resultado del prompt_id: {prompt_id}")

try:
    executor = ComfyUIExecutor()
except ConnectionError as e:
    executor = None
    print(f"Error fatal al inicializar el Executor: {e}")

def handler(job):
    if executor is None:
        return {"status": "failed", "error": "El worker no se inició correctamente, ComfyUI no está disponible."}

    try:
        job_input = job.get("input", {})
        workflow = job_input.get("workflow")
        
        if not workflow or not isinstance(workflow, dict):
            return {"status": "failed", "error": "La petición debe contener un 'workflow' en formato JSON."}
        
        images = executor.execute_workflow(workflow)
        
        return { "status": "success", "images": images, "count": len(images) }
        
    except Exception as e:
        import traceback
        print(f"Error en el handler: {e}\n{traceback.format_exc()}")
        return { "status": "failed", "error": str(e) }

print("Iniciando servidor RunPod...")
runpod.serverless.start({"handler": handler})