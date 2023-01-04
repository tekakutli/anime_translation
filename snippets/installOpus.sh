#!/usr/bin/env sh

pushd "$PATH_TO_OPUS"

git clone https://github.com/Helsinki-NLP/Opus-MT .

rm services.json docker-compose.yaml
ln -s "$PATH_TO_SUBS/snippets/Opus-MT/services.json" .
ln -s "$PATH_TO_SUBS/snippets/Opus-MT/docker-compose.yaml" .

sudo docker-compose up

popd
