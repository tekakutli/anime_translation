#!/usr/bin/env sh

sudo mkdir -p /usr/src/app/
sudo ln -s $PATH_TO_MODELS /usr/src/app/models

cd $PATH_TO_OPUS
git clone https://github.com/Helsinki-NLP/Opus-MT
cd Opus-MT
rm services.json docker-compose.yaml
ln -s $PATH_TO_SUBS/snippets/Opus-MT/services.json .
ln -s $PATH_TO_SUBS/snippets/Opus-MT/docker-compose.yaml .

sudo docker-compose build
sudo docker-compose up
