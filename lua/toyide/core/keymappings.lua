local M = {}
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
        ["<C-j>"] = { origin = "<C-\\><C-N><C-w>j<ESC>i", desc = "switch to bottom window", opts = nil, },
        ["<C-k>"] = { origin = "<C-\\><C-N><C-w>k<ESC>i", desc=  "switch to upper window", opts = nil, },
        ["<C-h>"] = { origin = "<C-\\><C-N><C-w>h<ESC>i", desc = "switch to left window", opts = nil, },
        ["<C-l>"] = { origin = "<C-\\><C-N><C-w>l<ESC>i", desc = "switch to right window", opts = nil, },

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
        ["<C-j>"] = { origin = "<C-w>j", desc = "switch to bottom window", opts = nil, },
        ["<C-k>"] = { origin = "<C-w>k", desc = "switch to upper window", opts = nil, },
        ["<C-h>"] = { origin = "<C-w>h", desc = "switch to left window", opts = nil, },
        ["<C-l>"] = { origin = "<C-w>l", desc = "switch to right window", opts = nil, },

        -- Quickly flush buffer changes into file.
        ["<C-s>"] = { origin = "<cmd>w<CR>", desc = "save file", opts = nil, },

        -- Copy all
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
        ["<C-j>"] = { origin = 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', desc = "select the next item", opts = nil, },
        ["<C-k>"] = { origin = 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', desc = "select the previous item", opts = nil, },
    },
}

M.km_whichkey = {
    enable = false, -- Indicating enable and first load or not.
    normal_mode = {
        ["<leader>wk"] = {
            origin = function()
                local inputKey = vim.fn.input "WhichKey: "
                vim.cmd("WhichKey " .. inputKey)
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

-- functions

local merge_tbl = vim.tbl_deep_extend

M.load_keymappings = function(plugin_name)
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
            local default_opts = generic_opts[mode]
            for redefined_keybinding, km_info_tbl in pairs(values) do
                local opts = merge_tbl("force", default_opts, km_info_tbl.opts or {})
                opts.desc = km_info_tbl.desc
                vim.keymap.set(mode_adapters[mode], redefined_keybinding, km_info_tbl.origin, opts)
            end
        end
    end

    local mapping = nil
    if type(plugin_name) == "nil" or string.match(plugin_name, "^%s+$") == plugin_name then
        mapping = M.km_general
    else
        mapping = M[plugin_name]
    end

    set_plugin_km(mapping)
end

return M