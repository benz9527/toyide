-- <CR> is Enter
-- <A> is Alt
-- <C> is Ctrl
-- <S> is Shift
-- <ESC> is Escape
-- <leader> is an important key for self-defined key-mapping
-- Reference: https://neovim.io/doc/user/map.html

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local km = vim.api.nvim_set_keymap

-- Remap Space as leader key
km("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
-- Normal mode as n.
-- Better window navigation
km("n", "<C-h>", "<C-w>h", opts)
km("n", "<C-j>", "<C-w>j", opts)
km("n", "<C-k>", "<C-w>k", opts)
km("n", "<C-l>", "<C-w>l", opts)
km("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
-- Horizontal (move bottom bar)
km("n", "<C-Up>", ":resize +1<CR>", opts)
km("n", "<C-Down>", ":resize -1<CR>", opts)
-- Vertical (move right bar)
km("n", "<C-Left>", ":vertical resize -1<CR>", opts)
km("n", "<C-Right>", ":vertical resize +1<CR>", opts)

-- Navigate buffers
-- H eq <S-h>, L eq <S-l>
km("n", "H", ":bprevious<CR>", opts)
km("n", "L", ":bnext<CR>", opts)

-- Insert mode as i
-- Quickly exit the insert mode, useless for me, I like the <ESC>.
-- km("i", "jk", "<ESC>", opts)

-- Visual mode as v
-- Stay in indent mode
km("v", "<", "<gv", opts)
km("v", ">", ">gv", opts)

-- Move text up and down
km("v", "<A-j>", ":m .+1<CR>==", opts)
km("v", "<A-k>", ":m .-2<CR>==", opts)
-- Paste operation ref register
km("v", "p", '"_dP', opts)

-- Visual block mode as x
-- Visual block trigger by <S-v> in normal mode
km("x", "J", ":m '>+1<CR>gv-gv", opts)
km("x", "K", ":m '<-2<CR>gv-gv", opts)
km("x", "<A-j>", ":m '>+1<CR>gv-gv", opts)
km("x", "<A-k>", ":m '<-2<CR>gv-gv", opts)
km("x", "<A-k>", ":m '<-2<CR>gv-gv", opts)

-- Terminal mode as t
-- Using :te / :term ++curwin entern term mode
-- <C-\\><C+n> exit term and back to the normal mode.
-- We have to closed the term before back to the normal mode.
-- km("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- km("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- km("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts
-- km("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
