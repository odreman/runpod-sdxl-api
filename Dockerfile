FROM runpod/pytorch:2.0.1-py3.10-cuda11.8.0-devel-ubuntu22.04

WORKDIR /workspace

# Install runpod
RUN pip install --no-cache-dir runpod

# Copy your handler file
COPY rp_handler.py /workspace/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]