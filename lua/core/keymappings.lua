local M = {}
local generic_opts_any = { noremap = true, silent = true }

-- The doc about vim.keymap and vim.api.nvim_set_keymap
-- https://neovim.io/doc/user/map.html
-- vim.keymap is lua module. We can add callback function expression for keymap.
-- https://neovim.io/doc/user/lua.html
-- vim.api.nvim_set_keymap
-- https://neovim.io/doc/user/api.html#nvim_set_keymap()

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

M.km_general = {
    insert_mode = {
        ["<C-q>"] = { "<ESC>", "exit the insert mode", },
        -- Quickly positioning in a line.
        ["<C-a>"] = { "<ESC>^i", "ahead of line" },
        ["<C-e>"] = { "<End>", "end of line" },
        -- Other navigations.
        -- <Left>, <Right>, <Down>, <Up>
        ["<C-j>"] = { "<C-\\><C-N><C-w>j<ESC>i", "switch to bottom window" },
        ["<C-k>"] = { "<C-\\><C-N><C-w>k<ESC>i", "switch to upper window" },
        ["<C-h>"] = { "<C-\\><C-N><C-w>h<ESC>i", "switch to left window" },
        ["<C-l>"] = { "<C-\\><C-N><C-w>l<ESC>i", "switch to right window" },

        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { "<cmd>move .-2<CR>==", "move current line/block up" },
        ["<A-Down>"] = { "<cmd>move .+1<CR>==", "move current line/block down" },
    },
    normal_mode = {
        -- Switch between windows.
        ["<C-j>"] = { "<C-w>j", "switch to bottom window" },
        ["<C-k>"] = { "<C-w>k", "switch to upper window" },
        ["<C-h>"] = { "<C-w>h", "switch to left window" },
        ["<C-l>"] = { "<C-w>l", "switch to right window" },

        -- Quickly flush buffer changes into file.
        ["<C-s>"] = { "<cmd>w<CR>", "save file" },

        -- Copy all
        ["<C-a>c"] = { "<cmd>%y+<CR>", "copy whole file content" },

        -- Resize the current window.
        ["<C-Up>"] = { "<cmd>resize +2<CR>", "increase the bottom height of current window" },
        ["<C-Down>"] = { "<cmd>resize -2<CR>", "decrease the bottom height of current window" },
        ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "decrease the width of current window" },
        ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "increase the width of current window" },

        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { "<cmd>move .-2<CR>==", "move current line/block up" },
        ["<A-Down>"] = { "<cmd>move .+1<CR>==", "move current line/block down" },
    },
    terminal_mode = {
        ["<C-j>"] = { "<C-\\><C-N><C-w>j", "switch to bottom terminal window" },
        ["<C-k>"] = { "<C-\\><C-N><C-w>k", "switch to upper terminal window" },
        ["<C-h>"] = { "<C-\\><C-N><C-w>h", "switch to left terminal window" },
        ["<C-l>"] = { "<C-\\><C-N><C-w>l", "switch to right terminal window" },
    },
    visual_mode = {
        -- Selected line/block do better indent.
        [">"] = { ">gv", "right indenting" },
        ["<"] = { "<gv", "left indenting" },
    },
    visual_block_mode = {
        -- Move current line/block.
        -- TODO(Ben) how to keep indent?
        ["<A-Up>"] = { "<cmd>move '<-2<CR>gv-gv", "move current line/block up" },
        ["<A-Down>"] = { "<cmd>move '>+1<CR>gv-gv", "move current line/block down" },
    },
    command_mode = {
        -- Tab completion items navigation. Replace the <Tab> as down and <S-Tab> as up.
        ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', "select the next item" },
        ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', "select the previous item" },
    },
}

-- functions

local merge_tbl = vim.tbl_deep_extend

M.load_keymappings = function(section, keymapping_opt)
    local function set_section_map(section_values)
        if section_values.plugin then
            return
        end

        section_values.plugin = nil

        for mode, mode_values in pairs(section_values) do
            local default_opts = merge_tbl("force", { mode = mode }, keymapping_opt or {})
            for key_binding, keymapping_info in pairs(mode_values) do
                local opts = merge_tbl("force", default_opts, keymapping_info.opts or {})

                keymapping_info.opts, opts.mode = nil, nil
                opts.desc = keymapping_info[2]
                vim.keymap.set(mode, key_binding, keymapping_info[1], opts)
            end
        end
    end
end

return M