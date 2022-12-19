##
# Anime Translation
#

setup:
	bash snippets/setupModel.sh

installffsubsync:
	pip install ffsubsync

installlanguagetool:
	docker pull registry.gitlab.com/py_crash/docker-libregrammar

installopus:
	bash snippets/installOpus.sh

opusInstallExample:
	bash snippets/opusInstallExample.sh

installSceneTimestamps:
	pip install scenedetect[opencv] --upgrade

functions:
	source snippets/functions.sh; \
	source snippets/opus.sh; \
	source snippets/timeformat.sh
