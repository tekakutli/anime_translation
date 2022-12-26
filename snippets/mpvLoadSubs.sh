#!/usr/bin/env sh

subs_file="$OUTPUT/${VTTPREFIX}_translation.vtt"
mpv --sub-file="$subs_file" "$VIDEO_TO_SUB"
