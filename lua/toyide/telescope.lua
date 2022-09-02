local t_status_ok, telescope = pcall(require, "telescope")
if not t_status_ok then
    return
end

local actions = require("telescope.actions")

-- https://github.com/nvim-telescope/telescope.nvim/issues/623
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local _preview_blacklist = {'.*%.csv', '.*%.zip', '.*%.tar.gz'}

local is_blocked_file = function(filepath)
    for _, v in ipairs(_preview_blacklist) do
        if filepath:match(v) then
            return true
        end
    end
    return false
end

local my_preview_maker = function(filepath, bufnr, opts)
    opts = opts or {}

    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then
            return
        end

        if stat.size > 100000 then
            return
        else
            if opts.use_ft_detect == nil then
                opts.use_ft_detect = true
            end
            opts.use_ft_detect = not (opts.use_ft_detect == false or is_blocked_file(filepath))
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
    end)
end

-- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
-- https://www.joyk.com/dig/detail/1621081898696632
telescope.setup {
    defaults = {
        initial_mode = "insert",
        selection_strategy = "reset",
        prompt_prefix = " ",
        selection_caret = " ",
--        path_display = { "smart" },
        scroll_strategy = "limit",

        -- Layout display
        -- :lua require('telescope.builtin').find_files({layout_strategy='vertical',layout_config={width=0.5}})
        -- layout_config = {
        --    vertical = { width = 0.5 },
        -- },

        sorting_strategy = "descending",
        file_sorter = sorters.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        preview_cutoff = 120,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        buffer_previewer_maker = my_preview_maker,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },

        mapping = {
            n = {
                ["<ESC>"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<A-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["gm"] = actions.move_to_middle,
                ["G"] = actions.move_to_bottom,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,

                ["<C-h>"] = actions.which_key,
            },
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,

                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,

                ["<C-c>"] = actions.close,

                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,

                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<A-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-h>"] = actions.which_key,
            },
        },
    },
    pickers = {
        find_files = {
            -- <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<CR>
            theme = "ivy",
        },
    },
    extensions = {
        -- find_files = {
        --     find_command = "rg,--ignore,--hidden",
        -- },
        -- Add other telescope plugins.
        --media_files = {
        --    -- file type whitelist to show
        --    filetypes = { "png", "webp", "jpg", "jpeg" },
        --    find_cmd = "rg"
        --},
    },
}

-- Loaded extensions should be after the telescope setup with extensions.
-- X11 lib support and python ueberzug installation
-- (useless) sudo apt install xorg
-- sudo apt install libx11-dev libxrandr-dev libxi-dev
-- sudo pip install ueberzug
-- https://github.com/seebye/ueberzug
-- sudo apt install fd-find
-- sudo ln -s /usr/bin/fdfind /usr/bin/fd
-- lua require('telescope').extensions.media_files.media_files()
-- telescope.load_extension("media_files")