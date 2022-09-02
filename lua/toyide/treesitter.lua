local t_status_ok, tree = pcall(require, "nvim-treesitter.configs")
if not t_status_ok then
    return
end

tree.setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = {""},
    highline = {
        enable = true,
        disable = {""},
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = {
            "yaml",
        },
    },
}