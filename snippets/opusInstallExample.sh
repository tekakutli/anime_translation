#!/usr/bin/env sh

# example
# will download: zho-eng eng-zho ja-en, to your PATH_TO_MODELS
# and rename the downloaded directories to those short-hand names

cd "$PATH_TO_MODELS"
mkdir ja-en
wget https://object.pouta.csc.fi/OPUS-MT-models/ja-en/opus-2019-12-18.zip
unzip opus-2019-12-18.zip -d ja-en

mkdir zho-eng
# https://github.com/Helsinki-NLP/Tatoeba-Challenge/tree/master/models/zho-eng
wget https://object.pouta.csc.fi/Tatoeba-MT-models/zho-eng/opus-2020-07-17.zip
unzip opus-2020-07-17.zip -d zho-eng

mkdir eng-zho
# https://github.com/Helsinki-NLP/Tatoeba-Challenge/tree/master/models/eng-zho
wget https://object.pouta.csc.fi/Tatoeba-MT-models/eng-zho/opus-2021-02-23.zip
unzip opus-2021-02-23.zip -d eng-zho
