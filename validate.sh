#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")
REPO_DIR="$SCRIPT_DIR/assesable-activity2-wad-2024-25"
CONF_PATH="$REPO_DIR/scripts"
REACT_SCRIPT="$REPO_DIR/app/web_server"

#pasar path a reac_app.sh
source "$REACT_SCRIPT/react_app.sh" "$CONF_PATH"