#!/usr/bin/env sh

CURRENTDIR=$(pwd)
cd /tmp
LIVE_RECORD="/tmp/recording.flac"
WAV_RECORD="/tmp/recording.wav"
pw-record $LIVE_RECORD
ffmpeg -y -i "$LIVE_RECORD" -ar 16000 -ac 1 -c:a pcm_s16le $WAV_RECORD


LANG_FROM="en"
PATH_TO_WHISPER="/home/$USER/code/whisper.cpp"
PATH_TO_MODELS="/home/$USER/files/models"

# Tiny is small, fast and enough for english
if [[ "$LANG_FROM" == "en" ]]; then
    $PATH_TO_WHISPER/main -m $PATH_TO_MODELS/ggml-tiny.bin -l en -f "$WAV_RECORD" -otxt
else
    $PATH_TO_WHISPER/main -m $PATH_TO_MODELS/ggml-large.bin -l $LANG_FROM -tr -f "$WAV_RECORD" -otxt
fi
cat "$WAV_RECORD".txt | wl-copy
wl-paste
cd $CURRENTDIR
