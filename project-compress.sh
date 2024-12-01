#!/bin/bash

ACTION=""
USE_AI=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --action)
      ACTION="$2"
      shift 2
      ;;
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
    --ai)
      USE_AI=true
      shift 1
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

if [[ -z "$ACTION" ]]; then
  echo "Usage: $0 --action <freeze|unfreeze> --project-path <project_path> --freeze-location <freeze_location> [--env-path <env_path>] [--ai]"
  exit 1
fi

freeze_project() {
  bash ./freeze-proj.sh --project-path "$PROJECT_PATH" --freeze-location "$FREEZE_LOCATION" ${ENV_PATH:+--env-path "$ENV_PATH"}
  
  if [[ "$USE_AI" == true ]]; then
    source .venv/bin/activate

    cd ai-summarizer

    pwd
    echo $PROJECT_PATH

    python3 full_summarize.py --dir "$PROJECT_PATH"
    
    tar -czf "$FREEZE_LOCATION/ai-files.tar.gz" summaries/
    
    echo "1" > "$FREEZE_LOCATION/ai-content"
  
    cd ..
  fi
}

unfreeze_project() {
  bash ./unfreeze-proj.sh --project-path "$PROJECT_PATH" --freeze-location "$FREEZE_LOCATION" ${ENV_PATH:+--env-path "$ENV_PATH"}
  
  if [[ -f "$FREEZE_LOCATION/ai-content" ]] && [[ "$(cat "$FREEZE_LOCATION/ai-content")" == "1" ]]; then
    mkdir -p "$PROJECT_PATH/ai-files"
    tar -xzf "$FREEZE_LOCATION/ai-files.tar.gz" -C "$PROJECT_PATH/ai-files/"
  fi
}

case "$ACTION" in
  freeze)
    freeze_project
    ;;
  unfreeze)
    unfreeze_project
    ;;
  *)
    echo "Invalid action: $ACTION. Use 'freeze' or 'unfreeze'."
    exit 1
    ;;
esac
