#!/usr/bin/env sh


OPUSMT=true
LANG_TO=en
# ACTIVATES OPUS
Opus-MT (){
     OPUSMT=false;
     sudo systemctl start docker
     CURRENTDIR=$(pwd)
     cd $PATH_TO_OPUS/Opus-MT
     sudo docker-compose up -d
     cd $CURRENTDIR
}
translationApiCall(){
     curl -s -X POST -H "Content-Type: application/json" -d "{\"source\":\"$1\",\"from\":\"$LANG_FROM\",\"to\":\"$LANG_TO\"}" "localhost:8888/api/translate" | jq -r '.translation'
}
# White Space Breaks Japanese-Chinese Translation
translationApiCallWhiteSpaceFix (){
     TR=""
     IFS=' ' read -ra ADDR <<< "$1"
     for i in "${ADDR[@]}"; do
          TRANSLATION=$(translationApiCall $i)
          TR=$TR" "$TRANSLATION
     done
     echo $TR
}
# THE MAIN METHOD
t(){
     if $OPUSMT; then
           Opus-MT;
           OPUSMT=false;
     fi
     if [[ "$LANG_FROM" == "en" ]]; then
          TRANSLATION=$(translationApiCall "$1")
     else
          TRANSLATION=$(translationApiCallWhiteSpaceFix "$1")
     fi
     echo $TRANSLATION
     wl-copy $TRANSLATION
     # echo ""
}

# SHORTHAND CONVENIANCES FOR EASY LANG-PAIR SWITCHING, ADD YOURS
tj(){
     LANG_FROM=Japanese
     LANG_TO=en
}
tme(){
     LANG_FROM=Mandarin
     LANG_TO=en
}
tem(){
     LANG_FROM=en
     LANG_TO=Mandarin
}
