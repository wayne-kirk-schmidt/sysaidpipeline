# 02_tools.bash
# External command wiring (baby-step version)

prepare_tools() {

    TOOLS_DIR="/Users/waynekirkschmidt/Downloads"

    # SysAid ticket downloader (PDF)
    SYS_TICKET_CMD="${TOOLS_DIR}/sysaidticketget/bin/sysaidticketget.py"

    # PDF → JSON extractor
    SYS_PDF_CMD="${TOOLS_DIR}/sysaidpdfview/sysaidpdfview.py"

    # Python interpreter
    PYTHON_BIN="python3"

    # Validate
    for tool in "$SYS_TICKET_CMD" "$SYS_PDF_CMD"; do
        if [[ ! -f "$tool" ]]; then
            echo "Missing required tool: $tool"
            exit 1
        fi
    done
}
