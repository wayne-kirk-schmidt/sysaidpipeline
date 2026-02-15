# 10_download.bash

phase_download() {

    echo "Download phase starting..."

    # Contract enforcement
    require_value TENANT
    require_value COOKIE
    require_value TICKETS

    prepare_tools

    # Support comma-separated tickets
    IFS=',' read -ra ticket_array <<< "$TICKETS"

    for ticket in "${ticket_array[@]}"; do

        if [[ "${VERBOSE:-0}" -eq 1 ]]; then
            echo "Downloading ticket: $ticket"
            verbose_flag="--verbose"
        else
            verbose_flag=""
        fi

        "$PYTHON_BIN" "$SYS_TICKET_CMD" \
            --cookie "$COOKIE" \
            --tenant "$TENANT" \
            --ticket "$ticket" \
            --dst "$PDF_DIR" \
            $verbose_flag \
            --sleep 3 \
            --workers 3

        # Register downloaded PDF
        pdf_file="${PDF_DIR}/${ticket}-report.pdf"

        if [[ -f "$pdf_file" ]]; then
            update_manifest "pdf" "$ticket" "$pdf_file"
        else
            echo "Warning: Expected PDF not found for ticket $ticket"
        fi

    done
}

