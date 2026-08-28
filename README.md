# AquaZn-Scout-runtime

Public, dependency-only runtime image for the private `AquaZn-Scout` repository.

It contains the complete current Python environment used by the project:

- data processing: NumPy, pandas, PyArrow, DuckDB, ijson, requests, boto3;
- chemistry and baselines: RDKit, SciPy, scikit-learn, XGBoost, psycopg;
- training and tests: CUDA-enabled PyTorch 2.13.0, pytest, and the Linux build
  tools needed by the optional `torch.compile` path;
- Vast operations: SSH client/server, tmux, rsync, tcsh, unzip and basic
  diagnostics.

PyTorch is installed from the official CUDA 13.0 wheel index. A GPU is not
required for importing the image or running preprocessing; when the container
is started with NVIDIA container support, the same image can run the project's
CUDA training scripts.

The image deliberately contains no project source code, raw data, model
weights, Gaussian installation, or credentials.

Image:

```text
ghcr.io/fangwei123456/aquazn-scout-runtime:latest
```

The image is built and published by GitHub Actions using the repository
`GITHUB_TOKEN`. The private project can use it as a base image or run its code
by mounting the private checkout at runtime.

## Vast/GPU usage

Mount the private checkout and data at runtime; do not copy them into this
public image:

```bash
docker run --rm --gpus all \
  -v "$PWD:/workspace" \
  -v "$PWD/data_processed:/data_processed" \
  ghcr.io/fangwei123456/aquazn-scout-runtime:latest \
  python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available())"
```

The image includes PyTorch's SDPA/Flash-attention backends through PyTorch
itself. The project does not currently require the separate `flash-attn`
package, so it is intentionally not installed as an additional fragile native
build dependency.

## Environment smoke test

The CI workflow pulls the published image and checks the core imports, the
CUDA-enabled PyTorch build, RDKit, XGBoost and the project data/database
libraries. The CI runner has no GPU, so `torch.cuda.is_available()` is expected
to be false there; the test instead checks that CUDA support is compiled into
PyTorch.
