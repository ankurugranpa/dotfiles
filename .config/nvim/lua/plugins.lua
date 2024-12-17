return {
	-- {  -- file explorer
	-- 	"lambdalisue/fern.vim", 
	-- 	keys = { -- lazy load 
	-- 		{ "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=30<CR>", desc = "toggle fern" },
	-- 	},
	-- 	dependencies = {
	-- 		{ "lambdalisue/nerdfont.vim", },
	-- 		{
	-- 		      "lambdalisue/fern-renderer-nerdfont.vim",
	-- 		      config = function()
	-- 			vim.g["fern#renderer"] = "nerdfont"
	-- 			vim.g["fern#default_hidden"] = "1"
	-- 		      end
	-- 		},
	-- 	},
	-- },
  {
    "xiyaowong/transparent.nvim"
  },
  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      -- vim.g.vimtex_view_method = "zathura"
    end
  },
	{
		"nvim-neo-tree/neo-tree.nvim",
    		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    		}
	},
	-- UI
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = true
	},
	-- lazy.nvim
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 	  -- add any options here
	-- 	},
	-- 	dependencies = {
	-- 	  -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	-- 	  "MunifTanjim/nui.nvim",
	-- 	  -- OPTIONAL:
	-- 	  --   `nvim-notify` is only needed, if you want to use the notification view.
	-- 	  --   If not available, we use `mini` as the fallback
	-- 	  "rcarriga/nvim-notify",
	-- 	}
	-- },
	-- Finder
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
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
		    { "onsails/lspkind.nvim" },

		},
	},
 	{ -- looks lsp
 		"nvimdev/lspsaga.nvim",
 		-- config = function()
 		-- require("lspsaga").setup({})
 		-- end,
 		dependencies = {
 			"nvim-treesitter/nvim-treesitter", -- optional
 			"nvim-tree/nvim-web-devicons"     -- optional
 		},
        },
	{ -- indent view
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
	},
	{
		"SmiteshP/nvim-navic",
	},
	{
		'stevearc/aerial.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = {
		   "nvim-treesitter/nvim-treesitter",
		   "nvim-tree/nvim-web-devicons"
		},
	},
	{
	  "folke/trouble.nvim",
	  opts = {}, -- for default options, refer to the configuration section for custom setup.
	  cmd = "Trouble",
	  keys = {
	    {
	      "<leader>xx",
	      "<cmd>Trouble diagnostics toggle<cr>",
	      desc = "Diagnostics (Trouble)",
	    },
	    {
	      "<leader>xX",
	      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	      desc = "Buffer Diagnostics (Trouble)",
	    },
	    {
	      "<leader>cs",
	      "<cmd>Trouble symbols toggle focus=false<cr>",
	      desc = "Symbols (Trouble)",
	    },
	    {
	      "<leader>cl",
	      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	      desc = "LSP Definitions / references / ... (Trouble)",
	    },
	    {
	      "<leader>xL",
	      "<cmd>Trouble loclist toggle<cr>",
	      desc = "Location List (Trouble)",
	    },
	    {
	      "<leader>xQ",
	      "<cmd>Trouble qflist toggle<cr>",
	      desc = "Quickfix List (Trouble)",
	    },
	  },
	},
	{
	    "CopilotC-Nvim/CopilotChat.nvim",
	    branch = "canary",
	    dependencies = {
	      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
	      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	    },
	    opts = {
	      debug = true, -- Enable debugging
	      -- See Configuration section for rest
	    },
	    -- See Commands section for default commands if you want to lazy load on them
	},
}
