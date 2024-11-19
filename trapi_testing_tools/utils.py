from contextlib import redirect_stdout
import json
import subprocess
from sys import stderr
from typing import Literal, Optional
import httpx
import yaml
from pathlib import Path
import enum
from rich.console import Console
from InquirerPy import inquirer
from rich.pretty import Pretty

with open(
    Path(__file__).parent.joinpath("../config.yaml").resolve(), "r"
) as config_file:
    config = yaml.safe_load(config_file)

EnvironmentMapping = {}
default = None
for env, levels in config["environments"].items():
    if env == "default":
        default = levels
        continue
    for level, url in levels.items():
        EnvironmentMapping[f"{env}.{level}"] = url

if default:
    for level, url in config["environments"][default].items():
        EnvironmentMapping[level] = url


def should_output(
    output: object,
    output_type: Literal["view", "save"],
    mode: Literal["prompt", "skip", "every"],
) -> bool:
    if output is None or mode == "skip":
        return False
    output = True
    if mode == "every":
        return True
    with redirect_stdout(stderr):  # Otherwise set to "prompt"
        return inquirer.confirm(
            message=f"{output_type.capitalize()} response body?", default=True
        ).execute()


def handle_output(
    output: object,
    view_mode: Literal["prompt", "skip", "every", "pipe"],
    save_mode: Literal["prompt", "skip", "every"],
    save_path: Optional[Path],
):
    if output is None:
        return
    if view_mode == "pipe":
        print(json.dumps(output) if isinstance(output, (dict, list)) else output)
        return

    if should_output(output, "view", view_mode):
        if isinstance(output, dict):
            subprocess.run("jless", input=json.dumps(output), shell=True, text=True)
        else:
            subprocess.run("less", input=str(output), shell=True, text=True)

    if should_output(
        output,
        "save",
        save_mode,
    ):
        if not save_path:
            with redirect_stdout(stderr):
                save_path = Path(
                    inquirer.filepath(
                        message="Enter a path to save to:",
                        only_directories=True,
                    ).execute()
                )
        with open(save_path, "w", encoding="utf8") as file:
            if isinstance(output, dict):
                json.dump(output, file)
            else:
                file.write(output)
