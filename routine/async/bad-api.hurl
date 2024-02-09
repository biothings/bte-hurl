POST {{hostname}}/v1/smartapi/{{id}}/asyncquery
[Options]
variable: id=lalala
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
# There should be a log stating the API is invalid
jsonpath "$.status" == "Completed"
jsonpath "$.logs[*].level" includes "ERROR"
jsonpath "$.logs[*].message" includes "Specified SmartAPI ID({{id}}) is either invalid or missing."
