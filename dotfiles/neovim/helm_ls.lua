--- ~/.config/nvim/after/lsp/helm_ls.lua

---@type vim.lsp.ClientConfig
return require("schema-companion").setup_client(
	require("schema-companion").adapters.helmls.setup({
		sources = {
      -- this should match both the repository you had linked for the CRDs (https://github.com/datreeio/crds-catalog) and the builtin kubernetes schemas (https://github.com/yannh/kubernetes-json-schema)
			require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
      -- this will activate lsp as a source as well, this now depends on your helmls config below
			require("schema-companion").sources.lsp.setup(),
			require("schema-companion").sources.schemas.setup({
        -- Additional schemas can be added here as desired but you do not have to add the argocd schemas manually
        -- they will come from the matchers.kubernetes
			}),
		},
	}),
	{
		--- your additional language server config options here if you use it
    -- i think the bare minimum is to enable yaml-language-server here but that might have changed
		settings = {
			["helm-ls"] = {
        helmLint = {
          -- Allows to disable the diagnostics gathered with helm lint
          enabled = true,
          ignoredMessages = { "icon is recommended" },
        },
				yamlls = {
					enabled = true,
          diagnosticsLimit = 50,
          showDiagnosticsDirectly = true,
					path = "yaml-language-server",
					config = {
						validate = true,
						format = { enable = true },
						completion = true,
						hover = true,
						schemaDownload = { enable = true },
						schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
						-- any other config: https://github.com/redhat-developer/yaml-language-server#language-server-settings
					},
				},
			},
		},
	}
)
