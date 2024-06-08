return {
	{  -- file explorer
		"lambdalisue/fern.vim", 
		keys = { -- lazy load 
			{ "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=30<CR>", desc = "toggle fern" },
		},
		dependencies = {
			{ "lambdalisue/nerdfont.vim", },
			{
			      "lambdalisue/fern-renderer-nerdfont.vim",
			      config = function()
				vim.g["fern#renderer"] = "nerdfont"
				vim.g["fern#default_hidden"] = "1"
			      end
			},
		},
	}, 
	{ --coloer scheam
	  "folke/tokyonight.nvim",
	  lazy = false,
	  priority = 1000,
	  opts = {},
	},
	{ -- bottom bar desing
	    "nvim-lualine/lualine.nvim",
	    dependencies = { "nvim-tree/nvim-web-devicons" }
	}, 
  	{ -- buffer tab
		"romgrk/barbar.nvim",
		event = "BufAdd",
		-- event = "VimEnter",
		keys = {
			{"<Del>",  "<Cmd>BufferClose<CR>"},
			{"<C-j>",  "<Cmd>BufferPrevious<CR>"},
			{"<C-k>",  "<Cmd>BufferNext<CR>"},
		},
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			animation = true,
			-- insert_at_start = true,
			-- …etc.
			},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
	-- LSP
	{ 
		"neovim/nvim-lspconfig",
--		event = "VimEnter"
	},
	{
		"williamboman/mason.nvim",
-- 		cmd = { "Mason", "MasonInstall" },
--		build = ":MasonUpdate",
-- 		event = "VimEnter",
		-- event = { "BufReadPre", "VimEnter" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
--		event = "BufReadPre", 
		-- build = ":MasonUpdate",
		-- cmd = {
		--     "Mason",
		--     "MasonInstall",
		--     "MasonUninstall",
		--     "MasonUninstallAll",
		--     "MasonLog",
		--     "MasonUpdate",
		--   },
	},
	{
		"hrsh7th/nvim-cmp",
		event = "VimEnter",
		dependencies = {
		    { "hrsh7th/cmp-nvim-lsp" },
		    { "hrsh7th/cmp-path" }, 
		    { "hrsh7th/cmp-buffer" },
		    { "hrsh7th/vim-vsnip" }, 
		    { "hrsh7th/cmp-emoji" },
		    { "hrsh7th/cmp-vsnip" },
		},
	},
	{ "onsails/lspkind.nvim" },
 	{ -- looks lsp
 		"nvimdev/lspsaga.nvim",
 		-- config = function()
 		-- require("lspsaga").setup({})
 		-- end,
 		dependencies = {
 			"nvim-treesitter/nvim-treesitter", -- optional
 			"nvim-tree/nvim-web-devicons"     -- optional
 		},
     }
}
