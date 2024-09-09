POST {{hostname}}/v1/asyncquery

{
  "message": {
    "query_graph": {
      "nodes": {
        "input": {
          "categories": [
            "biolink:PhenotypicFeature"
          ],
          "ids": [
            "uuid:1"
          ],
          "member_ids": [
            "HP:0002098",
            "HP:0001252",
            "HP:0001250"
          ],
          "set_interpretation": "MANY"
        },
        "output": {
          "categories": [
            "biolink:Gene"
          ]
        }
      },
      "edges": {
        "edge_0": {
          "subject": "input",
          "object": "output",
          "predicates": [
            "biolink:genetically_associated_with"
          ],
          "knowledge_type": "inferred"
        }
      }
    }
  }
}


HTTP 501
# [Asserts]
# jsonpath "$.message.knowledge_graph.nodes[*]" count > 0
# jsonpath "$.message.knowledge_graph.edges[*]" count > 0
# jsonpath "$.message.results" count > 0
# jsonpath "$.logs[*].level" not includes "ERROR"
