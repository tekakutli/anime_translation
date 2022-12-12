# anime_translation
AI-helped transcription and translation

## Setup
used model: WHISPER
first:
download model *ggml-large.bin* from: https://huggingface.co/datasets/ggerganov/whisper.cpp

then:
```
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
```

## Model Usage
get audio.wav from video file

``` 
ffmpeg -i "anime.mp4" -ar 16000 -ac 1 -c:a pcm_s16le audio.wav
$USER/<path_to_whisper.cpp>/main -m $USER/path_to_models/ggml-large.bin -l ja -tr -f audio.wav -ovtt

the -tr flag activates translation into english, without it transcribes into japanese


## Translation Usage

git clone https://github.com/tekakutli/anime_translation/

get mpv to load some subs
SUBS_FILE="$USER/<path_to_clone>/anime_translation/translation.vtt"
mpv --sub-file="$SUBS_FILE" "anime.mp4"
