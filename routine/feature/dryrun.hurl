POST {{hostname}}/v1/query
[QueryStringParams]
dryrun: true

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
jsonpath "$.message.results" count == 0
jsonpath "$.logs[*].message" includes "Running dryrun of query, no API calls will be performed. Actual query execution order may vary based on API responses received."
