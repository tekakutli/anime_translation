# Anime Translation Initiative
AI-helped transcription and translation

## Setup
used model: WHISPER  
works offline  

download model *ggml-large.bin* from: https://huggingface.co/datasets/ggerganov/whisper.cpp
```
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
```

## Model Usage
get audio.wav from video file for *whisper* to use

``` 
ffmpeg -i "video.mp4" -ar 16000 -ac 1 -c:a pcm_s16le audio.wav
<path_to_whisper.cpp>/main -m <path_to_models>/ggml-large.bin -l ja -tr -f audio.wav -ovtt
``` 

the -tr flag activates translation into english, without it transcribes into japanese  

### Warning
- it often breaks with music segments  
- if you see it start outputing the same thing over and over, stop it
  - then use the -ot *miliseconds* flag to resume at that point

## MPV 
get mpv to load some subs
``` 
SUBS_FILE="<path_to_subs>/translation.vtt"
mpv --sub-file="$SUBS_FILE" "video.mp4"
``` 

what subs?  
git clone https://github.com/tekakutli/anime_translation/

## .vtt efficient creation or edit
I use *subed*

git clone https://github.com/sachac/subed  
and copy next snippet into emacs config.el  

``` 
(add-to-list 'load-path "<path_to_subed>/subed/subed")
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
## Scene Detection
pip install scenedetect[opencv] --upgrade

usage
```
scenedetect -i video.mp4 detect-adaptive list-scenes >> scenedetect_output.txt
cat scenedetect_output.txt | grep \| | cut -d'|' -f4,6 | sed 's/|/--->/g' >> timestamps.txt
tail -1 scenedetect_output.txt > timecodes.txt
```
## Why X
- Why Git over Google-Docs or similar?  
  - Version Control Systems (git) is an ergonomic tool to pick or disregard from contributions, it enables trully parallel work distribution
- Why .vtt over others?  
  - *whisper* can output vtt or srt  
  - *subed* can work with vtt or srt  
  - why vtt over srt? personal choice, but:
    - vtt has no need for numbers as id
    - seems shorter and more efficient
