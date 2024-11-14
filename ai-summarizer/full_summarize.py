import os
import argparse
from projectsummary_agent import project_analysis
from singlefile_agent import full_file_analysis, oneline_file_analysis
import json

def load_llm_config():
    config_path = "../config/llm.json"
    with open(config_path) as f:
        return json.load(f)

config = load_llm_config()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate code summaries for a directory')
    parser.add_argument('--dir', type=str, required=True, help='Path to directory to analyze')
    args = parser.parse_args()

    if not os.path.exists("summaries"):
        os.makedirs("summaries")

    file_summaries = []

    for root, dirs, files in os.walk(args.dir):
        if "summaries" in root:
            continue

        relative_path = os.path.relpath(root, args.dir)
        summary_dir = os.path.join("summaries", relative_path)
        if not os.path.exists(summary_dir):
            os.makedirs(summary_dir)

        analyzable_extensions = {'.py', '.html', '.js', '.css', '.txt', '.json', '.md', '.yaml', '.yml'}
        skip_files = {'__init__.py', '__main__.py', 'setup.py', 'requirements.txt'}
        
        for file in files:
            _, ext = os.path.splitext(file)
            
            if (ext not in analyzable_extensions or 
                file in skip_files or
                'site-packages' in root):
                continue
                
            file_path = os.path.join(root, file)
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    f.read()
            except UnicodeDecodeError:
                continue
                
            full_analysis = full_file_analysis(file_path, config)
            oneline_summary = oneline_file_analysis(file_path, config)
            
            summary_file = os.path.join(summary_dir, 
                file + "_summary.txt")
            
            with open(summary_file, "w") as f:
                f.write(full_analysis)
            
            file_summaries.append(f"{file}: {oneline_summary}")

    project_summary = project_analysis("\n".join(file_summaries),config=config)
    with open("summaries/full_project_summary.txt", "w") as f:
        f.write("\nFile Summaries:\n")
        f.write("\n".join(file_summaries))
        f.write("\n\nProject Analysis:\n")
        f.write(project_summary)