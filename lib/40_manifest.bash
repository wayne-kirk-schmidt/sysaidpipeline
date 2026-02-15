# 40_manifest.bash
# Manifest management (root-relative paths only)

update_manifest() {

    local section="$1"
    local key="$2"
    local absolute_path="$3"

    local relative_path
    relative_path="${absolute_path#${STAGING_DIR}/}"

    local tmp="${MANIFEST}.tmp"

    jq \
        --arg sec "$section" \
        --arg key "$key" \
        --arg file "$relative_path" \
        '.[$sec][$key] = $file' \
        "$MANIFEST" > "$tmp"

    mv "$tmp" "$MANIFEST"
}

