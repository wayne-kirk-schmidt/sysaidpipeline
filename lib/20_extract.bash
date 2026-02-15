# 20_extract.bash

phase_extract() {

    echo "Extract phase starting..."

    require_dir_nonempty "$PDF_DIR"

    for f in "${PDF_DIR}"/*.pdf; do

        ticket="$(basename "$f" .pdf)"
        json="${JSON_DIR}/${ticket}.json"
        tmp_json="${json}.tmp"

        [[ "${VERBOSE:-0}" -eq 1 ]] && echo "Extracting $ticket"

        "$PYTHON_BIN" "$SYS_PDF_CMD" \
            --src "$f" \
            --json display records > "$tmp_json"

        if [[ -s "$tmp_json" ]]; then
            mv "$tmp_json" "$json"
            update_manifest "json" "$ticket" "$json"
        else
            echo "Warning: JSON not created or empty for $ticket"
            rm -f "$tmp_json"
        fi
    done
}
