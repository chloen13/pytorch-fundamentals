# ============================
# Base image with conda
# ============================
FROM continuumio/miniconda3:24.3.0-0


# Make sure Python output is unbuffered
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Workdir inside the container
WORKDIR /app

# ============================
# Create conda env from environment.yml
# ============================
# Copy only environment.yml first to leverage Docker layer caching
COPY environment-wsl.yml .

# Use bash for conda commands
SHELL ["bash", "-lc"]

# Create the conda env.
ARG ENV_NAME=py311

RUN conda env create -f environment-wsl.yml && \
    conda clean -afy

# Activate env by default by adjusting PATH
ENV CONDA_DEFAULT_ENV=${ENV_NAME}
ENV PATH=/opt/conda/envs/${ENV_NAME}/bin:/home/runner/work/custom-azure-demo:/home/runner/work/custom-azure-demo/custom_azure_demo:/usr/bin:$PATH

# ============================
# Copy the rest of the app
# ============================
COPY . .

# Create a non-root user for security and a mount point for SQLite
#RUN useradd -m appuser && \
#    mkdir -p /mnt/db && \
#    chown -R appuser:appuser /app /mnt/db

USER appuser


# ============================
# Entry point
# ============================
# If your main entry is something else, change this to e.g. "python -m yourpkg"
ENTRYPOINT ["python", "app_job_main.py"]
