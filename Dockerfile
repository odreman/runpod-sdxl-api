FROM python:3.10-slim

# Set workspace directory
WORKDIR /workspace

# Install dependencies
RUN pip install --no-cache-dir runpod

# Copy your handler file to workspace
COPY rp_handler.py /workspace/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]