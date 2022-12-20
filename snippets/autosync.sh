#!/usr/bin/env sh

# the fundamental primitive
# ffs video.mp4 -i unsynchronized.srt -o synchronized.srt

cd $OUTPUTS
ffmpeg -y -i $VTTJAPANESE unsynchronized_japanese.srt
ffmpeg -y -i $VTTENGLISH unsynchronized_english.srt
ffsubsync $VIDEO_TO_SUB -i unsynchronized_japanese.srt -o synchronized_japanese.srt --max-offset-seconds .1 --gss
ffsubsync synchronized_japanese.srt -i unsynchronized_english.srt -o synchronized_english.srt --max-offset-seconds .1
ffmpeg -y -i synchronized_english.srt "${VTTPREFIX}_ffsubsync_english.vtt"
ffmpeg -y -i synchronized_japanese.srt "${VTTPREFIX}_ffsubsync_japanese.vtt"
rm unsynchronized_japanese.srt unsynchronized_english.srt synchronized_japanese.srt synchronized_english.srt
