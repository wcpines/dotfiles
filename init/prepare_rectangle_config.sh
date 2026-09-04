#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_config="$DOTFILES_DIR/rectangle/RectangleConfig.json"
target_dir="$HOME/Library/Application Support/Rectangle"
target_config="$target_dir/RectangleConfig.json"

if [[ ! -f "$source_config" ]]; then
	echo "Rectangle configuration is missing: $source_config" >&2
	exit 1
fi

mkdir -p "$target_dir"
install -m 600 "$source_config" "$target_config"

echo "Prepared Rectangle configuration at $target_config"
echo "Quit and reopen Rectangle, then select Apply when it asks to apply the configuration."
