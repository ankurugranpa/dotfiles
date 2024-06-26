-- install_lsp.lua
local mason = require("mason")
local registry = require("mason-registry")

mason.setup()
registry.refresh()

local packages = {
    "pyright",
    "clangd",
    "cmake-language-server"
}

for _, pkg_name in ipairs(packages) do
    local pkg = registry.get_package(pkg_name)
    if not pkg:is_installed() then
        pkg:install()
    end
end
