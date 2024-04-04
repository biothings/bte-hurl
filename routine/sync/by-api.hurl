POST {{hostname}}/v1/smartapi/59dce17363dce279d389100834e43648/query
{
  "submitter": "bte-dev-tester-manual",
  "message": {
    "query_graph": {
      "nodes": {
        "n0": {
          "categories": [
            "biolink:Gene"
          ],
          "ids": [
            "NCBIGene:1017"
          ]
        },
        "n1": {
          "categories": [
            "biolink:Gene"
          ]
        }
      },
      "edges": {
        "e01": {
          "subject": "n0",
          "object": "n1",
          "predicates": [
            "biolink:related_to"
          ]
        }
      }
    }
  }
}

HTTP 200
[Asserts]
jsonpath "$.message.knowledge_graph.nodes[*]" count > 0
jsonpath "$.message.knowledge_graph.edges[*]" count > 0
jsonpath "$.message.results" count > 0
jsonpath "$.logs[-2:].message" nth 0 matches "\\(1\\) unique API"
jsonpath "$.logs[*].level" not includes "ERROR"
