POST {{hostname}}/v1/asyncquery
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
            "NCBIGene:3778"
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
            "biolink:regulates"
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

# Check initial response acts like asyncquery_status
GET {{hostname}}/v1/asyncquery_response/{{job_id}}
[Options]
retry: 20
retry-interval: 3000

HTTP 200
[Asserts]
jsonpath "$.status" == "Running"
jsonpath "$.logs[*].level" not includes "ERROR"
jsonpath "$.message" not exists

# Check status endpoint shows Completed
GET {{hostname}}/v1/asyncquery_status/{{job_id}}
[Options]
retry: 20
retry-interval: 3000

HTTP 200
[Asserts]
jsonpath "$.status" == "Completed"
jsonpath "$.logs[*].level" not includes "ERROR"
jsonpath "$.message" not exists

# Check response eventually has full TRAPI response
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
