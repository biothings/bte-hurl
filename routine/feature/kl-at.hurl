POST {{hostname}}/v1/smartapi/38e9e5169a72aee3659c9ddba956790d/query

{
  "message": {
    "query_graph": {
      "nodes": {
        "n0": {
          "categories": [
            "biolink:Gene"
          ],
          "ids": [
            "UniProtKB:Q08722"
          ]
        },
        "n1": {
          "categories": [
            "biolink:SmallMolecule"
          ]
        }
      },
      "edges": {
        "e01": {
          "subject": "n0",
          "object": "n1",
          "predicates": [
            "biolink:physically_interacts_with"
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
jsonpath "$.logs[*].level" not includes "ERROR"
