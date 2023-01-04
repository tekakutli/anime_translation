#!/usr/bin/env sh

scenedetect -i "$VIDEO_TO_SUB" detect-adaptive list-scenes >> "$OUTPUT/scenedetect_output.txt"
cat "$OUTPUT/scenedetect_output.txt" | grep \| | cut -d'|' -f4,6 | sed 's/|/--->/g' >> "$OUTPUT/timestamps.txt"
tail -1 "$OUTPUT/scenedetect_output.txt" > "$OUTPUT/timecodes.txt"
