#!/usr/bin/env sh

ffmpeg -i "$VIDEO_TO_SUB" -i "$PATH_TO_SUBS/translation.vtt" -c copy -c:s mov_text outfile.mp4
