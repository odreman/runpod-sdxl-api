
# Use RunPod's PyTorch base image
FROM runpod/pytorch:2.0.1-py3.10-cuda11.8.0-devel-ubuntu22.04

# Set working directory
WORKDIR /workspace

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the handler
COPY handler.py .

# Set the default command
CMD ["python", "handler.py"]