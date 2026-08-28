FROM python:3.12-slim

ARG PYTORCH_INDEX_URL=https://download.pytorch.org/whl/cu130

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /opt/aquazn-runtime

# Keep the image usable as a Vast.ai SSH container.  The base Python image is
# intentionally minimal and does not include the SSH daemon/client that Vast's
# launcher expects.  These also cover the small set of tools needed to fetch
# the private project and unpack the separately managed Gaussian archive.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        g++ \
        git \
        libglib2.0-0 \
        libgomp1 \
        openssh-client \
        openssh-server \
        procps \
        rsync \
        tcsh \
        tmux \
        unzip \
        ninja-build \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-runtime.txt /tmp/requirements-runtime.txt
COPY requirements-training.txt /tmp/requirements-training.txt
RUN python -m pip install --upgrade pip \
      && python -m pip install --prefer-binary -r /tmp/requirements-runtime.txt \
      && python -m pip install --prefer-binary "rdkit>=2024.3.1" \
      && python -m pip install --prefer-binary \
          --index-url "${PYTORCH_INDEX_URL}" \
          --extra-index-url https://pypi.org/simple \
          -r /tmp/requirements-training.txt

LABEL org.opencontainers.image.title="AquaZn-Scout runtime" \
      org.opencontainers.image.description="CUDA-capable chemistry, data-processing and PyTorch training runtime for AquaZn-Scout" \
      org.opencontainers.image.source="https://github.com/fangwei123456/AquaZn-Scout-runtime"

CMD ["python", "--version"]
