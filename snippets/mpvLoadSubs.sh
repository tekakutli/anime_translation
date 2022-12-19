#!/usr/bin/env sh

SUBS_FILE="$PATH_TO_SUBS/translation.vtt"
mpv --sub-file="$SUBS_FILE" "$VIDEO_TO_SUB"
