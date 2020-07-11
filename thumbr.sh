#!/bin/sh
{ usage="$(cat)"; }<<'EOF'
USAGE
    thumbr.sh [OPTIONS] <path>

DESCRIPTION
    Recursively searches through the passed path, ignoring existing thumbnails,
    and generates thumbnails for images greater than 600px in width.

OPTIONS
    -h, --help         Shows this help prompt
    -w, --width        Width threshold and dirname (default: 500px, 'w_500')
    -d, --dry-run      Dry-run that will not create actual thumbnails
EOF

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

show_help() {
    printf '%s\n' "$usage"
    exit
}

# Defaults
WIDTH=500

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
        -w|--width)
            if [ "$2" ]; then
                WIDTH=$2
                shift
            else
                die 'ERROR: "--host" requires a non-empty option argument!'
            fi
            ;;
        -d|--dry-run)
            DRYRUN=1
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            if [ "$1" ]; then
                BROWSE_PATH=$(printf "%s" "$1" | sed 's|/*$||g')
            else
                break
            fi
            ;;
    esac

    shift
done

if [ ! -d "$BROWSE_PATH" ]; then
    die 'ERROR: path not specified or not a directory! (See -h/--help)'
fi

CONVERT=$(command -v convert)
if [ ! "$CONVERT" ]; then
    printf "ERROR: imagemagick must be installed!\n"
    exit 1
fi

find "$BROWSE_PATH" -type f -not -path '*w_500*' -exec file {} \; | grep -o -P '^.+: \w+ image' | sed 's/\:.&$//g' | while read i; do
    # Create the thumbnail image
    RESIZE_IMG="$(printf "%s" "$i" | sed 's|'$BROWSE_PATH'/*||g;')"
    THUMB_PATH="$BROWSE_PATH/w_$WIDTH"

    RESIZE_IMG_PATH="$THUMB_PATH/$(dirname $RESIZE_IMG)"

    # Create the thumbnail directory fo the image to be made
    if [ ! -d "$RESIZE_IMG_PATH" ]; then
        printf "! Making directory: %s\n" "$RESIZE_IMG_PATH"
        if [ ! "$DRYRUN" ]; then
            mkdir -p "$RESIZE_IMG_PATH"
        fi
    fi

    if [ ! -f "$THUMB_PATH/$RESIZE_IMG" ]; then
        printf "└─ Converting %s to thumbnail in %s/%s \n" "$i" "$THUMB_PATH" "$RESIZE_IMG"
        if [ ! "$DRYRUN" ]; then
            "$CONVERT" -resize ${WIDTH}x "$i" "$THUMB_PATH/$RESIZE_IMG";
        fi
    fi
done