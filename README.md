# Anime Translation Initiative
AI-helped transcription and translation  
everything works offline  
```
# SET YOUR ENVIROMENT VARIABLES, IN YOUR .BASH_PROFILE
# SET IF NEEDED
PATH_TO_WHISPER="whisper.cpp clone"
PATH_TO_MODELS="models folder, like for ggml-large.bin"
PATH_TO_SUBS="anime_translation clone, this repo"
PATH_TO_SUBED="emacs_subed clone"
VIDEO_TO_SUB="video.mp4"
AUDIO_EXTRACT="doesnt_exist_yet_audio.wav"

# NEEDED IF OPUS OR STREAMTRANSLATE
PATH_TO_OPUS="Opus-MT clone"
LANG_FROM="ja"

# EXAMPLE
PATH_TO_WHISPER="/home/$USER/code/whisper.cpp"
PATH_TO_MODELS="/home/$USER/models"
```
## Setup

### Model Setup
used model: WHISPER  
download model *ggml-large.bin* from: https://huggingface.co/datasets/ggerganov/whisper.cpp
```
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
```

#### Model Usage
get audio from video file for *whisper* to use
``` 
ffmpeg -i "$VIDEO_TO_SUB" -ar 16000 -ac 1 -c:a pcm_s16le "$AUDIO_EXTRACT"
$PATH_TO_WHISPER/main -m $PATH_TO_MODELS/ggml-large.bin -l ja -tr -f "$AUDIO_EXTRACT" -ovtt
``` 

the -tr flag activates translation into english, without it transcribes into japanese  

#### Warning
- it often breaks with music segments  
- if you see it start outputing the same thing over and over, stop it
  - then use the -ot *miliseconds* flag to resume at that point

### MPV 
get mpv to load some subs
``` 
SUBS_FILE="$PATH_TO_SUBS/translation.vtt"
mpv --sub-file="$SUBS_FILE" "$VIDEO_TO_SUB"
``` 

what subs?  
git clone https://github.com/tekakutli/anime_translation/

### .vtt efficient creation or edit
I use *subed*

git clone https://github.com/sachac/subed  
and copy next snippet into emacs config.el  

``` 
(add-to-list 'load-path "$PATH_TO_SUBED/subed/subed")
(require 'subed-autoloads)

(use-package! subed
  :ensure t
  :config
  ;; Disable automatic movement of point by default
  (add-hook 'subed-mode-hook 'subed-disable-sync-point-to-player)
  ;; Remember cursor position between sessions
  (add-hook 'subed-mode-hook 'save-place-local-mode)
  ;; Break lines automatically while typing
  (add-hook 'subed-mode-hook 'turn-on-auto-fill)
   ;; Break lines at 40 characters
  (add-hook 'subed-mode-hook (lambda () (setq-local fill-column 40))))
```
now you can use (subed-mpv-play-from-file) and automatically sync what mpv is showing with what you have in focus at the .vtt
### Utils
AutoSync subtitles:
```
pip install ffsubsync
bash autosync.sh
```
To .srt Conversion
``` 
ffmpeg -y -i file.vtt file.srt
```
#### Grammar-Spelling Checking - Language Tool
Install full-version of Language Tool
```
docker pull registry.gitlab.com/py_crash/docker-libregrammar
```
Activate it
```
libregrammar (){
     sudo systemctl start docker
     sudo docker run -d --rm -it --name=libregrammar -p 8081:8081 registry.gitlab.com/py_crash/docker-libregrammar
}
libregrammar
```
Emacs config.el
```
(setq langtool-http-server-host "localhost"
      langtool-http-server-port 8081)
;; (setq langtool-http-server-stream-type 'tls)
(setq langtool-default-language "en-US")
(require 'langtool)
```
Emacs use
```
(langtool-check)
```
#### Local Text Translation
get your FROM-TO model from  
https://github.com/Helsinki-NLP/Opus-MT-train/tree/master/models  
https://github.com/Helsinki-NLP/Tatoeba-Challenge/tree/master/models  
example, download: zho-eng eng-zho ja-en, to your PATH_TO_MODELS  
and renaming the downloaded directories to those short-hand names  
and edit PATH_TO_SUBS/Opus-MT/services.json appropriately
```
sudo mkdir -p /usr/src/app/
sudo ln -s $PATH_TO_MODELS /usr/src/app/models

cd $PATH_TO_OPUS
git clone https://github.com/Helsinki-NLP/Opus-MT
cd Opus-MT
rm services.json docker-compose.yaml
ln -s $PATH_TO_SUBS/Opus-MT/services.json .
ln -s $PATH_TO_SUBS/Opus-MT/docker-compose.yaml .

sudo docker-compose build
sudo docker-compose up
```
To activate:
```
source opus.sh
Opus-MT

```
To use:
```
t "text to translate"
```
### Get Event Timestamps
Speech-timestamps: (first install [torch](https://pytorch.org/get-started/locally/))
```
python vad.py "$AUDIO_EXTRACT" > audio_timecodes.txt
cat audio_timecodes.txt | awk '{gsub(/[:\47]/,"");print $0}' | awk '{gsub(/.{end /,"");print $0}' | awk '{gsub(/ start /,"");print $0}' | awk '{gsub(/}./,"");print $0}' | awk -F',' '{ print $2 "," $1}' | awk '{gsub(/,/,"\n");print $0}' | while read -r line; do date -d@$line -u '+%T.%2N'; done | paste -d " "  - - | sed 's/ / ---> /g' > audio_timestamps.txt
```
Scene-timestamps:
```
pip install scenedetect[opencv] --upgrade

scenedetect -i "$VIDEO_TO_SUB" detect-adaptive list-scenes >> scenedetect_output.txt
cat scenedetect_output.txt | grep \| | cut -d'|' -f4,6 | sed 's/|/--->/g' >> timestamps.txt
tail -1 scenedetect_output.txt > timecodes.txt
```
### Translate the Speakers-Stream
you need to Ctrl-C to stop recording, then it will translate the temporal recording
```
bash streamtranslate.sh
```
### Why X
- Why Git over Google-Docs or similar?  
  - Version Control Systems (git) is an ergonomic tool to pick or disregard from contributions, it enables trully parallel work distribution
- Why .vtt over others?  
  - *whisper* can output vtt or srt  
  - *subed* can work with vtt or srt  
  - why vtt over srt? personal choice, but:
    - vtt has no need for numbers as id
    - seems shorter and more efficient
