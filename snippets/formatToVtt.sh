#!/usr/bin/env sh

cat $1 | awk '{gsub(/\[/,"\n");print $0}' | awk '{gsub(/\]  /,"\n");print $0}' > $1.vtt
formatToVtt terminaloutput.txt
