#!/usr/bin/env sh

cd "$PATH_TO_MODELS"
wget https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/main/ggml-large.bin
cd "$PATH_TO_WHISPER"
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
