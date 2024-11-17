from customAgents.agent_llm import SimpleInvokeLLM
from customAgents.agent_prompt import SimplePrompt
from customAgents.runtime import SimpleRuntime
from prompts import full_file_analysis_prompt, oneline_file_analysis_prompt


def full_file_analysis(file_path, config):
    llm = SimpleInvokeLLM(api_key=config["api_key"], model=config["model"], temperature=0.2)
    prompt = SimplePrompt(text=full_file_analysis_prompt)

    with open(file_path, 'r') as file:
        code_content = file.read()
    prompt.construct_prompt(placeholder_dict={"{code_content}": code_content})
    agent = SimpleRuntime(prompt=prompt, llm=llm)
    response = agent.loop()
    return response


def oneline_file_analysis(file_path, config):
    llm = SimpleInvokeLLM(api_key=config["api_key"], model=config["model"], temperature=0.2)
    prompt = SimplePrompt(text=oneline_file_analysis_prompt)

    with open(file_path, 'r') as file:
        code_content = file.read()
    prompt.construct_prompt(placeholder_dict={"{code_content}": code_content})
    agent = SimpleRuntime(prompt=prompt, llm=llm)
    response = agent.loop()
    return response

