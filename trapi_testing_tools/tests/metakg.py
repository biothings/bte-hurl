def node_count(response):
    condition = len(response.json()["nodes"].keys()) == 0
    if condition:
        return "0 nodes."


def edge_count(response):
    condition = len(response.json()["edges"]) == 0
    if condition:
        return "0 edges"
