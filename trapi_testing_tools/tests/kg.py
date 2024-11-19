from typing import Union
import httpx


def node_count(response: httpx.Response) -> Union[str, None]:
    body = response.json()
    no_nodes = len(body["message"]["knowledge_graph"]["nodes"].keys()) == 0
    if no_nodes:
        return "0 nodes."


def edge_count(response: httpx.Response) -> Union[str, None]:
    body = response.json()
    no_edges = len(body["message"]["knowledge_graph"]["edges"].keys()) == 0
    if no_edges:
        return "0 edges"
