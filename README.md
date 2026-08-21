# AquaZn-Scout-runtime

Public, dependency-only CPU image for the private `AquaZn-Scout` repository.

It contains Python, RDKit, PyArrow, DuckDB, pandas, scikit-learn, boto3 and the streaming/download dependencies used by the data pipeline. It deliberately contains no project source code, raw data, model weights, or credentials.

Image:

```text
ghcr.io/fangwei123456/aquazn-scout-runtime:latest
```

The image is built and published by GitHub Actions using the repository `GITHUB_TOKEN`. The private project can use it as a base image or run its code by mounting the private checkout at runtime.

