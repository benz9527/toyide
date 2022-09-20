-- Language Server Protocol Installer
---@docs https://neovim.io/doc/lsp/

local function mason_init()
    local is_present, mason = pcall(require, "mason")
    if not is_present then
        vim.notify("mason plugin not exists!")
        return
    end

    local opts = {
        install_root_dir = join_paths(get_runtime_dir(), "lsp"),
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 2,
        ui = {
            check_outdated_package_on_open = true,
            ---@docs https://neovim.io/doc/user/api.html#nvim_open_win()
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
    }
    mason.setup(opts)
end

local function mason_lspconfig_init()
    local is_present, mason_cfg = pcall(require, "mason-lspconfig")
    if not is_present then
        vim.notify("mason lspconfig plugin not exists!")
        return
    end

    local opts = {
        on_attach = function(client, bufnr)
            local function set_opts(...) vim.api.nvim_buf_set_option(bufnr, ...) end
            ---@docs :h ofu / :h omnifunc
            set_opts("ofu", "v:lua.vim.lsp.omnifunc")
            local km = require("toyide.core.keymappings")
            km.plugin_enable_and_load_km("mason_lspconfig")
            vim.cmd [[  command! Format execute 'lua vim.lsp.buf.formatting()' ]]
            -- TODO(Ben) Register the highlight autocmd
            if client.resolved_capabilities.document_highlight then
                vim.api.nvim_exec([[
                  hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
                  hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
                  hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
                  augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                  augroup END
                ]], false)
            end
        end,
        capabilities = function()
            local is_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if not is_ok then
                vim.notify("cmp nvim lsp plugins not exists!")
                return
            end
            local caps = vim.lsp.protocol.make_client_capabilities()
            return cmp_nvim_lsp.update_capabilities(caps)
        end,
    }

    mason_cfg.setup(opts)
end

local function diagnostic_setup()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texth1 = sign.name, text = sign.text, numh1 = "" })
    end

    local cfg = {
        virtual_text = false,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(cfg)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local mason = {
    -- Enable the lsp first.
    ["neovim/nvim-lspconfig"] = {

    },
    -- Old application of lsp installer is https://github.com/williamboman/nvim-lsp-installer.
    ["williamboman/mason.nvim"] = {
        disable = false,
        opt = true,
        config = mason_init,
    },
    ["williamboman/mason-lspconfig.nvim"] = {
        disable = false,
        opt = true,
        config = mason_lspconfig_init,
    },
    ["antoinemadec/FixCursorHold.nvim"] = {
        -- Needed while issue https://github.com/neovim/neovim/issues/12587
    },
}

local is_present, plg_core = pcall(require, "toyide.plugins.configs.core")
if not is_present then
    return
end

plg_core.register(mason)
diagnostic_setup()