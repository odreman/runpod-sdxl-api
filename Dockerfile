FROM runpod/pytorch:2.0.1-py3.10-cuda11.8.0-devel-ubuntu22.04

WORKDIR /workspace

# Install runpod and all dependencies directly
RUN pip install --no-cache-dir \
    runpod>=1.0.0 \
    diffusers>=0.21.0 \
    transformers>=4.30.0 \
    accelerate>=0.20.0 \
    pillow>=9.0.0 \
    safetensors>=0.3.0

# Copy your handler file
COPY rp_handler.py /workspace/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]