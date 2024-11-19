from trapi_testing_tools.tests import http

method = "POST"
endpoint = "/v1/asyncquery"
body = {
    "message": {
        "query_graph": {
            "nodes": {
                "input": {
                    "categories": ["biolink:PhenotypicFeature"],
                    "ids": ["uuid:1"],
                    "member_ids": ["HP:0002098", "HP:0001252", "HP:0001250"],
                    "set_interpretation": "MANY",
                },
                "output": {"categories": ["biolink:Gene"]},
            },
            "edges": {
                "edge_0": {
                    "subject": "input",
                    "object": "output",
                    "predicates": ["biolink:genetically_associated_with"],
                    "knowledge_type": "inferred",
                }
            },
        }
    }
}
tests = [http.status(501)]
