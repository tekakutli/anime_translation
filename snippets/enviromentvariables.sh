#!/usr/bin/env sh

# SET YOUR PERSONAL ENVIROMENT VARIABLES (FILL APPROPRIATELY)
# - PATH_TO_WHISPER: whisper.cpp clone
# - PATH_TO_MODELS: path to folder containing ggml models to use with whisper
# - PATH_TO_SUBS: path to this repository
# 
# - INPUT_VIDEO: path to the video to process
# - LANG_FROM: language to translate from
# - OUTPUT: output directory for generated files
# - AUDIO_EXTRACT: path of the extracted audio
# - VTT_PREFIX: prefix for generated subtitle files
# - VTT_JAPANESE and VTT_ENGLISH: names of generated japanese & english VTT files
#
# - PATH_TO_OPUS: path to Opus-MT clone
#
# - PATH_TO_SUBED: path to subed clone

export PATH_TO_WHISPER=
export PATH_TO_MODELS="${PATH_TO_WHISPER}/models"
export PATH_TO_SUBS=

# Input/output
export INPUT_VIDEO=
export LANG_FROM=ja # Change if INPUT_VIDEO is not in Japanese
export OUTPUT=
export AUDIO_EXTRACT="$OUTPUT/audio.wav"
export VTT_PREFIX="${input_file%.*}"
export VTT_JAPANESE="${VTT_PREFIX}_japanese.vtt"
export VTT_ENGLISH="${VTT_PREFIX}_english.vtt"

mkdir -p "$OUTPUT" # Ensure output folder exists

# If using Opus-MT
export PATH_TO_OPUS=

# If using emacs + subed
export PATH_TO_SUBED=
