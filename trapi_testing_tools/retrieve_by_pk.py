from contextlib import redirect_stdout
from pathlib import Path
from sys import stderr
from typing import Literal, Optional, cast

import httpx
from InquirerPy import inquirer
from rich.console import Console
from urlextract import URLExtract

from trapi_testing_tools.utils import handle_output

console = Console(stderr=True)
client = httpx.Client(follow_redirects=True, timeout=300)


def get_ars_trace(pk: str) -> tuple[str, dict]:
    """Query the ARS instances until the pk is found, returning the trace."""

    levels = dict(
        prod="https://ars-prod.transltr.io/ars/api/messages",
        test="https://ars.test.transltr.io/ars/api/messages",
        ci="https://ars.ci.transltr.io/ars/api/messages",
        dev="https://ars-dev.transltr.io/ars/api/messages",
    )
    target_url = ""
    response: httpx.Response = httpx.Response(404)

    with console.status("Querying ARS Prod for details...") as status:
        for level, url in levels.items():
            query = f"{url}/{pk}?trace=y"
            status.update(f"Query ARS {level.capitalize()} for details...")
            console.print(f"GET {query}")
            response = client.get(query)
            if response.status_code != 404:
                console.print(f"Got response from ARS {level.capitalize()}")
                target_url = url
                break

    if target_url == "":
        console.print("Unable to find PK on any ARS instances.")
        return target_url, {}

    response.raise_for_status()
    return target_url, response.json()


def get_ars_ara_response(target_ars: str, trace: dict, ara: Optional[str]) -> dict:
    """Select an ARA-specific response from the ARS trace and retrieve it."""

    actor: dict
    actors = [
        child["actor"]["agent"].removeprefix("ara-")
        for child in trace["children"]
        if "ara" in child["actor"]["agent"]
    ]

    if ara in actors:
        actor = next(
            child for child in trace["children"] if ara in child["actor"]["agent"]
        )
        selection = ara
    else:
        if ara is not None:
            console.print(f"Warning: pre-selected ara '{ara}' not a valid actor")
        selection = inquirer.fuzzy(
            message="Select ARA to retrieve response of:",
            choices=[actor.removeprefix("ara-") for actor in actors],
            border=True,
            instruction="(Type to filter, Tab to select, Enter to confirm)",
            info=True,
        ).execute()
        actor = next(
            child for child in trace["children"] if selection in child["actor"]["agent"]
        )

    console.print(f"Child key for {selection}: {actor['message']}")

    with console.status("Querying ARS for TRAPI response..."):
        response = httpx.get(f"{target_ars}/{actor['message']}")
    response.raise_for_status()
    console.print(f"Got ARS stored response for {selection}")
    return response.json()


def check_logs(body: dict) -> Optional[dict]:
    """Check logs for original response URL, prompt user to select, then retrieve response."""
    logs = body.get("fields", {}).get("data", {}).get("logs", {})
    if not logs:
        return

    extractor = URLExtract()
    possible_logs: list[str] = []
    for log in logs:  # Possible multiple URLs in one log
        urls = extractor.find_urls(log["message"])
        possible_logs.extend(
            f"{log['message'].split(url, 1)[0]} >{url}< ..." for url in urls
        )

    selection = possible_logs[0]
    if len(possible_logs) > 1:
        with redirect_stdout(stderr):
            selection = inquirer.fuzzy(
                message="Select URL from logs:",
                choices=possible_logs,
                border=True,
                instruction="(Type to filter, Tab to select, Enter to confirm)",
                info=True,
            ).execute()
    url = cast(str, extractor.find_urls(selection)[0])

    console.print(f"Response URL: {url}")
    with console.status("Querying for original response..."):
        response = httpx.get(url)
    response.raise_for_status()
    return response.json()


def handle_error(msg, error):
    """Print some `msg` and error name, prompting to print traceback."""

    console.print(f"ERROR: {msg} due to {repr(error)}")
    with redirect_stdout(stderr):
        if inquirer.confirm("Print traceback for this error?", default=False).execute():
            console.print_exception(show_locals=True)


def get_response_from_pk(
    pk: str,
    ara: Optional[str],
    view_mode: Literal["prompt", "skip", "every", "pipe"],
    save_mode: Literal["prompt", "skip", "every"],
    save_path: Optional[Path],
):
    """Drill down into ARS PK to get a response of interest."""

    target_url: str
    body: dict
    try:
        target_url, body = get_ars_trace(pk)
        if target_url == "":
            return
    except httpx.HTTPError as error:
        handle_error("Failed to get ARS trace for pk", error)
        return

    try:
        body = get_ars_ara_response(target_url, body, ara)
    except httpx.HTTPError as error:
        handle_error("Failed to get ARS stored response for ARA", error)
        return

    try:
        if inquirer.confirm(
            "Scan response logs for original response url?", default=True
        ).execute():
            response = check_logs(body)
            if response is not None:
                body = response
    except httpx.HTTPError as error:
        handle_error("Failed to get response from ARA", error)
        return

    handle_output(body, view_mode, save_mode, save_path)
