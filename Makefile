##
# Anime Translation
#
#
# PATH_TO_WHISPER="/home/tekakutli/code/whisper.cpp"
# PATH_TO_MODELS="/home/tekakutli/files/models"
PATH_TO_SUBS="/home/tekakutli/code/anime_translation"
PATH_TO_SUBED="/home/tekakutli/code/emacs/subed"
VIDEO_TO_SUB="/home/tekakutli/Downloads/torrent/video.mp4"
AUDIO_EXTRACT="/tmp/audio.wav"
LANG_FROM="ja"

PATH_TO_WHISPER="/tmp"
PATH_TO_MODELS="/tmp"

setup:
	bash snippets/setupModel.sh

use:
	bash snippets/modelToText.sh

formatToVtt:
	bash snippets/formatToVtt.sh yourRawTHING.txt

mpv:
	bash snippets/mpvLoadSubs.sh

installffsubsync:
	pip install ffsubsync

autosync:
	bash snippets/autosync.sh

installlanguagetool:
	docker pull registry.gitlab.com/py_crash/docker-libregrammar

installopus:
	bash snippets/installOpus.sh

opusInstallExample:
	bash snippets/opusInstallExample.sh

installSceneTimestamps:
	pip install scenedetect[opencv] --upgrade

sceneTimestamps:
	bash snippets/sceneTimestamps.sh

speechTimestamps:
	bash snippets/speechTimestamps.sh

speakersTranslate:
	bash snippets/streamtranslate.sh

export:
	bash snippets/exportSubs.sh
