# Retrieval-based-Voice-Conversion-WebUI

bootstrap for https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI

# prerequisites

- nvidia driver/cuda
- conda
- ffmpeg

## github

    git clone --recurse-submodules git@github.com:mazurkin/rvc-lab.gitt rvc-lab
    cd rvc-lab

## installation

    make env-init-conda
    make env-init-poetry
    make env-init-pip
    make env-init-models

## run

    make run
