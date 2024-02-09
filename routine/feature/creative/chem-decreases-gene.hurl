# Using DYRK1A as an example
POST {{hostname}}/v1/asyncquery
{
  "submitter": "bte-dev-tester-jackson",
  "message": {
    "query_graph": {
      "nodes": {
        "gene": {
          "categories": [
            "biolink:Gene"
          ],
          "ids": [
            "NCBIGene:1859"
          ]
        },
        "chemical": {
          "categories": [
            "biolink:ChemicalEntity"
          ]
        }
      },
      "edges": {
        "t_edge": {
          "object": "gene",
          "subject": "chemical",
          "predicates": [
            "biolink:affects"
          ],
          "knowledge_type": "inferred",
          "qualifier_constraints": [
            {
              "qualifier_set": [
                {
                  "qualifier_type_id": "biolink:object_aspect_qualifier",
                  "qualifier_value": "activity_or_abundance"
                },
                {
                  "qualifier_type_id": "biolink:object_direction_qualifier",
                  "qualifier_value": "decreased"
                }
              ]
            }
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
retry-interval: 30000

HTTP 200
[Asserts]
jsonpath "$.status" == "Completed"
jsonpath "$.logs[*].level" not includes "ERROR"
