#!/usr/bin/env sh

ffmpeg -i "$VIDEO_TO_SUB" -ar 16000 -ac 1 -c:a pcm_s16le "$AUDIO_EXTRACT"
"$PATH_TO_WHISPER/main" -m "$PATH_TO_MODELS/ggml-large.bin" -l ja -su -f "$AUDIO_EXTRACT" -ovtt
