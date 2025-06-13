#!/usr/bin/env bash

# archive_clean.sh - Clean the REEF archive structure
#
# This script checks for significant files in the 02-raw directory and prompts
# the user before deleting the contents of the platforms and cloud folders.
#
# Usage:
#   ./archive_clean.sh          # run from repository root
#
# Requirements:
#   - Bash 4+
#   - Write permissions within the project directory tree

set -euo pipefail

# Ensure we are running from the repository root (directory containing 01-catalog, 02-raw, etc.)
PROJECT_ROOT=$(dirname "$0")
cd "$PROJECT_ROOT"

# Read archive path from config.json
ARCHIVE_PATH=$(jq -r '.archive_path' config.json)

# Check if archive path is still set to default
if [[ "$ARCHIVE_PATH" == "/path/to/your/archive" ]]; then
  echo "Error: Archive path in config.json is still set to the default value."
  echo "Please update the 'archive_path' in config.json to point to your desired archive location."
  exit 1
fi

RAW_BASE="02-raw"
PLATFORMS_DIR="$ARCHIVE_PATH/$RAW_BASE/platforms"
CLOUD_DIR="$ARCHIVE_PATH/$RAW_BASE/cloud"
PROCESSED_PLATFORMS_DIR="$ARCHIVE_PATH/03-Processed/platforms"
PRODUCTS_DIR="$ARCHIVE_PATH/04-Products"

# Check for significant files in 02-raw
FILE_COUNT=$(find "$ARCHIVE_PATH/$RAW_BASE" -type f | wc -l)

if [ "$FILE_COUNT" -gt 0 ]; then
  echo "WARNING: THERE ARE $FILE_COUNT FILES IN THE $ARCHIVE_PATH/$RAW_BASE DIRECTORY."
fi

# Prompt user for confirmation
echo "========================================================"
echo "  WARNING  "
echo "========================================================"
echo "This will delete all files in the $ARCHIVE_PATH/$RAW_BASE directory."
read -rp "ARE YOU SURE YOU WANT TO PROCEED WITH CLEANING? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Operation cancelled."
  exit 0
fi

read -rp "ARE YOU LIKE SUPER SURE????? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Operation cancelled."
  exit 0
fi

# Clean platforms and cloud directories
echo "Cleaning $PLATFORMS_DIR and $CLOUD_DIR ..."
rm -rf "$PLATFORMS_DIR"/* "$CLOUD_DIR"/*

# Clean processed platforms and products directories
echo "Cleaning $PROCESSED_PLATFORMS_DIR and $PRODUCTS_DIR ..."
rm -rf "$PROCESSED_PLATFORMS_DIR"/* "$PRODUCTS_DIR"/*

echo "Archive cleaned successfully." 