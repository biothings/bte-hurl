POST {{hostname}}/v1/query
[QueryStringParams]
caching: false
{
  "submitter": "bte-dev-tester-manual",
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
[Captures]
response-time: duration


POST {{hostname}}/v1/query
[QueryStringParams]
caching: false
{
  "submitter": "bte-dev-tester-manual",
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
jsonpath "$.logs[*].message" not includes "BTE finds cached records for e01"
