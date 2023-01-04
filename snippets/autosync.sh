#!/usr/bin/env sh

# the fundamental primitive
# ffs video.mp4 -i unsynchronized.srt -o synchronized.srt

unsync_japanese="$OUTPUT/unsynchronized_japanese.srt"
unsync_english="$OUTPUT/unsynchronized_english.srt"

sync_japanese="$OUTPUT/synchronized_japanese.srt"
sync_english="$OUTPUT/synchronized_english.srt"

ffmpeg -y -i "$OUTPUT/$VTT_JAPANESE" "$unsync_japanese"
ffmpeg -y -i "$OUTPUT/$VTT_ENGLISH" "$unsync_english"
ffsubsync "$VIDEO_TO_SUB" -i "$unsync_japanese" -o "$sync_japanese" --max-offset-seconds .1 --gss
ffsubsync "$sync_japanese" -i "$unsync_english" -o "$sync_english" --max-offset-seconds .1
ffmpeg -y -i "$sync_english" "${VTTPREFIX}_ffsubsync_english.vtt"
ffmpeg -y -i "$sync_japanese" "${VTTPREFIX}_ffsubsync_japanese.vtt"
