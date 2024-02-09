reduce .message.knowledge_graph.edges[] as $edge (
  {}; .[$edge.subject] += 1 | .[$edge.object] += 1
)
| to_entries
| sort_by(.value)
| reverse
| from_entries
