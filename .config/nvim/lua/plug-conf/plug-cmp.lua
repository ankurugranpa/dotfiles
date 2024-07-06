local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
cmp.setup({
	mapping = cmp.mapping.preset.insert({
			['<CR>'] = cmp.mapping.confirm({ select = true }),
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			["<Tab>"] = cmp.mapping.select_next_item(),
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
				mode = 'symbol',
			    with_text = true,
			    menu = {
				buffer = "[A]",
				nvim_lsp = "[LSP]",
				vsnip = "[snip]",
				emoji = "[emoji]",
			    },
			})
		},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
      		},
	-- mapping = cmp.mapping.preset.insert({
	--       ['<C-d>'] = cmp.mapping.scroll_docs(-4),
	--       ["<Tab>"] = cmp.mapping.select_next_item(), 
	-- }),

})
