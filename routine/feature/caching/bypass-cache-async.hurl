POST {{hostname}}/v1/asyncquery
{
  "submitter": "bte-dev-tester-manual",
  "bypass_cache": true,
  "message": {
    "query_graph": {
      "edges": {
        "e01": {
          "subject": "n0",
          "object": "n1"
        }
      },
      "nodes": {
        "n0": {
          "ids": [
            "MONDO:0019391"
          ],
          "categories": [
            "biolink:Disease"
          ]
        },
        "n1": {
          "categories": [
            "biolink:Gene"
          ]
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
retry: 20
retry-interval: 3000

HTTP 200
[Asserts]
jsonpath "$.message.knowledge_graph.nodes[*]" count > 0
jsonpath "$.message.knowledge_graph.edges[*]" count > 0
jsonpath "$.message.results" count > 0
jsonpath "$.logs[*].level" not includes "ERROR"
jsonpath "$.logs[*].message" includes "REDIS cache is not enabled."
