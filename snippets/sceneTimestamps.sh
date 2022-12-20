#!/usr/bin/env sh

scenedetect -i "$VIDEO_TO_SUB" detect-adaptive list-scenes >> ${OUTPUTS}scenedetect_output.txt
cat ${OUTPUTS}scenedetect_output.txt | grep \| | cut -d'|' -f4,6 | sed 's/|/--->/g' >> ${OUTPUTS}timestamps.txt
tail -1 ${OUTPUTS}scenedetect_output.txt > ${OUTPUTS}timecodes.txt
