# Using nephrotic syndrome as an example
POST {{hostname}}/v1/query
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
            "MONDO:0005377"
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
[Captures]
response-time: duration
result-count: jsonpath "$.message.results" count


POST {{hostname}}/v1/query
{
  "message": {
    "query_graph": {
      "nodes": {
        "n02": {
          "categories": [
            "biolink:Disease"
          ],
          "ids": [
            "MONDO:0005377"
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
# Should find cached records during template run on template edge
jsonpath "$.logs[*].message" includes "[Template-1]: BTE finds cached records for eA"
jsonpath "$.message.results" count == {{result-count}}
