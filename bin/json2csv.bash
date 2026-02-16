#!/usr/bin/env bash
set -euo pipefail

JSON_DIR=""
CSV_DIR=""
PROFILE=""
MAX_LINES=""

usage() {
  echo "Usage:"
  echo "  json2csv --json-dir <dir> --csv-dir <dir> --profile <schema.json> [--max-lines N]"
  exit 1
}

# -----------------------------
# Parse Args
# -----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json-dir) JSON_DIR="$2"; shift 2 ;;
    --csv-dir)  CSV_DIR="$2"; shift 2 ;;
    --profile)  PROFILE="$2"; shift 2 ;;
    --max-lines) MAX_LINES="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; usage ;;
  esac
done

[[ -z "$JSON_DIR" || -z "$CSV_DIR" || -z "$PROFILE" ]] && usage

# -----------------------------
# Validate Source
# -----------------------------
[[ ! -d "$JSON_DIR" ]] && { echo "ERROR: JSON dir missing"; exit 1; }
[[ ! -f "$PROFILE" ]] && { echo "ERROR: Profile missing"; exit 1; }

# -----------------------------
# Backup Target Directory
# -----------------------------
if [[ -d "$CSV_DIR" ]]; then
    TS=$(date +"%Y%m%d_%H%M%S")
    echo "Target exists. Moving to ${CSV_DIR}_${TS}"
    mv "$CSV_DIR" "${CSV_DIR}_${TS}"
fi
mkdir -p "$CSV_DIR"

# -----------------------------
# Load Schema Fields (same method)
# -----------------------------
fields=()
while IFS= read -r line; do
    fields+=("$line")
done < <(jq -r '.[]' "$PROFILE")

[[ ${#fields[@]} -eq 0 ]] && { echo "ERROR: Empty schema"; exit 1; }

# -----------------------------
# Streaming Setup
# -----------------------------
ROW_LIMIT="${MAX_LINES:-0}"
ROW_COUNT=0
FILE_INDEX=1
CURRENT_FILE=""
TS=$(date +"%Y%m%d_%H%M%S")

create_new_file() {
    local filename
    filename=$(printf "%s/tickets_%s_%03d.csv" "$CSV_DIR" "$TS" "$FILE_INDEX")
    CURRENT_FILE="$filename"

    header="ticket_id"
    for field in "${fields[@]}"; do
        header="${header},${field}"
    done

    echo "$header" > "$CURRENT_FILE"
    ROW_COUNT=0
}

TOTAL=0
shopt -s nullglob
FILES=("$JSON_DIR"/*.json)

[[ ${#FILES[@]} -eq 0 ]] && { echo "ERROR: No JSON files found"; exit 1; }

# -----------------------------
# Main Loop (Same Extraction Logic)
# -----------------------------
for json_file in "${FILES[@]}"; do

    if [[ "$ROW_LIMIT" -gt 0 ]]; then
        [[ "$ROW_COUNT" -eq 0 ]] && create_new_file
    else
        [[ -z "$CURRENT_FILE" ]] && create_new_file
    fi

    ticket="$(basename "$json_file" .json)"
    row="$ticket"

    for field in "${fields[@]}"; do

        value=$(jq -r --arg key "$field" '
            .records[]
            | select(.key == $key)
            | .value
        ' "$json_file" | head -1)

        # Normalize null
        [[ "$value" == "null" ]] && value=""

        # Same sanitization as your library script
        value="${value//$'\n'/ }"
        value="${value//$'\r'/ }"
        value="${value//$'\t'/ }"
        value="${value//\"/\"\"}"

        row="${row},\"${value}\""
    done

    echo "$row" >> "$CURRENT_FILE"

    ((ROW_COUNT++))
    ((TOTAL++))

    if [[ "$ROW_LIMIT" -gt 0 && "$ROW_COUNT" -ge "$ROW_LIMIT" ]]; then
        ((FILE_INDEX++))
        ROW_COUNT=0
    fi

done

echo "Processed $TOTAL tickets"
echo "Output directory: $CSV_DIR"
echo "Done."

