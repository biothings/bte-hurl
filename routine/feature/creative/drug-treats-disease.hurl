# Using nephrotic syndrome as an example
POST {{hostname}}/v1/asyncquery
{
  "submitter": "bte-dev-tester-jackson",
  "message": {
    "query_graph": {
      "nodes": {
        "n02": {
          "categories": [
            "biolink:Disease"
          ],
          "ids": [
            "MONDO:0016575"
          ]
        },
        "n01": {
          "categories": [
            "biolink:ChemicalEntity"
          ]
        }
      },
      "edges": {
        "e01": {
          "subject": "n01",
          "object": "n02",
          "predicates": [
            "biolink:treats"
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
job_url: jsonpath "$.job_url"

GET {{job_url}}
[Options]
retry: 20
retry-interval: 30000

HTTP 200
[Asserts]
jsonpath "$.status" == "Completed"
jsonpath "$.logs[*].level" not includes "ERROR"
[Captures]
response_url: jsonpath "$.response_url"

GET {{response_url}}
[Options]
retry: 5
retry-interval: 1000

HTTP 200
