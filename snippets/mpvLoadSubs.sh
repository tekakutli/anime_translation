#!/usr/bin/env sh

SUBS_FILE="${PATH_TO_SUBS}/${VTTPREFIX}_translation.vtt"
mpv --sub-file="$SUBS_FILE" "$VIDEO_TO_SUB"
