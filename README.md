# Project Compressor

Project Compressor is a command-line tool for freezing and unfreezing Python projects along with their environments. It allows you to easily archive your project files and dependencies, making it simple to share, backup, or restore your work.

## Features

- **Freeze Projects**: Compress your project files and dependencies into a single archive.
- **Unfreeze Projects**: Restore your project from the compressed archive, including all necessary files and virtual environments.
- **Environment Management**: Automatically detect and manage Python virtual environments.
- **Metadata Handling**: Store metadata about the project, such as paths, timestamps, and user information.

## Usage

### Freezing a Project

To freeze a project, use the following command:

```bash
./project-compress --action freeze --project-path <project_path> --freeze-location <freeze_location> [--env-path <env_path>]
```
--action: Specify whether to freeze or unfreeze the project.
--project-path: Path to the project directory you want to freeze.
--freeze-location: Location where the frozen project will be stored.
--env-path (optional): Path to the virtual environment directory.

### Unfreezing a Project

To unfreeze a project, use the following command:

```bash
./project-compress.sh --action unfreeze --project-path <project_path> --freeze-location <freeze_location> [--env-path <env_path>]
```
### Installation
1. Clone the repository:
```bash
git clone <repository_url>
```
2. Navigate to the project directory:
```bash
cd <repository_name>
```

### Requirements

- Bash shell
- Python 3
- Python Virtual Environment (venv)

#### Soon adding project documentation with AI.