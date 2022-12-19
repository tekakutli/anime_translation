#!/usr/bin/env sh


libregrammar (){
     sudo systemctl start docker
     sudo docker run -d --rm -it --name=libregrammar -p 8081:8081 registry.gitlab.com/py_crash/docker-libregrammar
}

vttToSrt (){
    ffmpeg -y -i file.vtt file.srt
}

streamTranslate(){
    bash streamtranslate.sh
}
