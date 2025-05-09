# organize_files.sh

A Bash script that organizes files in a directory into subfolders based on their file extensions.

## Purpose

Over time, directories like `Downloads` can get cluttered with a mix of documents, images, installers, and more. This script helps clean things up automatically by moving each file into a folder based on its extension (e.g., `.jpg`, `.pdf`, `.txt`).

## Features

- Organizes files into extension-based subfolders
- Recursively processes nested directories
- `--dry-run` mode to preview actions without making changes
- Logs all moves and operations to `organize_log.txt`
- Skips files with no extension
- Automatically creates folders as needed
- Displays usage help when run incorrectly

## Usage

```bash
./organize_files.sh <target_directory> [--dry-run]
