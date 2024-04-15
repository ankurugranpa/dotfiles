local pid = vim.fn.getpid()
-- on Windows
local omnisharp_bin = "C:/Users/yukit/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/OmniSharp.exe"

local config = {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) },
  -- rest of your settings
}

require'lspconfig'.omnisharp.setup(config)
