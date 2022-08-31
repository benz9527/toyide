local l_status_ok, nvim_lsp = pcall(require, "lspconfig")
if not l_status_ok then
    return
end

-- https://github.com/williamboman/mason.nvim/blob/main/doc/mason.txt
-- https://github.com/williamboman/nvim-lsp-installer/blob/main/doc/nvim-lsp-installer.txt
local m_status_ok, mason = pcall(require, "mason")
if not m_status_ok then
    return
end

mason.setup({
    -- Open nvim
    -- :h stdpath()
    -- :echo stdpath("data")
    install_root_dir = vim.fn.stdpath "data" .. "/lsp",
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 2,
    ui = {
        check_outdated_package_on_open = true,
        -- https://neovim.io/doc/user/api.html#nvim_open_win()
        border = "rounded",
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
        keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            uninstall_package = "x",
            update_package = "u",
            update_all_packages = "U",
            check_package_version = "v",
            check_outdated_packages = "c",
            cancel_installation = "C",
            apply_language_filter = "F",
        },
        -- For China mainland dev to use.
        pip = {
            install_args = {
                "--index-url", "https://pypi.tuna.tsinghua.edu.cn/simple",
                "--trusted-host", "pypi.tuna.tsinghua.edu.cn",
            },
        },
    }
})

-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/mason-lspconfig.txt
local mc_status_ok, mason_cfg = pcall(require, "mason-lspconfig")
if not mc_status_ok then
    return
end

local common_opts = {
    -- on_attach is default key.
    on_attach = require("toyide.lsp.handlers").on_attach,
    -- capabilities is default key.
    capabilities = require("toyide.lsp.handlers").capabilities,
}
mason_cfg.setup({
    automatic_installation = false,
})
mason_cfg.setup_handlers {
    -- Called for each installed lsp server.
    function(server_name)
        nvim_lsp[server_name].setup(common_opts)
    end,
    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    ["jsonls"] = function ()
        -- :h tbl_deep_extend
        -- Force to use the right most table values.
        -- https://github.com/hrsh7th/nvim-cmp enable the completion for this LSP by capabilities.
        local tmp = require("toyide.lsp.settings.jsonls")
        local opts = vim.tbl_deep_extend("force", tmp, common_opts)
        nvim_lsp.jsonls.setup(opts)
    end,
    ["sumneko_lua"] = function()
        local tmp = require("toyide.lsp.settings.sumneko_lua")
        local opts = vim.tbl_deep_extend("force", tmp, common_opts)
        nvim_lsp.sumneko_lua.setup(opts)
    end,
}

require("toyide.lsp.handlers").setup()