GET {{hostname}}/v1/team/Text%20Mining%20Provider/meta_knowledge_graph

HTTP 200
[Asserts]
jsonpath "$.nodes[*]" count > 1
jsonpath "$.edges[*]" count > 1
