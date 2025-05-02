#!/bin/bash

# organize_files.sh - Organize files in a directory by their file extension

usage() {
    echo "Usage: $0 <target_directory> [--dry-run]"
    echo "Example: $0 ~/Downloads"
    echo "         $0 ~/Downloads --dry-run"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

TARGET_DIR="$1"
DRY_RUN=false
LOG_FILE="organize_log.txt"

# Check for dry-run flag
if [ "$2" == "--dry-run" ]; then
    DRY_RUN=true
    echo "[DRY-RUN MODE] No files will actually be moved."
fi

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found."
    exit 1
fi

# Clear or create log file
> "$LOG_FILE"

# Traverse directory recursively
find "$TARGET_DIR" -type f | while read -r file; do
    # Skip the log file itself
    [[ "$file" == *"$LOG_FILE" ]] && continue

    # Get file extension (lowercased), skip if none
    ext="${file##*.}"
    [ "$file" = "$ext" ] && continue
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    # Create subdirectory path
    folder="$TARGET_DIR/$ext"

    # Skip if file is already in its destination folder
    [[ "$file" == "$folder/"* ]] && continue

    # Make extension folder if it doesn't exist
    if [ ! -d "$folder" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir "$folder"
        fi
        echo "[INFO] Creating folder: $folder" >> "$LOG_FILE"
    fi

    # Build new file path
    base_name=$(basename "$file")
    dest="$folder/$base_name"

    # Handle naming conflict
    if [ -e "$dest" ]; then
        timestamp=$(date +%s)
        dest="$folder/${timestamp}_$base_name"
    fi

    # Log and perform action
    echo "[MOVE] $file → $dest" >> "$LOG_FILE"
    if [ "$DRY_RUN" = false ]; then
        mv "$file" "$dest"
    fi
done

echo "Organizing complete."
echo "Log saved to: $LOG_FILE"
