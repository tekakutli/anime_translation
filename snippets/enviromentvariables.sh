#!/usr/bin/env sh

# SET YOUR PERSONAL ENVIROMENT VARIABLES (FILL APPROPRIATELY)
# export PATH_TO_WHISPER="whisper.cpp clone"
# export PATH_TO_MODELS="models folder, like for ggml-large.bin"
# export PATH_TO_SUBS="anime_translation clone, this repo"
# export PATH_TO_SUBED="emacs_subed clone"
# export VIDEO_TO_SUB="path/video.mp4"
# export LANG_FROM="the source language 2-3 letter ISO code"
# export PATH_TO_OPUS="Opus-MT clone"
# export OUTPUTS="future output, like vad"
# export AUDIO_EXTRACT="path/doesnt_exist_yet_audio.wav"
# mkdir -p $OUTPUTS

export PATH_TO_MODELS="/home/$USER/files/models"
export VIDEO_TO_SUB="/home/$USER/Downloads/torrent/video.mp4"
export LANG_FROM="ja"
export CLONES="/home/$USER/code" #MY OWN PATH TO CLONES
export PATH_TO_WHISPER="$CLONES/whisper.cpp"
export PATH_TO_SUBS="$CLONES/anime_translation"
export PATH_TO_SUBED="$CLONES/emacs/subed"
export PATH_TO_OPUS="$CLONES"
export OUTPUTS="/tmp/outputs/"
export AUDIO_EXTRACT="${OUTPUTS}audio.wav"
mkdir -p "$OUTPUTS"


export VTTPREFIX="isekai_ojisan_11"
# THESE VTTS ARE THOSE YOU ALREADY MADE, AND WORKING UPON
export VTTJAPANESE="${OUTPUTS}isekai_ojisan_11_whisper_small_japanese.vtt"
export VTTENGLISH="${OUTPUTS}isekai_ojisan_11_whisper_large_english.vtt"
