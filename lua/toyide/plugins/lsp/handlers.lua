-- References:
-- https://www.getman.io/posts/programming-go-in-neovim/

local M = {}

-- Called by ./init.lua
M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
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

local function lsp_highlight_doc(client)
    -- Set autocommands conditional on server capabilities
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
end

local function lsp_km(bufnr)
    local function km(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }
    km("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    km("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    km("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    km("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    km("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    km("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    km("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    km("n", "gl", '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ borderi = "rounded" })<CR>', opts)
    km("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    km("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    km('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    km('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    km('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    km('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    km('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

M.on_attach = function(client, bufnr)
    local function set_opts(...) vim.api.nvim_buf_set_option(bufnr, ...)  end
    -- :h ofu
    -- :h omnifunc
    set_opts("ofu", "v:lua.vim.lsp.omnifunc")
    lsp_km(bufnr)
    lsp_highlight_doc(client)
end

-- https://github.com/hrsh7th/nvim-cmp enable the completion for this LSP by capabilities.
local caps = vim.lsp.protocol.make_client_capabilities()
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(caps)
return M