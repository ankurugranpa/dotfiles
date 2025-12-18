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
	  "coder/claudecode.nvim",
	  dependencies = { "folke/snacks.nvim" },
	  config = true,
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
  {'akinsho/git-conflict.nvim', version = "*", config = true},
	-- UI
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = true
	},
  {
		'anuvyklack/windows.nvim',
		dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim"
    }

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
    config = function()
      require("mason").setup()
    end,
-- 		cmd = { "Mason", "MasonInstall" },
--		build = ":MasonUpdate",
-- 		event = "VimEnter",
		-- event = { "BufReadPre", "VimEnter" },
	},
	-- lua/plugins/mason-lspconfig.lua
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local function on_attach(_, bufnr)
      local bufopts = { silent = true, buffer = bufnr }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "gtD", vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set("n", "grf", vim.lsp.buf.references, bufopts)
      vim.keymap.set("n", "<space>p", function()
        vim.lsp.buf.format({ async = true })
      end, bufopts)
    end

    local function get_python_path()
      local handle = io.popen("which python")
      if not handle then return nil end
      local result = handle:read("*a")
      handle:close()
      return result:gsub("%s+", "")
    end

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          vim.lsp.config(server_name, {
            on_attach = on_attach,
          })
        end,

        -- 個別上書き（pyright）
        pyright = function()
          vim.lsp.config("pyright", {
            on_attach = on_attach,
            settings = {
              python = {
                venvPath = ".",
                pythonPath = get_python_path(),
                analysis = {
                  extraPaths = { "." },
                },
              },
            },
          })
        end,

        -- biome
        biome = function()
          vim.lsp.config("biome", {
            on_attach = on_attach,
            cmd = { "biome", "lsp-proxy" },
            filetypes = {
              "javascript",
              "typescript",
              "typescriptreact",
              "json",
              "jsonc",
              "markdown",
            },
            root_dir = function(fname)
              return vim.fs.root(fname, {
                "biome.json",
                "biome.jsonc",
                ".git",
              })
            end,
          })
        end,
      },
    })
  end,
},
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	version = "*",
--	-- 	event = "BufReadPre", 
	-- 	-- build = ":MasonUpdate",
	-- 	-- cmd = {
	-- 	--     "Mason",
	-- 	--     "MasonInstall",
	-- 	--     "MasonUninstall",
	-- 	--     "MasonUninstallAll",
	-- 	--     "MasonLog",
	-- 	--     "MasonUpdate",
	-- 	--   },
	-- },
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
	    "mfussenegger/nvim-dap"
	  },
	  {
	    "rcarriga/nvim-dap-ui"
	  },
	  {
	    "mfussenegger/nvim-dap-python"
	  },
    {
    "olimorris/codecompanion.nvim",
      opts = {},
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
    },
    {
      "github/copilot.vim",
    }
	}
