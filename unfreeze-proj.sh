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

if [[ -z "$FREEZE_LOCATION" || -z "$PROJECT_PATH" ]]; then
  echo "Usage: ./unfreeze-proj.sh --project-path <project_path> --freeze-location <freeze_location> [--env-path <env_path>]"
  exit 1
fi

mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH" || exit

python3 -m venv .venv
source .venv/bin/activate

tar -xjvf "$FREEZE_LOCATION/layer1_project_files.tar.bz2" -C "$PROJECT_PATH" --strip-components=1

if [[ -z "$ENV_PATH" ]]; then
  ENV_PATH="$PROJECT_PATH.venv"
fi

SITE_PACKAGES_PATH=$(find "$ENV_PATH" -type d -path "*/lib/python*/site-packages" | head -n 1)

if [[ -d $SITE_PACKAGES_PATH ]]; then
  tar -xjvf "$FREEZE_LOCATION/layer2_dependencies.tar.bz2" -C "$SITE_PACKAGES_PATH" --strip-components=1
else
  echo "Site-packages directory not found in virtual environment."
  exit 1
fi

if [[ -f "$FREEZE_LOCATION/requirements.txt" ]]; then
  cp "$FREEZE_LOCATION/requirements.txt" "$PROJECT_PATH/"
else
  echo "requirements.txt not found in freeze location."
fi

rm -rf "$FREEZE_LOCATION"

echo "Project unfreezed successfully from $FREEZE_LOCATION."
