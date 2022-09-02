local t_status_ok, tree = pcall(require, "nvim-treesitter.configs")
if not t_status_ok then
    return
end

tree.setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = {""},
    highlint = {
        enable = true,
        disable = {""},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = {
            "yaml",
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime= 25,
        persist_queries = false,
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_language = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<CR>",
            show_help = "?",
        },
    },
}