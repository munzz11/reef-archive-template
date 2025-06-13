#!/usr/bin/env bash

# archive_init.sh - Initialize or customize a REEF archive directory tree
#
# This script reads platform and sensor configuration from a JSON file (config.json)
# and creates the corresponding directory hierarchy as outlined in the project
# README.  It is idempotent: running it multiple times will only create missing
# directories and will not overwrite or delete existing data.
#
# Usage:
#   ./archive_init.sh          # run from repository root
#
# Requirements:
#   - Bash 4+
#   - Write permissions within the project directory tree
#   - jq (for JSON parsing)

set -euo pipefail

# Ensure we are running from the repository root (directory containing 01-catalog, 02-raw, etc.)
PROJECT_ROOT=$(dirname "$0")
cd "$PROJECT_ROOT"

# Define base directories
RAW_BASE="02-raw/platforms"
PROCESSED_BASE="03-processed"
CLOUD_BASE="02-raw/cloud"
PRODUCTS_BASE="04-products"

# Read archive path from config.json
ARCHIVE_PATH=$(jq -r '.archive_path' config.json)

# Check if archive path is still set to default
if [[ "$ARCHIVE_PATH" == "/path/to/your/archive" ]]; then
  echo "Error: Archive path in config.json is still set to the default value."
  echo "Please update the 'archive_path' in config.json to point to your desired archive location."
  exit 1
fi

# Check if config.json exists
if [[ ! -f "config.json" ]]; then
  echo "Error: config.json not found."
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is not installed. Please install jq to parse JSON files."
  exit 1
fi

# Check if the basic archive structure exists
if [[ ! -d "$ARCHIVE_PATH/01-catalog" || ! -d "$ARCHIVE_PATH/02-raw" || ! -d "$ARCHIVE_PATH/03-processed" || ! -d "$ARCHIVE_PATH/04-products" ]]; then
  echo "Creating basic archive structure in $ARCHIVE_PATH ..."
  mkdir -p "$ARCHIVE_PATH/01-catalog" "$ARCHIVE_PATH/02-raw" "$ARCHIVE_PATH/03-processed" "$ARCHIVE_PATH/04-products" || { echo "Error: Failed to create basic archive structure."; exit 1; }
else
  echo "Basic archive structure already exists in $ARCHIVE_PATH."
  # Verify that the structure matches the template
  if [[ ! -d "$ARCHIVE_PATH/01-catalog/data-manifest" || ! -d "$ARCHIVE_PATH/01-catalog/ops-log" ]]; then
    echo "Warning: The archive structure does not match the template. Creating missing directories..."
    mkdir -p "$ARCHIVE_PATH/01-catalog/data-manifest" "$ARCHIVE_PATH/01-catalog/ops-log" || { echo "Error: Failed to create missing directories."; exit 1; }
  fi
fi

# Read platforms and sensors from config.json
PLATFORMS=$(jq -r '.platforms | keys[]' config.json)

echo "========================================================"
echo "  REEF Archive Initialisation"
echo "========================================================"
echo "Reading configuration from config.json ..."
echo

# Print tree-like view of the directory structure
echo "Directory structure to be created:"
echo "--------------------------------"
echo "$ARCHIVE_PATH/$RAW_BASE"
for PLATFORM in $PLATFORMS; do
  echo "  └── $PLATFORM"
  SENSORS=$(jq -r ".platforms[\"$PLATFORM\"].sensors[]" config.json)
  for SENSOR in $SENSORS; do
    echo "      ├── data/$SENSOR"
    echo "      └── metadata/$SENSOR"
  done
done

echo "$ARCHIVE_PATH/$PROCESSED_BASE"
PROCESSED_FOLDERS=$(jq -r '.processed.folders[]' config.json)
for FOLDER in $PROCESSED_FOLDERS; do
  echo "  └── $FOLDER"
done

echo "$ARCHIVE_PATH/$CLOUD_BASE"
CLOUD_FOLDERS=$(jq -r '.cloud.folders[]' config.json)
for FOLDER in $CLOUD_FOLDERS; do
  echo "  └── $FOLDER"
done

echo "$ARCHIVE_PATH/$PRODUCTS_BASE"
PRODUCTS_FOLDERS=$(jq -r '.products.folders[]' config.json)
for FOLDER in $PRODUCTS_FOLDERS; do
  echo "  └── $FOLDER"
done

# Prompt user for confirmation
read -rp "Do you want to proceed with creating the directory structure? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Operation cancelled."
  exit 0
fi

# Create base directories if they don't exist
mkdir -p "$ARCHIVE_PATH/$RAW_BASE" "$ARCHIVE_PATH/$PROCESSED_BASE" "$ARCHIVE_PATH/$CLOUD_BASE" "$ARCHIVE_PATH/$PRODUCTS_BASE" || { echo "Error: Failed to create base directories."; exit 1; }

# Create directory structure
for PLATFORM in $PLATFORMS; do
  SENSORS=$(jq -r ".platforms[\"$PLATFORM\"].sensors[]" config.json)
  for SENSOR in $SENSORS; do
    DATA_DIR="$ARCHIVE_PATH/$RAW_BASE/$PLATFORM/data/$SENSOR"
    META_DIR="$ARCHIVE_PATH/$RAW_BASE/$PLATFORM/metadata/$SENSOR"
    mkdir -p "$DATA_DIR" "$META_DIR" || { echo "Error: Failed to create directories for $PLATFORM/$SENSOR."; exit 1; }
  done
done

for FOLDER in $PROCESSED_FOLDERS; do
  PROC_DIR="$ARCHIVE_PATH/$PROCESSED_BASE/$FOLDER"
  mkdir -p "$PROC_DIR" || { echo "Error: Failed to create processed directory for $FOLDER."; exit 1; }
done

for FOLDER in $CLOUD_FOLDERS; do
  CLOUD_DIR="$ARCHIVE_PATH/$CLOUD_BASE/$FOLDER"
  mkdir -p "$CLOUD_DIR" || { echo "Error: Failed to create cloud directory for $FOLDER."; exit 1; }
done

for FOLDER in $PRODUCTS_FOLDERS; do
  PRODUCT_DIR="$ARCHIVE_PATH/$PRODUCTS_BASE/$FOLDER"
  mkdir -p "$PRODUCT_DIR" || { echo "Error: Failed to create products directory for $FOLDER."; exit 1; }
done

echo "Archive initialisation complete." 