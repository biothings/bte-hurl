from trapi_testing_tools.tests import kg, results, logs

method = "POST"
endpoint = "/v1/team/Text%20Mining%20Provider/query"
body = {
    "submitter": "bte-dev-tester-manual",
    "message": {
        "query_graph": {
            "nodes": {
                "n0": {"categories": ["biolink:Gene"], "ids": ["NCBIGene:3778"]},
                "n1": {"categories": ["biolink:Gene"]},
            },
            "edges": {
                "e01": {
                    "subject": "n0",
                    "object": "n1",
                    "predicates": ["biolink:regulates"],
                }
            },
        }
    },
}
tests = [
    kg.node_count,
    kg.edge_count,
    results.result_count,
    logs.no_error_logs,
    logs.log_one_api,
]
