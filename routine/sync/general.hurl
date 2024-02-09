POST {{hostname}}/v1/query

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
