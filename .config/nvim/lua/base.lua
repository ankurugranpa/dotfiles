vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"

vim.wo.number = true

-- load plugin list
local plugins = require('plugins')

-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)

-- set masson 
local mason = require('mason')
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

-- load lsp setting
local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({ 
	function(server_name)

	local opts = {}
	opts.on_attach = function(_, bufnr)

	local bufopts = { silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>p', vim.lsp.buf.format, bufopts)
	end
	nvim_lsp[server_name].setup(opts)
	end 
})

local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
cmp.setup({
	mapping = cmp.mapping.preset.insert({
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = 'nvim_lsp', priority = 100 },
			{ name = 'vsnip', priority = 70 },
			{ name = 'emoji', priority = 50, insert = true },
		}, 
		{
			{ name = 'buffer' },
		}),
		snippet = {
			expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
		},
		formatting = {
			format = require('lspkind').cmp_format({
			    with_text = true,
			    menu = {
				buffer = "[A]",
				nvim_lsp = "[LSP]",
				vsnip = "[snip]",
				emoji = "[emoji]",
			    },
			})
		},
})
