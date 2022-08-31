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
    ui = {
        check_outdated_package_on_open = true,
        -- https://neovim.io/doc/user/api.html#nvim_open_win()
        border = "rounded",
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 2,
        -- Open nvim
        -- :h stdpath()
        -- :echo stdpath("data")
        install_root_dir = path.concat {
            vim.fn.stdpath("data"), "lsp"
        },
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

local h_status_ok, handlers = pcall(require, "toyide.lsp.handlers")
if not h_status_ok then
    return
end
handlers.setup()

-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/mason-lspconfig.txt
local mc_status_ok, mason_cfg = pcall(require, "mason-lspconfig")
if not mc_status_ok then
    return
end

mason_cfg.setup({
    automatic_installation = false,
})
mason_cfg.setup_handlers {
    -- Called for each installed lsp server.
    function(server_name)
        local opts = {
            -- on_attach is default key.
            on_attach = handlers.on_attach,
            -- capabilities is default key.
            capabilities = handlers.capabilities,
        }
        nvim_lsp[server_name].setup(opts)
    end,
    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    ["jsonls"] = function ()
        local  opts = require("toyide.lsp.settings.jsonls")
        require("json-lsp").setup(opts)
    end,
}
