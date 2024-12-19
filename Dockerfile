# Set default build arg for python image
ARG PYTHON_IMAGE="python:3.13-slim"
# Set default build arg for llama.cpp image
ARG LLAMA_CPP_IMAGE="ghcr.io/ggerganov/llama.cpp:server-b4357"

# Stage 1: Download the model
FROM ${PYTHON_IMAGE} as downloader

# Install huggingface-cli
RUN pip install --no-cache-dir huggingface_hub

# Create models directory
WORKDIR /models

# Set default build args for model repo and model quantization
ARG MODEL_REPO="bartowski/Phi-3.5-mini-instruct-GGUF"
ARG MODEL_QUANTIZATION="Phi-3.5-mini-instruct-Q4_K_L.gguf"

# Download the model
RUN huggingface-cli download --local-dir /models/ ${MODEL_REPO} ${MODEL_QUANTIZATION}

# Stage 2: Set up the server
FROM ${LLAMA_CPP_IMAGE}

ARG MODEL_QUANTIZATION

# Copy the model from the downloader stage
COPY --from=downloader /models/${MODEL_QUANTIZATION} /model

# Set llama server port
ENV SERVER_PORT=8080
ENV LLAMA_ARG_PORT=${SERVER_PORT}

# Expose the server port
EXPOSE ${LLAMA_ARG_PORT}

# Start the server
ENTRYPOINT ["/app/llama-server", "-m", "/model", "--host", "0.0.0.0"]