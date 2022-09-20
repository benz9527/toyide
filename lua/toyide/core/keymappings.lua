local M = {}
-- noremap means only map key for once (one level)
-- example: a -> b -> c, if noremap is true, press a eq to press b; otherwise, pres a eq to press c.
-- silent option will not be echoed on the command line.
-- :h :map-<silent>
local generic_opts_any = { noremap = true, silent = true }

-- The doc about vim.keymap and vim.api.nvim_set_keymap
-- https://neovim.io/doc/user/map.html
-- vim.keymap is lua module. We can add callback function expression for keymap.
-- https://neovim.io/doc/user/lua.html
-- vim.api.nvim_set_keymap
-- https://neovim.io/doc/user/api.html#nvim_set_keymap()

-- How to query the options of nvim keymapping?
-- :h map-commands, check the 1.2 special arguments
-- https://github.com/neovim/neovim/issues/17356
-- :h nvim_set_keymap(), see the Parameters opts it has
-- been added a new option named desc.
local generic_opts = {
    insert_mode = generic_opts_any,
    normal_mode = generic_opts_any,
    visual_mode = generic_opts_any,
    visual_block_mode = generic_opts_any,
    command_mode = generic_opts_any,
    terminal_mode = { silent = true },
}

local mode_adapters = {
    insert_mode = "i",
    normal_mode = "n",
    terminal_mode = "t",
    visual_mode = "v",
    visual_block_mode = "x",
    command_mode = "c", -- Last line mode.
}

-- <CR> is Enter
-- <A> or <M> is Alt
-- <C> is Ctrl
-- <S> is Shift
-- <ESC> is Escape
-- <leader> set as <SPACE>
-- <cmd> is command mode character ':'

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- key as redefined shortcut key
-- value as a table:
-- origin as original shortcut key or command line
-- desc as the shortcut key working content
-- opts as the additional options bond to the shortcut key
M.km_general = {
    enable = true, -- Indicating enable and first load or not.
    insert_mode = {
        ["<C-q>"] = { origin = "<ESC>", desc = "exit the insert mode", opts = nil, },
        -- Quickly positioning in a line.
        ["<C-a>"] = { origin = "<ESC>^i", desc = "ahead of line", opts = nil, },
        ["<C-e>"] = { origin = "<End>", desc = "end of line", opts = nil, },
        -- Other navigations.
        -- <Left>, <Right>, <Down>, <Up>
        -- Window navigations. Mobaxterm will have no effect on below shortcuts.
        ["<C-j>"] = { origin = "<ESC><C-w>ja", desc = "switch to bottom window", opts = nil, },
        ["<C-k>"] = { origin = "<ESC><C-w>ka", desc=  "switch to upper window", opts = nil, },
        ["<C-h>"] = { origin = "<ESC><C-w>ha", desc = "switch to left window", opts = nil, },
        ["<C-l>"] = { origin = "<ESC><C-w>la", desc = "switch to right window", opts = nil, },

        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { origin = "<cmd>move .-2<CR>==", desc = "move current line/block up", opts = nil, },
        ["<A-Down>"] = { origin = "<cmd>move .+1<CR>==", desc = "move current line/block down", opts = nil, },
    },
    normal_mode = {
        -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        -- From NvChad.
        ["j"] = { origin = 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', desc = "move downward ignore wrapped line", opts = { expr = true }, },
        ["k"] = { origin = 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', desc = "move upward ignore wrapped line", opts = { expr = true }, },
        ["<Down>"] = { origin = 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', desc = "move downward ignore wrapped line", opts = { expr = true }, },
        ["<Up>"] = { origin = 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', desc = "move upward ignore wrapped line", opts = { expr = true }, },

        -- Switch between windows.
        -- <C-j> has alias <NL> "new line".
        ["<C-j>"] = { origin = "<C-w>j", desc = "switch to bottom window", opts = nil, },
        ["<C-k>"] = { origin = "<C-w>k", desc = "switch to upper window", opts = nil, },
        ["<C-h>"] = { origin = "<C-w>h", desc = "switch to left window", opts = nil, },
        ["<C-l>"] = { origin = "<C-w>l", desc = "switch to right window", opts = nil, },

        -- Quickly flush buffer changes into file.
        ["<C-s>"] = { origin = "<cmd>w<CR>", desc = "save file", opts = nil, },

        -- Copy all.
        ["<C-a>c"] = { origin = "<cmd>%y+<CR>", desc = "copy whole file content", opts = nil, },

        -- Resize the current window.
        ["<C-Up>"] = { origin = "<cmd>resize +2<CR>", desc = "increase the bottom height of current window", opts = nil, },
        ["<C-Down>"] = { origin = "<cmd>resize -2<CR>", desc = "decrease the bottom height of current window", opts = nil, },
        ["<C-Left>"] = { origin = "<cmd>vertical resize -2<CR>", desc = "decrease the width of current window", opts = nil, },
        ["<C-Right>"] = { origin = "<cmd>vertical resize +2<CR>", desc = "increase the width of current window", opts = nil, },

        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { origin = "<cmd>move .-2<CR>==", desc = "move current line/block up", opts = nil, },
        ["<A-Down>"] = { origin = "<cmd>move .+1<CR>==", desc = "move current line/block down", opts = nil, },
    },
    terminal_mode = {
        -- <C-\\><C-N> only works for terminal mode, it used to exit terminal mode.
        -- :h terminal
        -- :tnoremap <Esc> <C-\\><C-N>
        ["<C-j>"] = { origin = "<C-\\><C-N><C-w>j", desc = "switch to bottom terminal window", opts = nil, },
        ["<C-k>"] = { origin = "<C-\\><C-N><C-w>k", desc = "switch to upper terminal window", opts = nil, },
        ["<C-h>"] = { origin = "<C-\\><C-N><C-w>h", desc = "switch to left terminal window", opts = nil, },
        ["<C-l>"] = { origin = "<C-\\><C-N><C-w>l", desc = "switch to right terminal window", opts = nil, },
    },
    visual_mode = {
        -- Selected line/block do better indent.
        [">"] = { origin = ">gv", desc = "right indenting", opts = nil, },
        ["<"] = { origin = "<gv", desc = "left indenting", opts = nil, },
    },
    visual_block_mode = {
        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { origin = "<cmd>move '<-2<CR>gv-gv", desc = "move current line/block up", opts = nil, },
        ["<A-Down>"] = { origin = "<cmd>move '>+1<CR>gv-gv", desc = "move current line/block down", opts = nil, },
    },
    command_mode = {
        -- Tab completion items navigation. Replace the <Tab> as down and <S-Tab> as up.
        -- <Up> & <Down> in command mode is used to lookup history.
        ["<C-j>"] = { origin = 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', desc = "select the next item", opts = { expr = true, noremap = true, }, },
        ["<C-k>"] = { origin = 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', desc = "select the previous item", opts = { expr = true, noremap = true, }, },
    },
}

M.km_whichkey = {
    enable = false, -- Indicating enable and first load or not.
    normal_mode = {
        ["<leader>wk"] = {
            origin = function()
                -- ignore <ESC> or other empty input to make errors.
                safe_input({ prompt = "WhichKey: ", }, function(input_key)
                    if type(input_key) == "nil" or input_key == '' then
                        return
                    end
                    vim.cmd("WhichKey " .. input_key)
                end)
            end,
            desc = "which-key query lookup by input",
            opts = nil,
        },
        ["<leader>WK"] = {
            origin = function()
                vim.cmd("WhichKey")
            end,
            desc = "which-key display all keymaps",
            opts = nil,
        },
    },
}

M.km_mason_lspconfig = {
    enable = false,
    normal_mode = {
        ["gD"] = { origin = "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "goto the declaration", opts = nil, },
        ["gd"] = { origin = "<cmd>lua vim.lsp.bug.definition()<CR>", desc = "goto the definition", opts = nil, },
        ["K"] = { origin = "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover", opts = nil, },
        ["gi"] = { origin = "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "goto the implementation", opts = nil, },
        ["<C-k>"] = { origin = "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "show signature help info", opts = nil, },
        ["gr"] = { origin = "<cmd>lua vim.lsp.buf.references()<CR>", desc = "goto the references", opts = nil, },
        ["[d"] = { origin = [[<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>]], desc = "goto previous item", opts = nil, },
        ["]d"] = { origin = [[<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>]], desc = "goto next item", opts = nil, },
        ["gl"] = { origin = [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>]], desc = "show line diagnostic", opts = nil, },
        ["<leader>q"] = { origin = [[<cmd>lua vim.diagnostic.setloclist()<CR>]], desc = "diagnostic set loc list", opts = nil, },
        ["<leader>wa"] = { origin = [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]], desc = "add workspace folder", opts = nil, },
        ["<leader>wr"] = { origin = [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]], desc = "remove workspace folder", opts = nil, },
        ["<leader>wl"] = { origin = [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]], desc = "print workspace folders", opts = nil, },
        ["<leader>D"] = { origin = [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], desc = "type definition", opts = nil, },
        ["<leader>rn"] = { origin = [[<cmd>lua vim.lsp.buf.rename()<CR>]], desc = "rename", opts = nil, },
    },
}

-- functions
function M.load_keymappings(plugin_name)
    local function set_plugin_km(plugin_km_settings)
        -- Skipping reload.
        -- Skipping unloaded plugin keymap setting.
        if not plugin_km_settings.enable then
            return
        end

        -- Remove those values which are not table actually.
        -- Otherwise, the for...iterator pairs will run with error.
        plugin_km_settings.enable = nil

        for mode, values in pairs(plugin_km_settings) do
            -- :h maparg()
            local opts = generic_opts[mode]
            for redefined_keybinding, km_info_tbl in pairs(values) do
                if km_info_tbl.opts then
                    opts = km_info_tbl.opts
                end
                opts.desc = km_info_tbl.desc
                vim.keymap.set(mode_adapters[mode], redefined_keybinding, km_info_tbl.origin, opts)
            end
        end
    end

    local mapping = nil
    if type(plugin_name) == "nil" or string.match(plugin_name, "^%s+$") == plugin_name then
        mapping = M.km_general
    else
        mapping = M["km_" .. plugin_name]
    end

    set_plugin_km(mapping)
end

function M.plugin_enable_and_load_km(plugin_name)
    if type(plugin_name) == "nil" or string.match(plugin_name, "^%s+$") == plugin_name then
        return
    end

    local mapping = M["km_" .. plugin_name]
    mapping.enable = true
    M.load_keymappings(plugin_name)
end

return M