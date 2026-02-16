#!/usr/bin/env bash
set -euo pipefail

SRC=""
DST=""
KEY=""
MATCH=""
VALUE=""

PYTHON_BIN="${PYTHON_BIN:-python3}"

usage() {
  echo "Usage:"
  echo "  enrichcsv \\"
  echo "    --src <input-dir> \\"
  echo "    --dst <output-dir> \\"
  echo "    --key <column-name> \\"
  echo "    --match <match-value> \\"
  echo "    --value <replace-value>"
  exit 1
}

# -----------------------------
# Parse Args
# -----------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --src)    SRC="$2"; shift 2 ;;
    --dst)    DST="$2"; shift 2 ;;
    --key)    KEY="$2"; shift 2 ;;
    --match)  MATCH="$2"; shift 2 ;;
    --value)  VALUE="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; usage ;;
  esac
done

[[ -z "$SRC" || -z "$DST" || -z "$KEY" || -z "$MATCH" || -z "$VALUE" ]] && usage
[[ ! -d "$SRC" ]] && { echo "ERROR: Source directory missing"; exit 1; }

# -----------------------------
# Rotate Output Directory
# -----------------------------
if [[ -d "$DST" ]]; then
    TS=$(date +"%Y%m%d_%H%M%S")
    echo "Target exists. Moving to ${DST}_${TS}"
    mv "$DST" "${DST}_${TS}"
fi

mkdir -p "$DST"

# -----------------------------
# Process CSV Files
# -----------------------------
shopt -s nullglob
FILES=("$SRC"/*.csv)

[[ ${#FILES[@]} -eq 0 ]] && { echo "ERROR: No CSV files found"; exit 1; }

TOTAL=0

for csv_file in "${FILES[@]}"; do

    base="$(basename "$csv_file")"
    output="${DST}/${base}"
    tmp_output="${output}.tmp"

    echo "Processing $base"

    "$PYTHON_BIN" - "$KEY" "$MATCH" "$VALUE" "$csv_file" "$tmp_output" <<'PYCODE'
import csv
import sys

key = sys.argv[1]
match = sys.argv[2]
value = sys.argv[3]
input_file = sys.argv[4]
output_file = sys.argv[5]

with open(input_file, newline='', encoding='utf-8') as infile:
    reader = csv.reader(infile)
    header = next(reader)

    column_exists = key in header

    if not column_exists:
        header.append(key)
        col_index = len(header) - 1
    else:
        col_index = header.index(key)

    with open(output_file, 'w', newline='', encoding='utf-8') as outfile:
        writer = csv.writer(outfile)
        writer.writerow(header)

        for row in reader:
            if column_exists:
                if col_index < len(row) and row[col_index] == match:
                    row[col_index] = value
            else:
                row.append(value)

            writer.writerow(row)
PYCODE

    if [[ -s "$tmp_output" ]]; then
        mv "$tmp_output" "$output"
        ((TOTAL++))
    else
        echo "Warning: Failed to process $base"
        rm -f "$tmp_output"
    fi

done

echo "Processed $TOTAL CSV files"
echo "Output directory: $DST"
echo "Done."
