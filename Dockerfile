FROM nvidia/cuda:12.1-devel-ubuntu22.04

# Install Python 3.10
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3.10 /usr/bin/python

WORKDIR /workspace

# Install exact versions from your working Vast.ai environment
RUN pip install --no-cache-dir \
    torch==2.5.1 \
    torchvision==0.20.1 \
    torchaudio==2.5.1 \
    --index-url https://download.pytorch.org/whl/cu121

RUN pip install --no-cache-dir \
    runpod>=1.0.0 \
    huggingface-hub==0.29.3 \
    transformers==4.49.0 \
    diffusers==0.34.0 \
    accelerate \
    pillow \
    safetensors

# Copy your handler file
COPY rp_handler.py /workspace/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]