#!/bin/bash

# Determine the OS
case "$(uname -s)" in
    Darwin)
        # macOS
        FM='tselect'
        ;;
    Linux)
        # Linux
        if command -v dolphin &> /dev/null; then
            FM='dolphin'
        else
            if command -v thunar &> /dev/null; then
                FM='thunar'
            elif command -v nautilus &> /dev/null; then
                FM='nautilus'
            fi
        fi
        ;;
    CYGWIN*|MINGW*|MSYS*)
        # Windows (via Cygwin, MinGW, or MSYS)
        FM='explorer.exe'
        ;;
    Linux-gnu/*Microsoft)
        # WSL (Windows Subsystem for Linux)
        FM='explorer.exe'
        ;;
    *)
        echo "Unsupported OS" >&2
        exit 1
        ;;
esac

# Get the selected files from Ranger
SELECTED_FILES=("$@")

# Run the file manager with the selected files
case "$FM" in
    tselect)
        "$FM" "${SELECTED_FILES[@]}"
        ;;
    dolphin)
        "$FM" --select "${SELECTED_FILES[@]}" > /dev/null 2>&1 &
        ;;
    thunar|nautilus)
        "$FM" "${SELECTED_FILES[@]}" > /dev/null 2>&1 &
        ;;
    explorer.exe)
        for file in "${SELECTED_FILES[@]}"; do
            "$FM" /select,"$file" > /dev/null 2>&1 &
        done
        ;;
    *)
        echo "Unknown file manager: $FM" >&2
        exit 1
        ;;
esac
