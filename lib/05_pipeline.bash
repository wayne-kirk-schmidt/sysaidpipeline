# 05_pipeline.bash
# Phase dispatcher

run_pipeline() {

    local phases=("download" "extract" "assemble")

    # If explicitly snapshot
    if [[ "$VERB" == "snapshot" ]]; then
        [[ "${VERBOSE:-0}" -eq 1 ]] && echo "==> Running phase_snapshot"
        phase_snapshot
        return
    fi

    local target_index=-1

    # Determine how far to run
    for i in "${!phases[@]}"; do
        if [[ "${phases[$i]}" == "$VERB" ]]; then
            target_index="$i"
            break
        fi
    done

    if [[ "$target_index" -lt 0 ]]; then
        echo "Unknown pipeline verb: $VERB"
        exit 1
    fi

    # Execute dependent phases in order
    for i in "${!phases[@]}"; do
        local phase="phase_${phases[$i]}"

        if [[ "${VERBOSE:-0}" -eq 1 ]]; then
            echo "==> Running $phase"
        fi

        if ! declare -f "$phase" >/dev/null 2>&1; then
            echo "Error: $phase is not defined."
            exit 1
        fi

        "$phase"

        if [[ "$i" -eq "$target_index" ]]; then
            break
        fi
    done

    # Finalize run
    [[ "${VERBOSE:-0}" -eq 1 ]] && echo "==> Running phase_snapshot"
    phase_snapshot
}
