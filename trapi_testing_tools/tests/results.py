from typing import Optional
import httpx


def result_count(response: httpx.Response) -> Optional[str]:
    body = response.json()
    condition = len(body["message"]["results"]) == 0
    if condition:
        return "0 results"


def no_results(response: httpx.Response) -> Optional[str]:
    body = response.json()
    condition = len(body["message"]["results"]) == 0
    if condition:
        return ">0 results"
