#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

umask 022

show_help() {
cat <<'EOF'

Exaplanation: sysaidpipeline is designed to coordinate SysAid ticket processing

Usage:
  $ bash sysaidpipeline.bash {download|extract|assemble|snapshot|process} [options]

Style:
  Google Shell Style Guide:
  https://google.github.io/styleguide/shellguide.html

  @name           sysaidpipeline
  @version        0.7.0
  @author-name    Wayne Kirk Schmidt
  @author-email   wayne.kirk.schmidt@gmail.com

Options:
  --runid <value>
  --verbose
  --help

EOF
}

VERSION="0.7.0"
AUTHOR="Wayne Kirk Schmidt (wayne.kirk.schmidt@gmail.com)"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "${SCRIPT_DIR}/.." && pwd )"
LIB_DIR="${ROOT_DIR}/lib"
CFG_DIR="${ROOT_DIR}/cfg"

for module in "${LIB_DIR}"/*.bash; do
    source "$module"
done

main "$@"
