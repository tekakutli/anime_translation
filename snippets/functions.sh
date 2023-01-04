#!/usr/bin/env sh

PATH_TO_SNIPPETS="${PATH_TO_SUBS}/snippets"

languagetool() {
    sudo docker run -d --rm -it --name=libregrammar -p 8081:8081 registry.gitlab.com/py_crash/docker-libregrammar
}

vttToSrt() {
    ffmpeg -y -i file.vtt file.srt
}

getAudio() {
    ffmpeg -i "$VIDEO_TO_SUB" -ar 16000 -ac 1 -c:a pcm_s16le "$AUDIO_EXTRACT"
}

streamTranslate() {
    bash "${PATH_TO_SNIPPETS}/streamtranslate.sh"
}

sceneTimestamps() {
    bash "${PATH_TO_SNIPPETS}/sceneTimestamps.sh"
}

speechTimestamps() {
    pushd "$PATH_TO_SNIPPETS"
    bash speechTimestamps.sh
    popd
}

useWhisper() {
    bash "${PATH_TO_SNIPPETS}/modelToText.sh"
}

formatToVtt() {
    bash "${PATH_TO_SNIPPETS}/formatToVtt.sh" "$1"
}

mpvLoadSubs() {
    bash "${PATH_TO_SNIPPETS}/mpvLoadSubs.sh"
}

exportSubs() {
    bash "${PATH_TO_SNIPPETS}/exportSubs.sh"
}

autosync() {
    bash "${PATH_TO_SNIPPETS}/autosync.sh"
}
