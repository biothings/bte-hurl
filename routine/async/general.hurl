POST {{hostname}}/v1/asyncquery
{
  "submitter": "bte-dev-tester-jackson",
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
job_url: jsonpath "$.job_url"

GET {{job_url}}
[Options]
retry: 20
retry-interval: 3000

HTTP 200
[Asserts]
jsonpath "$.status" == "Completed"
jsonpath "$.logs[*].level" not includes "ERROR"
