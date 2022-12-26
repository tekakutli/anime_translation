#!/usr/bin/env bash

set -eu

# Given an input file in video format, create a file with the audio contents of that file.
#
# Usage:
#   extract_audio "$INPUT_VIDEO_FILE" "$OUTPUT_AUDIO_FILE"
#
# Creates a file at "$OUTPUT_AUDIO_FILE" with the audio content of "$INPUT_VIDEO_FILE" in WAV format.
extract_audio() {
    echo "Extracting audio from $1..."
    ffmpeg -y -loglevel quiet -i "$1" -ar 16000 -c:a pcm_s16le "$2"
}

# Using whisper, generate english subtitles translated from japanese audio.
#
# Usage:
#   generate_english_subtitles \
#     "$WHISPER_CPP" \
#     "$MODEL" \
#     "$INPUT_AUDIO_FILE" \
#     "$OUTPUT_SUBTITLE_FILE"
#
# Creates a file at "$OUTPUT_SUBTITLE_FILE" with subtitles representing the audio in "$INPUT_AUDIO_FILE" in VTT format.
generate_english_subtitles() {
    echo "Generating english subtitles from $3 using model $2"

    "$1/main" \
        -ovtt -l ja -tr \
        -m "$1/models/ggml-$2.bin" \
        -f "$3"

    # Whisper.cpp doesn't have an output file option, move it ourselves
    mv "$3.vtt" "$4"
}

# Using whisper, generate japanese subtitles transcribed from japanese audio.
#
# Usage:
#   generate_japanese_subtitles \
#     "$WHISPER_CPP" \
#     "$MODEL"
#     "$INPUT_AUDIO_FILE" \
#     "$OUTPUT_SUBTITLE_FILE"
#
# Creates a file at "$OUTPUT_SUBTITLE_FILE" with subtitles representing the audio in "$INPUT_AUDIO_FILE" in VTT format.
generate_japanese_subtitles() {
    echo "Generating japanese subtitles from $3 using model $2..."

    "$1/main" \
        -ovtt -l ja -su \
        -m "$1/models/ggml-$2.bin" \
        -f "$3"

    # Whisper.cpp doesn't have an output file option, move it ourselves
    mv "$3.vtt" "$4"
}

# Using ffsubsync, synchronise subtitles to a video.
#
# Usage:
#   synchronise_subtitles \
#     "$INPUT_VIDEO_FILE" \
#     "$INPUT_UNSYNCHONISED_NATIVE" \
#     "$INPUT_UNSYNCHONISED_TRANSLATED" \
#     "$OUTPUT_SYNCHRONISED_NATIVE" \
#     "$OUTPUT_SYNCHRONISED_TRANSLATED"
synchronise_subtitles() {
    input_video="$1"
    input_us_native="$2"
    input_us_translated="$3"
    output_native="$4"
    output_translated="$5"

    echo "Synchronising subtitles $input_us_translated to video $input_video"
    
    # Convert VTT inputs to SRT for ffsubsync to work with them
    ffmpeg -y -loglevel quiet -i "$input_us_native" "$input_us_native.srt"
    ffmpeg -y -loglevel quiet -i "$input_us_translated" "$input_us_translated.srt"

    # Synchronise subtitles with ffsubsync
    ffsubsync "$input_video" --max-offset-seconds .1 --gss -i "$input_us_native.srt" -o "$output_native.srt"
    ffsubsync "$output_native.srt" --max-offset-seconds .1 -i "$input_us_translated.srt" -o "$output_translated.srt"

    # Convert result back to VTT
    ffmpeg -y -loglevel quiet -i "$output_translated.srt" "$output_translated"
}

# Overlay subtitles onto an existing video file.
#
# Usage:
#   overlay_subtitles "$INPUT_VIDEO_FILE" "$INPUT_SUBTITLES_FILE" "$OUTPUT_VIDEO_FILE"
overlay_subtitles() {
    echo "Overlaying subtitles $2 onto video $1..."
    ffmpeg -y -loglevel quiet -i "$1" -i "$2" -c copy -c:s mov_text "$3"
}

# Display a help message for this program.
show_help() {
    cat <<EOF
$0: Automatically add subtitles to anime from raw video.

Usage: $0 [ options ] input_file

Options:
    -h           Show this help and exit
    -o outfile   Write output video to outfile
    -s value     Synchronise subtitles using the provided model, or don't synchronise if value is off.
                   (off, tiny, base, small (default), medium, large)
    -m value     Specify the model to use when extracting subtitles from the raw audio.
                   (tiny, base, small, medium, large (default))
    -t dir       Generate intermediary files in dir and do not delete dir once work is done
    -w dir       Specify the location of the whisper.cpp clone to use.
EOF
}

# Download the requested model if needed.
#
# Usage:
#   download_model "$WHISPER_CPP" "$MODEL"
download_model() {
    echo "Downloading model $2..."
    bash "$1/models/download-ggml-model.sh" $2
}

# Ensure whisper.cpp is installed and ready.
#
# Usage:
#   ensure_whisper_cpp "$WISPER_CPP_PATH"
ensure_whisper_cpp() {
    needs_compile=1

    mkdir -p "$1"
    pushd "$1"

    if [[ -z "$(ls -A .)" ]]; then
        echo "Downloading whisper.cpp..."
        git clone "https://github.com/ggerganov/whisper.cpp.git" .
        needs_compile=0
    else
        echo "Checking for whisper.cpp updates..."

        # Don't fail if offline
        git fetch || return 0
        if [[ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]]; then
            echo "Updating whisper.cpp..."
            git pull
            needs_compile=0
        fi
    fi

    if [[ needs_compile || (! -x "$1/main") ]]; then
        echo "Compiling whisper.cpp..."
        make
    fi

    popd
}

main() {
    # Parse arguments
    output_file=
    model=large
    synchronization=small
    temp_dir=
    delete_temp_dir=0
    whisper_cpp="$(dirname "$(realpath $0)")/whisper.cpp"

    script_args=()
    while [[ $OPTIND -le "$#" ]]; do
        if getopts "o:s:t:m:w:h" option; then
            case $option in
                o) output_file="$OPTARG";;
                s) synchronization="$OPTARG";;
                t)
                    temp_dir="$OPTARG"
                    delete_temp_dir=1
                    ;;
                m) model="$OPTARG";;
                w) whisper_cpp="$OPTARG";;
                h | *)
                    show_help
                    exit 0
                    ;;
            esac
        else
            script_args+=("${!OPTIND}")
            ((OPTIND++))
        fi
    done

    if [[ ${#script_args[@]} -eq 0 || -z "${script_args[0]}" ]]; then
        echo "No input file provided"
        show_help
        exit 1
    fi

    input_file="${script_args[0]}"
    echo "Input file: $input_file"

    if [[ -z $output_file ]]; then
        output_file="${input_file%.*}_subbed.${input_file##*.}"
    fi

    echo "Output will be written to: $output_file"

    # Download & compile whisper.cpp and required models if needed
    ensure_whisper_cpp "$whisper_cpp"
    download_model "$whisper_cpp" "$model"
    if [[ "$synchronization" != "off" ]]; then
        download_model "$whisper_cpp" "$synchronization"
    fi

    # Create a directory for us to work in if none was specified.
    if [[ -z $temp_dir ]]; then
        temp_dir=`mktemp -d "tmp_$(basename $input_file).XXXX"`
    fi

    # Extract audio from video file for processing with whisper
    extract_audio "$input_file" "$temp_dir/audio.wav"

    # Generate unsynchronised english subtitles
    subtitles="$temp_dir/unsynchronised_english.vtt"
    generate_english_subtitles "$whisper_cpp" "$model" "$temp_dir/audio.wav" "$subtitles"

    if [[ "$synchronization" != "off" ]]; then
        # Generate unsynchronised japanese subtitles
        generate_japanese_subtitles \
            "$whisper_cpp" \
            "$synchronization" \
            "$temp_dir/audio.wav" \
            "$temp_dir/unsynchronised_japanese.vtt"

        # Synchronise subtitles
        subtitles="$temp_dir/synchronised_english.vtt"
        synchronise_subtitles \
            "$input_file" \
            "$temp_dir/unsynchronised_japanese.vtt" \
            "$temp_dir/unsynchronised_english.vtt" \
            "$temp_dir/synchronised_japanese.vtt" \
            "$subtitles"
    fi

    # Overlay subtitles
    overlay_subtitles "$input_file" "$subtitles" "$output_file"

    if [[ $delete_temp_dir ]]; then
        rm -r $temp_dir
    fi
}

trap "exit" INT
main "$@"
