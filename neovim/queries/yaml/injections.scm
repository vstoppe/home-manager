; extends

( block_mapping_pair
    key: (flow_node (plain_scalar) @key)
    value: (block_node (block_scalar) @injection.content)
  (#any-of? @key "values" "valuesContent")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "helm"))


(block_node
  (block_scalar) @injection.content
  (#lua-match? @injection.content "^|\n%s*#cloud%-config%s*\n")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "yaml"))
