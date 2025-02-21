# rvc

SHELL := /bin/bash

ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

CONDA_ENV_NAME = rvc

export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# -----------------------------------------------------------------------------
# run
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = run

.PHONY: run
run:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) --cwd rvc \
		python infer-web.py

# -----------------------------------------------------------------------------
# conda environment
# -----------------------------------------------------------------------------

.PHONY: env-init-conda
env-init-conda:
	@conda create --yes --copy --name $(CONDA_ENV_NAME) \
		python=3.10.12 \
		pip=23.3.2 \
		nvidia::cuda-toolkit=12.4.1 \
		conda-forge::cudnn=9.3.0.75 \
		conda-forge::poetry=1.8.5

.PHONY: env-init-poetry
env-init-poetry:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry install --no-root --no-directory

.PHONY: env-init-pip
env-init-pip:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) pip install -r rvc/requirements.txt

.PHONY: env-init-models
env-init-models:
	@mkdir -p 'rvc/assets/rmvpe'
	@wget -v -O 'rvc/assets/rmvpe/rmvpe.pt' 'https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt'
	@mkdir -p 'rvc/assets/hubert'
	@wget -v -O 'rvc/assets/hubert/hubert_base.pt' 'https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt'
	@mkdir -p 'rvc/assets/pretrained_v2'
	@wget -v -O 'rvc/assets/pretrained_v2/f0G40k.pth' 'https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth'
	@wget -v -O 'rvc/assets/pretrained_v2/f0D40k.pth' 'https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth'

.PHONY: env-remove
env-remove:
	@conda env remove --yes --name $(CONDA_ENV_NAME)

.PHONY: env-update
env-update:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry update

.PHONY: env-list
env-list:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) poetry show

.PHONY: env-shell
env-shell:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) --cwd rvc \
		bash

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name $(CONDA_ENV_NAME) conda info
