#!/bin/bash

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-path)
      PROJECT_PATH="$2"
      shift 2
      ;;
    --freeze-location)
      FREEZE_LOCATION="$2"
      shift 2
      ;;
    --env-path)
      ENV_PATH="$2"
      shift 2
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

if [[ -z "$PROJECT_PATH" || -z "$FREEZE_LOCATION" ]]; then
  echo "Usage: ./freeze-proj --project-path <project_path> --freeze-location <freeze_location> [--env-path <env_path>]"
  exit 1
fi

mkdir -p "$FREEZE_LOCATION"

if [[ -z "$ENV_PATH" ]]; then
  ENV_PATH=$(find "$PROJECT_PATH" -type d -path "*/lib/python*/site-packages" -print | sed 's|/lib/python.*/site-packages||' | head -n 1)
  
  if [[ -z "$ENV_PATH" ]]; then
    echo "Environment not found in project directory. Please specify with --env-path."
    exit 1
  fi
fi

RELATIVE_ENV_PATH=$(basename "$ENV_PATH")
if [[ "$(dirname "$ENV_PATH")/" == "$PROJECT_PATH" ]]; then
  tar -cjvf "$FREEZE_LOCATION/layer1_project_files.tar.bz2" --exclude="$RELATIVE_ENV_PATH" -C "$(dirname "$PROJECT_PATH")" "$(basename "$PROJECT_PATH")"
else
  tar -cjvf "$FREEZE_LOCATION/layer1_project_files.tar.bz2" -C "$(dirname "$PROJECT_PATH")" "$(basename "$PROJECT_PATH")"
fi

SITE_PACKAGES_PATH=$(find "$ENV_PATH" -type d -path "*/lib/python*/site-packages" | head -n 1)
if [[ -n "$SITE_PACKAGES_PATH" ]]; then
  tar -cjvf "$FREEZE_LOCATION/layer2_dependencies.tar.bz2" -C "$(dirname "$SITE_PACKAGES_PATH")" "$(basename "$SITE_PACKAGES_PATH")"
else
  echo "No site-packages directory found in environment path."
fi

if command -v pip &> /dev/null; then
  pip freeze > "$FREEZE_LOCATION/requirements.txt"
else
  echo "pip not found, skipping requirements.txt generation."
fi

METADATA_PATH="$FREEZE_LOCATION/metadata.json"
LAYER1_FILE_COUNT=$(tar -tf "$FREEZE_LOCATION/layer1_project_files.tar.bz2" | wc -l)
LAYER1_FILE_COUNT=$((LAYER1_FILE_COUNT - 1))

cat <<EOF > "$METADATA_PATH"
{
  "project_path": "$PROJECT_PATH",
  "freeze_location": "$FREEZE_LOCATION",
  "env_path": "$ENV_PATH",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "user": "$(whoami)",
  "os": "$(uname -s)",
  "layer1_file_count": $LAYER1_FILE_COUNT
}
EOF

echo "1" > "$FREEZE_LOCATION/enable-unfreeze"

rm -rf "$PROJECT_PATH"

echo "Project frozen successfully at $FREEZE_LOCATION."
