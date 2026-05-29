set -e

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
RESIZE_TYPE="${RESIZE_TYPE:-crop}"
INTERVAL="${INTERVAL:-300}"

while true; do
	find "$WALLPAPER_DIR" -type f \
	| shuf \
	| while read -r img; do
		awww img --resize="$RESIZE_TYPE" "$img"
		sleep "$INTERVAL"
	done
done
