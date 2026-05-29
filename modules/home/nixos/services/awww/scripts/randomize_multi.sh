# For each display, changes the wallpaper to a randomly chosen image in
# a given directory at a set interval.
set -e

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
RESIZE_TYPE="${RESIZE_TYPE:-crop}"
INTERVAL="${1:-${INTERVAL:-300}}"

while true; do
	find "$WALLPAPER_DIR" -type f \
	| shuf \
	| while read -r img; do
		for d in $(awww query | awk '{print $2}' | sed 's/://'); do # see awww-query(1)
			# Get next random image for this display, or re-shuffle images
			# and pick again if no more unused images are remaining
			[ -z "$img" ] && if read -r img; then true; else break 2; fi
			awww img --resize "$RESIZE_TYPE" --outputs "$d" "$img"
			unset -v img # Each image should only be used once per loop
		done
		sleep "${2:-$INTERVAL}"
	done
done
