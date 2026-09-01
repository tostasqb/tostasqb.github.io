#!/usr/bin/env bash
# Render the CV straight from index.html + print.css to a PDF.
#
# This bypasses the browser print dialog, so the page margins always come from
# @page in print.css and can't be overridden by the dialog's "Margins" control.
#
#   ./build-cv.sh            → hugo-bento-cv.pdf
#   ./build-cv.sh out.pdf    → out.pdf

set -euo pipefail

cd "$(dirname "$0")"
out="${1:-hugo-bento-cv.pdf}"

chrome=""
for candidate in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "$(command -v google-chrome || true)" \
  "$(command -v chromium || true)"
do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then chrome="$candidate"; break; fi
done

if [ -z "$chrome" ]; then
  echo "build-cv: no Chrome or Chromium found" >&2
  exit 1
fi

"$chrome" \
  --headless \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$PWD/$out" \
  "file://$PWD/index.html" \
  >/dev/null 2>&1

echo "build-cv: wrote $out"
