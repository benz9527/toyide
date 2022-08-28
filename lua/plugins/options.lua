-- Setting the help options.
-- Under the cmd mode, using the :help to view info.
-- References: https://neovim.io/doc/user/options.html
vim.opt.backup = false				-- disable to backup file
vim.opt.clipboard = "unnamedplus" 		-- allows nvim to access the system clipboard
vim.opt.cmdheight = 2 				-- for nvim to display messages
vim.opt.completeopt = {"menuone", "noselect"}	-- mostly just for cmp
vim.opt.conceallevel = 0 			-- let `` is visible in md file
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true				-- highlight all matches on previous search pattern
vim.opt.ignorecase = true			-- case insensitive for search
vim.opt.mouse = "a" 				-- allow the mouse as usable in nvim
vim.opt.pumheight = 10				-- pop up menu height
vim.opt.showmode = false			-- indicating which mode nvim is in
vim.opt.showtabline = 2				-- always show tabs
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true			-- force all horizontal splits to go below current window
vim.opt.splitright = true			-- force all vertical splits to go to the right of current window
vim.opt.swapfile = false			-- disable swap file
vim.opt.timeoutlen = 1000			-- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true
vim.opt.updatetime = 300			-- faster completion (default 4k ms)
vim.opt.writebackup = false			-- disable multiple program write a file concurrently
vim.opt.expandtab = true			-- convert tabs into space
vim.opt.shiftwidth = 2				-- the number of spaces inserteed for each indentation
vim.opt.tabstop = 2				-- insert 2 spaces for a tab
vim.opt.cursorline = true			-- hightlight the current line
vim.opt.number = true				-- display the line number
vim.opt.relativenumber = false
vim.opt.numberwidth = 4				-- default 4
vim.opt.signcolumn = "yes"			-- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false				-- one line softwrap
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h16"

vim.opt.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
-- vim.cmd [[set formatoptions-=cro]]

