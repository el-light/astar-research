#!/usr/bin/env bash
# Serve the animated defence deck on this machine only.
#
#   ./scripts/serve_slides.sh          # http://localhost:8000
#   ./scripts/serve_slides.sh 9000     # another port
#   OPEN=1 ./scripts/serve_slides.sh   # also open it in the default browser
#
# The deck is one HTML file with its fonts next to it (slides/web/), so it
# needs no internet connection.  Keys: arrows/space = next, F = fullscreen,
# R = replay the animation, #slide-N in the URL jumps to a slide.
set -euo pipefail

PORT="${1:-8000}"
cd "$(dirname "$0")/../slides/web"
URL="http://localhost:${PORT}/"

echo "Defence deck: ${URL}   (Ctrl+C to stop)"
if [[ "${OPEN:-0}" == "1" ]]; then
    if command -v open >/dev/null 2>&1; then (sleep 1 && open "$URL") &
    elif command -v xdg-open >/dev/null 2>&1; then (sleep 1 && xdg-open "$URL") &
    fi
fi
exec python3 -m http.server "$PORT" --bind 127.0.0.1
