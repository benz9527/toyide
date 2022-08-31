local t_status_ok, telescope = pcall(require, "telescope")
if not t_status_ok then
    return
end

-- X11 lib support and python ueberzug installation
-- (useless) sudo apt install xorg
-- sudo apt install libx11-dev libxrandr-dev libxi-dev
-- pip install ueberzug
-- https://github.com/seebye/ueberzug
telescope.load_extension("media_files")

local actions = require("telescope.actions")

-- https://github.com/nvim-telescope/telescope.nvim/issues/623
local previewer = require("telescope.previewers")

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
            previewer.buffer_previewer_maker(filepath, bufnr, opts)
        end
    end)
end

-- https://github.com/nvim-telescope/telescope.nvim
telescope.setup {
    defaults = {
        buffer_previewer_maker = my_preview_maker,
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

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
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["T"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["B"] = actions.move_to_bottom,

                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
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
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-h>"] = actions.which_key,
            },
        },
    },
    pickers = {

    },
    extensions = {
        -- Add other telescope plugins.
        media_files = {
            -- file type whitelist to show
            filetypes = { "png", "webp", "jpa", "jpeg" },
            find_cmd = "rg",
        },
    },
}