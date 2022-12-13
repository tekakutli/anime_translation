#!/usr/bi/env python3
import torch
import sys
torch.set_num_threads(1)

from IPython.display import Audio
from pprint import pprint
model, utils = torch.hub.load(repo_or_dir='snakers4/silero-vad',
                              model='silero_vad',
                              force_reload=True)

(get_speech_timestamps,
 _, read_audio,
 *_) = utils

sampling_rate = 16000 # also accepts 8000
wav = read_audio(sys.argv[1], sampling_rate=sampling_rate)
# get speech timestamps from full audio file
speech_timestamps = get_speech_timestamps(wav, model, sampling_rate=sampling_rate, return_seconds=True)
pprint(speech_timestamps)
