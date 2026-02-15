# 50_snapshot.bash

phase_snapshot() {

    echo "Snapshot phase starting..."

    require_dir_nonempty "$STAGING_DIR"
    require_value MANIFEST

    if [[ ! -s "$MANIFEST" ]]; then
        echo "Manifest missing or empty."
        exit 1
    fi

    [[ "${VERBOSE:-0}" -eq 1 ]] && echo "Publishing run..."

    publish_run
}
