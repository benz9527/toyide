local whichkey = {
    -- Load the shortcut key search plugin after all the GUI.
    ["folke/which-key.nvim"] = {
        disable = false,
        module = "which-key",
        -- whichkey is already lazy loaded. Until we press the <leader> key it will never be loaded.
        -- https://github.com/folke/which-key.nvim/issues/102
        keys = "<leader>",
        config = function()
            local is_present, wk = pcall(require, "which-key")
            if not is_present then
                return
            end

            local options = {
                icons = {
                    breadcrumb = "»",
                    separator = "  ",
                    -- Symbol prepended to a group.
                    group = "祐",
                },

                popup_mappings = {
                    scroll_up = "<Up>",
                    scroll_down = "<Down>",
                },

                window = {
                    -- border style
                    -- none/single/double/shadow
                    border = "shadow",
                },

                layout = {
                    -- spacing between columns
                    spacing = 6,
                },

                hidden = {
                    -- hidden trigger event
                    "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ ",
                },

                triggers_blacklist = {
                    i = { "j", "k", },
                    v = { "j", "k", },
                },

                triggers = {
                    "<leader>",
                },
            }

            wk.setup(options)
        end,
        setup = function()
            local km = require("toyide.core.keymappings")
            km.plugin_enable_and_load_km("whichkey")
        end,
    },
}

local is_present, plg_core = pcall(require, "toyide.plugins.configs.core")
if not is_present then
    return
end

plg_core.register(whichkey)
