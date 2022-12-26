# Anime Translation Initiative
AI-helped transcription and translation, fully offline.

## Quick start
Ensure you have the dependencies installed:
- `ffmpeg`, for extracting audio from & overlaying subtitles onto video.
- `ffsubsync`, for synchronising subtitles to video. Can be skipped with `-s off`, and installed with `pip install ffsubsync`.
- `git`, `make`, a C compiler and a C++ compiler, for downloading and compiling whisper.cpp.
- `wget` or `curl`, for downloading the models to be used with whisper.cpp.

Then, use the provided `translate.sh` script:
```
$ ./translate.sh -h
./translate.sh: Automatically add subtitles to anime from raw video.

Usage: ./translate.sh [ options ] input_file

Options:
    -h           Show this help and exit
    -o outfile   Write output video to outfile
    -s value     Synchronise subtitles using the provided model, or don't synchronise if value is off.
                   (off, tiny, base, small (default), medium, large)
    -m value     Specify the model to use when extracting subtitles from the raw audio.
                   (tiny, base, small, medium, large (default))
    -t dir       Generate intermediary files in dir and do not delete dir once work is done
    -w dir       Specify the location of the whisper.cpp clone to use.
```

## Manual translation & extra features

### Dependencies
The dependencies in `Quick Start` are also needed.
- Bash, MPV, ffmpeg and python3 for basic usage
- emacs and subed for manually editing subtitles
- Docker and docker-compose for grammar checking and Opus-MT
- Pipewire, wl-copy and wl-paste for live speaker translation
  - wl-copy and wl-paste are "optional" and can be removed from `snippets/streamtranslate.sh` if needed.

### Usage
First, edit `snippets/environmentvariables.sh` with the appropriate values for your setup.

Then, source the snippet files to load the helper functions into your shell:
```bash
$ source snippets/enviromentvariables.sh
$ source snippets/functions.sh
$ source snippets/opus.sh
$ source snippets/timeformat.sh
```

#### General workflow
This is a quick overview, you can find out more by reading about the tools used on their own websites:
- [whisper.cpp](https://github.com/ggerganov/whisper.cpp), a more performant C++ port of [OpenAI Whisper](https://github.com/openai/whisper)
- [ffmpeg](https://ffmpeg.org/), a tool for manipulating video & video related file formats
- [emacs](https://www.gnu.org/software/emacs/) and its [subed plugin](https://github.com/sachac/subed)
- [Docker](https://www.docker.com/) and [Pipewire](https://pipewire.org/)

##### Step 1 (setup, can be skipped on future runs): Setup whisper.cpp
Download and compile [whisper.cpp](https://github.com/ggerganov/whisper.cpp):
```bash
$ git clone https://github.com/ggerganov/whisper.cpp
$ cd whisper.cpp
$ make
```

Download the models we will use to transcribe/translate our video:
```
$ bash models/download_ggml_model.sh <model>
```
Where `<model>` is the model you want to download. Run the script without specifying a model to see a list of available models, but don't download one of the ones suffixed with `.en` as they cannot perform translation.

Information about model size and memory usage can be found [here](https://github.com/ggerganov/whisper.cpp#memory-usage).

I recommend using the `large` model for the best results. If you're going to synchronise the subtitles, you should also download the `small` model as synchronisation doesn't need precise subtitles.

##### Step 2: Prepare input data
Get a hold of the raw video you want to translate. The format doesn't matter as long as it is supported by ffmpeg, and I will be referring to it as `input.mp4` from here on.

Extract the audio from it in WAV format for whisper.cpp to process:
```bash
$ ffmpeg -i input.mp4 -ar 16000 -ac 1 -c:a pcm_s16le input_audio.wav
```

##### Step 3: Generate subtitles
Using whisper, generate translated subtitles from the input audio:
```bash
$ whisper.cpp/main \
    -m whisper.cpp/models/ggml-<model>.bin \
    -l ja \
    -tr \
    -ovtt \
    -f input_audio.wav
$ mv input_audio.wav.vtt english.vtt
```
Where `<model>` is the model you downloaded earlier to extract subtitles.

This step can take a while depending on your hardware and chosen model. Setting `--threads n` and `--processors n` to match your PC's specs can help a lot.

Whisper can break with music segments, and sometimes starts repeating its output. If that happens, interrupt the process and copy the output in the terminal. You can then format it using the `formatToVtt <file>` helper, which converts the whisper.cpp terminal output in `<file>` to VTT format in `<file>.vtt`. You can then manually merge all the converted segments later.

Once you've converted the terminal output, resume whisper with the `-ot <millis>` flag at the point it left off.

##### Step 4 (optional): Synchronise subtitles
Sometimes, whisper's subtitles aren't completely synchronised with the video. If that happens, we can use `ffsubsync` to synchronise them.

First, generate a japanese transcription of the video for ffsubsync to use:
```bash
$ whisper.cpp/main \
    -m whisper.cpp/models/ggml-<model>.bin \
    -l ja \
    -su \
    -ovtt \
    -f input_audio.wav
$ mv input_audio.wav.vtt japanese.vtt
```
Where `<model>` is the model you downloaded for subtitle synchronisation. Notice that the `-tr` flag is removed from the command we used earlier, and that the `-su` flag is added - this speeds up conversion at the cost of accuracy, which we don't need as long as the subtitles are phonetically close to the raw video.

Convert the english and japanese VTT files to SRT for ffsubsync to use:
```bash
$ ffmpeg -i english.vtt english.srt
$ ffmpeg -i japanese.vtt japanese.srt
```

Using ffsubsync, first synchronise our japanese subtitles to the video, then our english subtitles to the japanese subtitles:
```bash
$ ffsubsync input.mp4 --max-offset-seconds .1 --gss -i japanese.srt -o japanese_synchronised.srt
$ ffsubsync japanese_synchronised.srt --max-offset-seconds -i english.srt -o english_synchronised.srt
```

Finally, convert the result back to VTT:
```bash
$ ffmpeg -i english_synchronised.srt english_synchronised.vtt
```

##### Step 5 (optional): Manually correct subtitles
This step is opinionated. You can manually adjust the `english_synchronised.vtt` file however you like.

###### Subed
I use *subed*:
```bash
$ git clone https://github.com/sachac/subed  
```
Add *Subed* from *configAdd.el* to Emacs *config.el*:
alternatively, add this extra:
```bash
$ git clone https://gist.github.com/mooseyboots/d9a183795e5704d3f517878703407184  
```
Add *Subed Extra Section* from *configAdd.el* to Emacs *config.el*  

Subed allows us to:
- Watch where are captioning in MPV
- Efficiently move, merge, split the timestamps, with precision.

###### Language-Tool
Install full-version of Language Tool:
```bash
$ make installlanguagetool
```
Activate it:
```bash
$ languagetool
```

Add LanguageTool section from configAdd.el to Emacs config.el  
Emacs use:
```
(langtool-check)
```

#### Viewing & exporting subtitles
We can use MPV to preview our created subtitles without exporting them:
```bash
$ mpv --sub-file="<subs>" input.mp4
```
Where `<subs>` is the final subtitles file.

Finally, we can use ffmpeg to export our subtitles + input video into a single output video:
```bash
$ ffmpeg i- input.mp4 -i "<subs>" -c copy -c:s mov_text output.mp4
```
Where `<subs>` is the final subtitles file.

### Extra tools
#### Local Text Translation
The Opus Model is a text-to-text translator model, like Google-Translate.

Your FROM-TO model is either [here](https://github.com/Helsinki-NLP/Opus-MT-train/tree/master/models) or [here](https://github.com/Helsinki-NLP/Tatoeba-Challenge/tree/master/models)  
As an example, to get the models I use:
```bash
$ make opusInstallExample
```

Edit `$PATH_TO_SUBS/Opus-MT/services.json` appropriately, then:
```bash
$ make installopus
```

To activate:
```bash
# opus.sh has commodity functions
$ Opus-MT
```
To use: 
```bash
$ t "text to translate"
```

#### Get Event Timestamps
##### Scene-timestamps
Visual Scene timestamps:
```bash
$ make installSceneTimestamps
$ sceneTimestamps
```

##### VAD, Speech timestamps
What is VAD? VAD means: Voice Activity Detector  
It gives you the speech timestamps, when human voice is detected  
first install [torch](https://pytorch.org/get-started/locally/), then:
```bash
$ speechTimestamps
```

#### Translate your Speakers
You'll need to Ctrl-C to stop recording, after which it will translate the temporal recording:
```bash
$ streamtranslate
```

Ff you are using sway, you can put this in your sway config, and have an easy keybind to translate what you are hearing:
```
bindsym $mod+Shift+return exec alacritty -e bash /home/$USER/files/code/anime_translation/snippets/streamtranslate.sh
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
