[
  .logs[].message
  | select(. | contains("took"))
]
| reduce .[] as $msg (
  {}; .[$msg | split(" ")[0]] += 1
) 
