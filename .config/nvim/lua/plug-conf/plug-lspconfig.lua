-- load lsp setting
local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup{ 
	function(server_name)

	local opts = {}
	opts.on_attach = function(_, bufnr)

	local bufopts = { silent = true, buffer = bufnr }
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>p', vim.lsp.buf.format, bufopts)
	end
	nvim_lsp[server_name].setup(opts)
	end 
}

-- Python Setting
require("lspconfig").pyright.setup{
	settings = {
		python = {
			venvPath = ".",
			pythonPath = "./.venv/bin/python",
			-- pythonPath = "/usr/local/bin/python",
			analysis = {
				extraPaths = {"."}
			}
		}
	}
}


nvim_lsp.biome.setup({
  cmd = { "biome", "lsp-proxy" }, -- biome は `lsp-proxy` サブコマンドで起動する
  filetypes = { "javascript", "typescript", "json", "jsonc", "markdown" ,  "typescriptreact"},
  root_dir = nvim_lsp.util.root_pattern("biome.json", "biome.jsonc", ".git"),
  settings = {},
})

