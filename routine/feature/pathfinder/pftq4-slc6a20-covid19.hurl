POST {{hostname}}/v1/asyncquery

{
  "message": {
    "query_graph": {
      "nodes": {
        "n0": {
          "ids": [
            "NCBIGene:54716"
          ]
        },
        "un": {
          "categories": [
            "biolink:NamedThing"
          ]
        },
        "n2": {
          "ids": [
            "MONDO:0100096"
          ]
        }
      },
      "edges": {
        "e0": {
          "subject": "n0",
          "object": "un",
          "predicates": [
            "biolink:related_to"
          ],
          "knowledge_type": "inferred"
        },
        "e1": {
          "subject": "un",
          "object": "n2",
          "predicates": [
            "biolink:related_to"
          ],
          "knowledge_type": "inferred"
        },
        "e2": {
          "subject": "n0",
          "object": "n2",
          "predicates": [
            "biolink:related_to"
          ],
          "knowledge_type": "inferred"
        }
      }
    }
  }
}

HTTP 200
[Asserts]
jsonpath "$.status" == "Accepted"
[Captures]
job_id: jsonpath "$.job_id"

GET {{hostname}}/v1/asyncquery_response/{{job_id}}
[Options]
retry: 10
retry-interval: 30000

HTTP 200
[Asserts]
jsonpath "$.message.knowledge_graph.nodes[*]" count > 0
jsonpath "$.message.knowledge_graph.edges[*]" count > 0
jsonpath "$.message.results" count > 0

