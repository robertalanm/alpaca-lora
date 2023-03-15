# Use the official NVIDIA CUDA image as the base image
FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

# Set the working directory
WORKDIR /app

# Update and install required dependencies
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    git

# Upgrade pip
RUN python3.8 -m pip install --upgrade pip

# Clone the transformers repository and install the required version
RUN git clone https://github.com/zphang/transformers.git /app/transformers \
    && cd /app/transformers \
    && git checkout llama_push \
    && pip install -e .

# Install PEFT
RUN pip install git+https://github.com/huggingface/peft.git

# Install bitsandbytes from source
RUN git clone https://github.com/TimDettmers/bitsandbytes.git /app/bitsandbytes \
    && cd /app/bitsandbytes \
    && python3.8 setup.py install

# Install other required packages
RUN pip install \
    datasets \
    loralib \
    sentencepiece

# Copy the project files into the container
COPY . /app

# Set the entrypoint to run the training script
ENTRYPOINT ["python3.8", "finetune.py"]
