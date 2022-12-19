#!/usr/bin/env sh

languagetool (){
     sudo systemctl start docker
     sudo docker run -d --rm -it --name=libregrammar -p 8081:8081 registry.gitlab.com/py_crash/docker-libregrammar
}
vttToSrt (){
    ffmpeg -y -i file.vtt file.srt
}


streamTranslate (){
    bash streamtranslate.sh
}

sceneTimestamps (){
    bash sceneTimestamps.sh
}
speechTimestamps (){
    bash speechTimestamps.sh
}
useWhisper (){
    bash modelToText.sh
}
formatToVtt (){
    bash formatToVtt.sh $1
}
mpvLoadSubs (){
    bash mpvLoadSubs.sh
}
exportSubs (){
    bash exportSubs.sh
}
autosync (){
    bash autosync.sh
}

