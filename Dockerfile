FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /opt/aquazn-runtime

# Keep the image usable as a Vast.ai SSH container.  The base Python image is
# intentionally minimal and does not include the SSH daemon/client that Vast's
# launcher expects.  These also cover the small set of tools needed to fetch
# the private project and unpack the separately managed Gaussian archive.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        openssh-client \
        openssh-server \
        procps \
        rsync \
        tcsh \
        tmux \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY requirements-runtime.txt /tmp/requirements-runtime.txt
RUN python -m pip install --upgrade pip \
    && python -m pip install --prefer-binary -r /tmp/requirements-runtime.txt \
    && python -m pip install --prefer-binary "rdkit>=2024.3.1"

LABEL org.opencontainers.image.title="AquaZn-Scout runtime" \
      org.opencontainers.image.description="CPU chemistry and data-processing runtime for AquaZn-Scout" \
      org.opencontainers.image.source="https://github.com/fangwei123456/AquaZn-Scout-runtime"

CMD ["python", "--version"]
