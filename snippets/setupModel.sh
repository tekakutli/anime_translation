#!/usr/bin/env sh

pushd "$PATH_TO_MODELS"
wget https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/main/ggml-large.bin
popd

pushd "$PATH_TO_WHISPER"
git clone https://github.com/ggerganov/whisper.cpp .
make
popd
