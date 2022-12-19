# Anime Translation Initiative
AI-helped transcription and translation  
Everything works offline  
```
# SET YOUR PERSONAL ENVIROMENT VARIABLES (FILL APPROPRIATELY)
PATH_TO_WHISPER="whisper.cpp clone"
PATH_TO_MODELS="models folder, like for ggml-large.bin"
PATH_TO_SUBS="anime_translation clone, this repo"
PATH_TO_SUBED="emacs_subed clone"
VIDEO_TO_SUB="path/video.mp4"
AUDIO_EXTRACT="path/doesnt_exist_yet_audio.wav"
LANG_FROM="the source language two letter ISO code"
PATH_TO_OPUS="Opus-MT clone"

# EXAMPLE
PATH_TO_WHISPER="/home/$USER/code/whisper.cpp"
PATH_TO_MODELS="/home/$USER/files/models"
PATH_TO_SUBS="/home/$USER/code/anime_translation"
PATH_TO_SUBED="/home/$USER/code/emacs/subed"
VIDEO_TO_SUB="/home/$USER/Downloads/torrent/video.mp4"
AUDIO_EXTRACT="/tmp/audio.wav"
LANG_FROM="ja"
```
## Workflow
- I'm assuming you are using linux, and check [Dependencies](#Dependencies)
- More information about each component best researched in their own websites
- The main workflow is as follows: 
  - Setup the Model, Whisper here, and use it to translate directly from japanese audio to english text.
    - To get the audio, formated appropriately, you use ffmpeg.
    - [Instructions Here](#Model-Usage)
  - The timestamps often aren't completely aligned with the sound, so we can use an AutoSync: ffsubsync.
    - [Instructions Here](#AutoSync-the-Subs)
  - Next comes the human to fix the translation, split long captions, further align them, etc.
    - I propose the usage of Subed, which is an Emacs package
      - Subed allows us to:
        - Watch where are captioning in MPV
        - Efficiently move, merge, split the timestamps, with precision.
      - [Instructions Here](#VTT-efficient-creation-or-edit)
  - Then, to fix grammar or spelling mistakes, we can use the Language-Tool
    - [Instructions Here](#Grammar-Spelling-Checking-Language-Tool)
  - Finally, we can load the .vtt file with mpv and enjoy, [Instructions Here](#MPV)
- Some extra tools at your disposal:
  - The Opus Model is a text-to-text translator model, like Google-Translate
    - [Instructions Here](#Local-Text-Translation)
  - There are two extra tools to align the captions: a Visual Scene Detector(Scene-timestamps), and a Human Voice Detector(Speech Timestamps)
    - Often the captions align with those
    - [Instructions Here](#Get-Event-Timestamps)
  - You can use Whisper to translate a snapshot of what you are hearing from your speakers, using the Speakers-Stream thing
    - [Instructions Here](#Translate-the-Speakers-Stream)
## Setup
### Model Setup
used model: WHISPER  
will download model *ggml-large.bin* from: [here](https://huggingface.co/datasets/ggerganov/whisper.cpp) 
```
make setup
```

#### Model Usage
get audio from video file for *whisper* to use
``` 
make use
``` 
the -tr flag activates translation into english, without it transcribes into japanese
##### Warning
- whisper often breaks with music segments  
- if you see it start outputing the same thing over and over, interrupt it
  - then use the -ot *milliseconds* flag to resume at that point
- After interrupting, copy from Terminal, then format appropriately with:
```
make formatToVtt
```
### MPV 
get mpv to load some subs
``` 
make mpv
``` 
what subs?  
git clone https://github.com/tekakutli/anime_translation/

### VTT efficient creation or edit
I use *subed*  
git clone https://github.com/sachac/subed  
add *Subed* from *configAdd.el* to Emacs *config.el*  
alternatively, add this extra:  
git clone https://gist.github.com/mooseyboots/d9a183795e5704d3f517878703407184  
add *Subed Extra Section* from *configAdd.el* to Emacs *config.el*  
### AutoSync the Subs
This ffsubsync-script first autosyncs japanese captions with japanese audio, and then uses those timestamps to sync english captions to japanese captions.  
The japanese captions only need to be phonetically close, which means that we could use a smaller-faster model to get them instead, *ggml-small.bin*, [here](https://huggingface.co/datasets/ggerganov/whisper.cpp/tree/main).  
This is the reason behind the names, why some are called whisper_small vs whisper_large (the model used).
```
make installffsubsync
make autosync
```
### Other Utils
To .srt Conversion
```
source snippets/functions.sh
vttToSrt subs.vtt
```
Export final .mp4 with subtitles
```
make export
```
To format a given time in milliseconds or as timestamps, example:
```
#timeformat.sh has these two commodity functions:
milliformat "2.3" #2 minutes 3 seconds
stampformat "3.2.1" #3 hours 2 minutes 1 second
```
#### Grammar-Spelling Checking Language-Tool
Install full-version of Language Tool
```
make installlanguagetool
```
Activate it
```
source snippets/functions.sh
languagetool
```
add LanguageTool section from configAdd.el to Emacs config.el  
Emacs use:
```
(langtool-check)
```
#### Local Text Translation
your FROM-TO model is either [here](https://github.com/Helsinki-NLP/Opus-MT-train/tree/master/models) or [here](https://github.com/Helsinki-NLP/Tatoeba-Challenge/tree/master/models)  
example, to get the models I use:
```
make opusInstallExample
```
edit PATH_TO_SUBS/Opus-MT/services.json appropriately, then:
```
make installopus
```
To activate:
```
#opus.sh has commodity functions
source opus.sh
Opus-MT
```
To use: 
```
t "text to translate"
```
### Get Event Timestamps
#### Scene-timestamps
Visual Scene timestamps:
```
make installSceneTimestamps
make sceneTimestamps
```
#### VAD, Speech timestamps
What is VAD? VAD means: Voice Activity Detector  
It gives you the speech timestamps, when human voice is detected  
first install [torch](https://pytorch.org/get-started/locally/), then:
```
make speechTimestamps
```
### Translate the Speakers-Stream
you need to Ctrl-C to stop recording, then it will translate the temporal recording
```
source functions.sh
streamtranslate
```
if you were to have sway, you could put this in your sway config, and have an easy keybinding to translate what you are hearing

```
bindsym $mod+Shift+return exec alacritty -e bash /home/$USER/files/code/anime_translation/snippets/streamtranslate.sh
```
## Dependencies
- Linux, Bash, Mpv, Ffmpeg, Emacs, Subed
- Whatever model you wish to use
- Python if you use the "Get Event Timestamps" things
  - The vad.py thing downloads silero-vad by itself 
- Docker for the LibreGrammar(Language Tool) or the Opus things
- If you want to translate your Speakers, you need pipewire 
  - As commodity, you will need: wl-copy and wl-paste, if running on wayland
    - If you don't want them, remove them from streamtranslate.sh
## Why X
- Why Git over Google-Docs or similar?  
  - Version Control Systems (git) is an ergonomic tool to pick or disregard from contributions, it enables trully parallel work distribution
- Why .vtt over others?  
  - *whisper* can output vtt or srt  
  - *subed* can work with vtt or srt  
  - why vtt over srt? personal choice, but:
    - vtt has no need for numbers as id
    - seems shorter and more efficient
