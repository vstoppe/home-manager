; extends

(
  (block_mapping_pair
    key: (flow_node
      (plain_scalar
        (string_scalar) @key_name))
    value: (block_node
      (block_scalar) @injection_content))
  (#any-of? @key_name "values" "valuesContent")
  (#offset! @injection_content 1 1 0 0)
  (#set! injection.language "helm")
)


(block_node
  (block_scalar) @injection.content
  (#lua-match? @injection.content "^|\n%s*#cloud%-config%s*\n")
  (#offset! @injection.content 0 1 0 0)
  (#set! injection.language "yaml"))

