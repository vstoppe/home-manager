return require("schema-companion").setup_client(
  require("schema-companion").adapters.yamlls.setup({
    sources = {
      -- your sources for the language server
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
      require("schema-companion").sources.lsp.setup(),
      require("schema-companion").sources.schemas.setup({
        {
          name = "Kubernetes master",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
        },
        {
          name = "Argo CD Application",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"
        },
        {
          name = "Argo Workflows",
          uri  = "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"
        },
        {
          name = "docker-compose.yml",
          uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"
        },
        {
          name = "helmfile",
          uri = "https://json.schemastore.org/helmfile.json"
        },
        {
          name = "Helm Chart.yaml",
          uri  = "https://json.schemastore.org/chart.json"
        },
        {
          name = "SealedSecret",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json"
        },
        -- schemas below are automatically loaded, but added
        -- them here so that they show up in the statusline
        {
          name = "Kustomization",
          uri = "https://json.schemastore.org/kustomization.json"
        },
        {
          name = "GitHub Workflow",
          uri = "https://json.schemastore.org/github-workflow.json"
        },
      }),
    },
  }),
  {
    vim.lsp.enable('yamlls')
  }
)
