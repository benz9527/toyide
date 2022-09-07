local g = vim.g

g.vim_version = vim.version().minor

-- Neovim 0.8 default enabled to use filetype.lua instead filetype.vim.
if g.vim_version < 8 then
    g.did_load_filetypes = 0
    g.do_filetype_lua = 1
end


-- Setting the help options.
-- Under the cmd mode, using the :help to view info.
-- References: https://neovim.io/doc/user/options.html

local opt = vim.opt

opt.completeopt = {"menuone", "noselect"}	-- mostly just for cmp

-- Clipboard
opt.clipboard = "unnamedplus" 		-- allows nvim to access the system clipboard

-- Search
opt.hlsearch = true				-- highlight all matches on previous search pattern

-- File
opt.backup = false				-- disable to backup file
opt.conceallevel = 0 			-- let `` is visible in md file
opt.fileencoding = "utf-8"
opt.swapfile = false			-- disable swap file
opt.timeoutlen = 1000			-- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true
opt.updatetime = 300			-- faster completion (default 4k ms)
opt.writebackup = false			-- disable multiple program write a file concurrently

-- Mouse
opt.mouse = "a" 				-- allow the mouse as usable in nvim

-- Windows
opt.title = true
opt.pumheight = 10				-- pop up menu height
opt.splitbelow = true			-- force all horizontal splits to go below current window
opt.splitright = true			-- force all vertical splits to go to the right of current window
opt.shortmess:append "sI"       -- disable nvim intro

-- Status line
opt.cmdheight = 1 				-- for nvim to display messages
opt.showmode = false			-- indicating which mode nvim is in
opt.laststatus = 3

-- Indent
opt.expandtab = true			-- convert tabs into space
opt.shiftwidth = 2				-- the number of spaces inserteed for each indentation
opt.smartindent = true
opt.tabstop = 2				    -- insert 2 spaces for a tab
opt.softtabstop = 2
opt.fillchars = { eob = " " }
opt.showtabline = 2				-- always show tabs

-- Case
opt.ignorecase = true			-- case insensitive for search
opt.smartcase = true

-- Line & number
opt.number = true				-- display the line number
opt.relativenumber = false
opt.numberwidth = 2				-- default 4
opt.ruler = false
opt.cursorline = true			-- highlight the current line

-- Scroll
opt.signcolumn = "yes"			-- always show the sign column, otherwise it would shift the text each time
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Font
opt.guifont = "JetBrains Mono Extra Bold Nerd Font Complete Mono:h16"

-- Wrap
opt.wrap = false				-- one line soft wrap
-- vim.cmd "set whichwrap+=<,>,[,],h,l"
opt.whichwrap:append "<>[]hl"

vim.cmd [[set iskeyword+=-]]
-- vim.cmd [[set formatoptions-=cro]]

