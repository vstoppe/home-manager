; Inject YAML into Helm values blocks

; extends

(
  block_mapping_pair
    key: (flow_node
           (plain_scalar) @key_name)
    value: (block_node
              (block_scalar) @injection.content)
  (#any-of? @key_name "values" "valuesContent")
  (#set! injection.language "yaml")
)
