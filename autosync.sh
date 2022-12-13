#!/usr/bin/env sh

# the fundamental primitive
# ffs video.mp4 -i unsynchronized.srt -o synchronized.srt

VIDEOTT="video.mp4"
PREFIX="chapter_10"
# use a simpler-faster model to get the japanese transcription
VTTJAPANESE="raw_japanese.vtt"
VTTENGLISH="raw_english.vtt"

ffmpeg -y -i $VTTJAPANESE unsynchronized_japanese.srt
ffmpeg -y -i $VTTENGLISH unsynchronized_english.srt
ffsubsync $VIDEOTT -y -i unsynchronized_japanese.srt -o synchronized_japanese.srt --max-offset-seconds .1 --gss
ffsubsync synchronized_japanese.srt -y -i unsynchronized_english.srt -o synchronized_english.srt --max-offset-seconds .1
ffmpeg -y -i synchronized_english.srt "${PREFIX}_ffsubsync_english.vtt"
ffmpeg -y -i synchronized_japanese.srt "${PREFIX}_ffsubsync_japanese.vtt"
rm unsynchronized_japanese.srt unsynchronized_english.srt synchronized_japanese.srt synchronized_english.srt
