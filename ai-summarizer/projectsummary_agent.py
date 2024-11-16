from customAgents.agent_llm import SimpleInvokeLLM
from customAgents.agent_prompt import SimplePrompt
from customAgents.runtime import SimpleRuntime
from prompts import project_analysis_prompt

def project_analysis(file_summaries, config):
    llm = SimpleInvokeLLM(api_key=config["api_key"], model=config["model"], temperature=0.2)
    prompt = SimplePrompt(text=project_analysis_prompt)
    prompt.construct_prompt(placeholder_dict={"{file_summaries}": file_summaries})
    agent = SimpleRuntime(prompt=prompt, llm=llm)
    response = agent.loop()
    return response
