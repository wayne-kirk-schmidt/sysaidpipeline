phase_assemble() {

    echo "Assemble phase starting..."

    require_dir_nonempty "$JSON_DIR"
    require_dir_nonempty "$CFG_DIR"

    for schema_file in "${CFG_DIR}"/*.json; do

        profile="$(basename "$schema_file" .json)"
        output="${CSV_DIR}/${RUN_ID}.report.${profile}.csv"
        tmp_output="${output}.tmp"

        # Read schema fields safely (handles spaces)
        fields=()
        while IFS= read -r line; do
            fields+=("$line")
        done < <(jq -r '.[]' "$schema_file")

        # Build header
        header="ticket_id"
        for field in "${fields[@]}"; do
            header="${header},${field}"
        done

        echo "$header" > "$tmp_output"

        # Process JSON tickets
        for json_file in "${JSON_DIR}"/*.json; do

            ticket="$(basename "$json_file" .json)"
            row="$ticket"

            for field in "${fields[@]}"; do

                value=$(jq -r --arg key "$field" '
                    .records[]
                    | select(.key == $key)
                    | .value
                ' "$json_file" | head -1)

                # Normalize null
                if [[ "$value" == "null" ]]; then
                    value=""
                fi

                # 🔥 CRITICAL FIX FOR THEMES
                # Replace newlines, CR, and tabs with spaces
                value="${value//$'\n'/ }"
                value="${value//$'\r'/ }"
                value="${value//$'\t'/ }"

                # Escape double quotes
                value="${value//\"/\"\"}"

                row="${row},\"${value}\""
            done

            echo "$row" >> "$tmp_output"
        done

        mv "$tmp_output" "$output"
        update_manifest "csv" "$profile" "$output"

        [[ "${VERBOSE:-0}" -eq 1 ]] && echo "Generated CSV: $output"
    done
}

