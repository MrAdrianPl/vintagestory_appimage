#!/bin/bash

# Get the absolute directory path of where the script is located
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Required for the game to load its own fonts (must be absolute path)
export FONTCONFIG_FILE="$SCRIPT_DIR"/fonts.conf

# Change directory to where the game executable should also be
cd "$SCRIPT_DIR"

# try to use the more powerful/dedicated GPU if available - set this if by default it uses your integrated graphics card
# export DRI_PRIME=1
export DOTNET_ROOT="$APPDIR/bin"
export DOTNET_ROOT_X64="$APPDIR/bin"

# Run the game, pass along all arguments given to the script
./Vintagestory "$@"
