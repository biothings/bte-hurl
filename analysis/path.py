#!/usr/bin/env python3
import json
from typing import Annotated, Optional, cast
import typer
import questionary
from pathlib import Path
import sys
from contextlib import redirect_stdout


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


app = typer.Typer(no_args_is_help=True)


def read_trapi(path: Path) -> dict:
    with open(path, "r") as file:
        return json.load(file)


def setup(
    file: Path, start: Optional[str], end: Optional[str]
) -> tuple[dict, dict, str, str]:
    response = read_trapi(file)
    kg = response["message"]["knowledge_graph"]

    qnodes = response["message"]["query_graph"]["nodes"].keys()

    with redirect_stdout(sys.stderr):
        if start is None:
            start = questionary.select(f"Select a starting QNode", choices=qnodes).ask()
        if end is None:
            end = questionary.select(f"Select an ending QNode", choices=qnodes).ask()

    start = response["message"]["query_graph"]["nodes"][start]["ids"][0]
    end = response["message"]["query_graph"]["nodes"][end]["ids"][0]

    return response, kg, cast(str, start), cast(str, end)


def find_all_paths(graph, start, end, path=[]):
    path = path + [start]
    if start == end:
        return [path]
    if start not in graph:
        return []
    paths = []
    for node in graph[start]:
        if node not in path:
            newpaths = find_all_paths(graph, node, end, path)
            for newpath in newpaths:
                paths.append(newpath)
    return paths


def get_paths(kg: dict, start: str, end: str, path=[]) -> list[list[str]]:
    path = path + [start]
    if start == end:
        return [path]
    if start not in kg["nodes"].keys():
        return []
    paths = []
    for node in set(
        edge["object"] for edge in kg["edges"].values() if edge["subject"] == start
    ):
        if node not in path:
            newpaths = get_paths(kg, node, end, path)
            for newpath in newpaths:
                paths.append(newpath)
    return paths


@app.command(no_args_is_help=True)
def count(
    file: Annotated[
        Path,
        typer.Argument(
            exists=True,
            file_okay=True,
            dir_okay=False,
            readable=True,
        ),
    ],
    start: Annotated[Optional[str], typer.Option("--start", "-s")] = None,
    end: Annotated[Optional[str], typer.Option("--end", "-e")] = None,
):
    response, kg, start, end = setup(file, start, end)
    paths = get_paths(kg, start, end)
    lengths = {}

    for path in paths:
        if len(path) - 1 not in lengths:
            lengths[len(path) - 1] = 0
        lengths[len(path) - 1] += 1

    for length in sorted(lengths.keys()):
        if length > 1:
            print(f"Length {length}: {lengths[length]} paths.")


@app.command(no_args_is_help=True)
def list(
    file: Annotated[
        Path,
        typer.Argument(
            exists=True,
            file_okay=True,
            dir_okay=False,
            readable=True,
        ),
    ],
    start: Annotated[Optional[str], typer.Option("--start", "-s")] = None,
    end: Annotated[Optional[str], typer.Option("--end", "-e")] = None,
):
    response, kg, start, end = setup(file, start, end)
    paths = get_paths(kg, start, end)

    sorted_paths = {}

    for path in paths:
        if len(path) - 1 not in sorted_paths:
            sorted_paths[len(path) - 1] = []
        sorted_paths[len(path) - 1].append(path)

    for length in sorted(sorted_paths.keys()):
        for path in sorted_paths[length]:
            if len(path) > 2:
                print(" > ".join(path))

    eprint(f"Found {len(paths)} paths (listed above).")


app()
