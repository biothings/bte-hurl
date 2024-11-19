from typing import Union
import httpx


def node_count(response: httpx.Response) -> Union[str, None]:
    body = response.json()
    condition = len(body["message"]["knowledge_graph"]["nodes"].keys()) == 0
    if condition:
        return "0 nodes."


def edge_count(response: httpx.Response) -> Union[str, None]:
    body = response.json()
    condition = len(body["message"]["knowledge_graph"]["edges"].keys()) == 0
    if condition:
        return "0 edges"
