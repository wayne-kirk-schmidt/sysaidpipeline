# 00_init.bash
# Core initialization + lifecycle control

main() {
    parse_args "$@"
    prepare_root
    prepare_tools
    init_run
    run_pipeline
}

parse_args() {

    VERB="${1:-}"
    shift || true

    case "$VERB" in
        download|extract|assemble|snapshot|process)
            ;;
        --help|-h|"")
            show_help
            exit 0
            ;;
        *)
            echo "Unknown command: $VERB"
            show_help
            exit 1
            ;;
    esac

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --runid)
                RUN_ID="$2"
                shift 2
                ;;
            --tenant)
                TENANT="$2"
                shift 2
                ;;
            --cookie)
                COOKIE="$2"
                shift 2
                ;;
            --tickets)
                TICKETS="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=1
                shift
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

prepare_root() {

    ROOT="/var/tmp/tickets"
    mkdir -p "$ROOT"

    if [[ ! -w "$ROOT" ]]; then
        echo "Root not writable: $ROOT"
        exit 1
    fi
}

init_run() {

    if [[ -z "${RUN_ID:-}" ]]; then
        RUN_ID="$(date +%Y%m%d%H%M)"
    fi

    FINAL_DIR="${ROOT}/${RUN_ID}"

    # Rotate if exists
    if [[ -d "$FINAL_DIR" ]]; then
        BACKUP="${FINAL_DIR}.bak.$(date +%s)"
        echo "Existing run detected. Rotating to $BACKUP"
        mv "$FINAL_DIR" "$BACKUP"
    fi

    # Create staging under ROOT (not FINAL_DIR)
    STAGING_DIR="$(mktemp -d "${ROOT}/.staging.${RUN_ID}.XXXX")"

    PDF_DIR="${STAGING_DIR}/pdf"
    JSON_DIR="${STAGING_DIR}/json"
    CSV_DIR="${STAGING_DIR}/csv"

    mkdir -p "$PDF_DIR" "$JSON_DIR" "$CSV_DIR"

    MANIFEST="${STAGING_DIR}/manifest.${RUN_ID}.json"

    echo '{"run_id":"'${RUN_ID}'","pdf":{},"json":{},"csv":{}}' > "$MANIFEST"

    trap cleanup EXIT
}

cleanup() {
    if [[ -d "${STAGING_DIR:-}" && ! -d "${FINAL_DIR:-}" ]]; then
        echo "Cleaning up staging..."
        rm -rf "$STAGING_DIR"
    fi
}

publish_run() {
    mv "$STAGING_DIR" "$FINAL_DIR"
    echo "Published run: $FINAL_DIR"
}

require_value() {
    var="$1"
    if [[ -z "${!var:-}" ]]; then
        echo "Error: $var is required."
        exit 1
    fi
}

require_dir_nonempty() {
    dir="$1"
    if [[ ! -d "$dir" ]] || [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo "Directory $dir is empty or missing."
        exit 1
    fi
}
