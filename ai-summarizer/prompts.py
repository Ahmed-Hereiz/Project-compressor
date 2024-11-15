full_file_analysis_prompt = """You are an expert code analyst and technical documentation writer. Your task is to analyze the provided code file and create a comprehensive summary.

Please analyze the following code file and provide:

1. A high-level overview of what this file does and its main purpose
2. Key functionality and features implemented in the code
3. Important components, functions, or classes and their roles
4. Any notable patterns, dependencies, or external integrations
5. The overall workflow or process flow of the code

Focus on providing clear, concise explanations that would help another developer understand:
- The purpose and functionality of this code
- How the different parts work together
- What problems this code solves
- Any important technical details or implementation choices

Code to analyze:
{code_content}

Please provide your analysis in a clear, structured format that emphasizes the most important aspects of the code.
"""

oneline_file_analysis_prompt = """You are an expert code analyst. Your task is to analyze the provided code file and create an extremely concise 1-2 line summary that captures the core purpose and main functionality.

Code to analyze:
{code_content}

Provide a 1-2 line summary that explains what this code does in the most concise way possible."""

project_analysis_prompt = """You are an expert project analyst. Your task is to analyze the provided file summaries and create a comprehensive project overview.

Given a collection of file summaries from a project, where each summary describes a file's core purpose in 1-2 lines:

{file_summaries}

Please provide:
1. A clear explanation of what this project does and its main purpose
2. The key components and how they work together
3. The overall architecture and workflow of the project
4. The technical approach and key implementation choices

Focus on synthesizing the individual file summaries into a cohesive understanding of the entire project. Your analysis should help developers quickly grasp:
- The project's core functionality and purpose
- How the different files/components interact
- The overall technical architecture
- Any notable patterns or design decisions

Provide your analysis in a clear, structured format that gives a complete picture of the project while remaining concise and focused on the most important aspects."""
