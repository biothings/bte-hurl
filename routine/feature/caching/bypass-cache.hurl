POST {{hostname}}/v1/query
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
jsonpath "$.logs[*].message" includes "REDIS cache is not enabled."

