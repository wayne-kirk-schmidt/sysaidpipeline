# 03_contract.bash

is_interactive() {
    [[ -t 0 && -t 1 ]]
}

require_value() {
    local var="$1"
    if [[ -z "${!var:-}" ]]; then
        echo "Error: $var is required."
        exit 1
    fi
}

ensure_value() {
    local var="$1"
    local prompt="$2"

    if [[ -n "${!var:-}" ]]; then
        return 0
    fi

    if is_interactive; then
        read -rp "$prompt: " value
        if [[ -z "$value" ]]; then
            echo "Error: $var is required."
            exit 1
        fi
        export "$var=$value"
    else
        echo "Error: $var is required."
        exit 1
    fi
}

ensure_secret() {
    local var="$1"
    local prompt="$2"

    if [[ -n "${!var:-}" ]]; then
        return 0
    fi

    if is_interactive; then
        read -rsp "$prompt: " value
        echo
        if [[ -z "$value" ]]; then
            echo "Error: $var is required."
            exit 1
        fi
        export "$var=$value"
    else
        echo "Error: $var is required."
        exit 1
    fi
}
