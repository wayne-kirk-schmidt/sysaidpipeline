#!/usr/bin/env bash
set -euo pipefail

PDF_DIR=""
JSON_DIR=""
SYS_PDF_CMD=""

# Default python
PYTHON_BIN="${PYTHON_BIN:-python3}"

usage() {
  echo "Usage:"
  echo "  pdf2json --pdf-dir <dir> --json-dir <dir> --sys-pdf-cmd <script>"
  exit 1
}

# -----------------------------
# Parse Args
# -----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --pdf-dir)     PDF_DIR="$2"; shift 2 ;;
    --json-dir)    JSON_DIR="$2"; shift 2 ;;
    --sys-pdf-cmd) SYS_PDF_CMD="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; usage ;;
  esac
done

[[ -z "$PDF_DIR" || -z "$JSON_DIR" || -z "$SYS_PDF_CMD" ]] && usage

# -----------------------------
# Validate Inputs
# -----------------------------
[[ ! -d "$PDF_DIR" ]] && { echo "ERROR: PDF dir missing"; exit 1; }
[[ ! -f "$SYS_PDF_CMD" ]] && { echo "ERROR: SYS_PDF_CMD missing"; exit 1; }

# -----------------------------
# Rotate Target Directory
# -----------------------------
if [[ -d "$JSON_DIR" ]]; then
    TS=$(date +"%Y%m%d_%H%M%S")
    echo "Target exists. Moving to ${JSON_DIR}_${TS}"
    mv "$JSON_DIR" "${JSON_DIR}_${TS}"
fi

mkdir -p "$JSON_DIR"

# -----------------------------
# Process PDFs
# -----------------------------
TOTAL=0
FAILED=0

shopt -s nullglob
FILES=("$PDF_DIR"/*.pdf)

[[ ${#FILES[@]} -eq 0 ]] && { echo "ERROR: No PDF files found"; exit 1; }

for f in "${FILES[@]}"; do

    ticket="$(basename "$f" .pdf)"
    json="${JSON_DIR}/${ticket}.json"
    tmp_json="${json}.tmp"

    echo "Extracting $ticket"

    if "$PYTHON_BIN" "$SYS_PDF_CMD" \
        --src "$f" \
        --json display records > "$tmp_json"; then

        if [[ -s "$tmp_json" ]]; then
            mv "$tmp_json" "$json"
            ((TOTAL++))
        else
            echo "Warning: JSON empty for $ticket"
            rm -f "$tmp_json"
            ((FAILED++))
        fi
    else
        echo "Warning: Extraction failed for $ticket"
        rm -f "$tmp_json"
        ((FAILED++))
    fi

done

echo "Processed $TOTAL PDFs"
echo "Failed $FAILED"
echo "Output directory: $JSON_DIR"
echo "Done."
