POST {{hostname}}/v1/query
{
  "submitter": "bte-dev-tester-jackson",
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
result-count: jsonpath "$.message.results" count


POST {{hostname}}/v1/query
{
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
jsonpath "$.logs[*].message" includes "BTE finds cached records for e01"
jsonpath "$.message.results" count == {{result-count}}
