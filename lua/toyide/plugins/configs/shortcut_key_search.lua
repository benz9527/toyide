-- whichkey
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

-- whichkey register
wk.setup(options)
