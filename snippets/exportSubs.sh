#!/usr/bin/env sh

ffmpeg -i "$VIDEO_TO_SUB" -i "$OUTPUT/${VTT_PREFIX}_translation.vtt" -c copy -c:s mov_text "$OUTPUT/outfile.mp4"
