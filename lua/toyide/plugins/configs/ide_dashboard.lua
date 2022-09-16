---@docs https://github.com/goolord/alpha-nvim/blob/main/doc/alpha.txt
local function alpha_init()
    local is_present, alpha = pcall(require, "alpha")
    if not is_present then
        vim.notify("alpha dashboard not exists!")
        return
    end
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
        [[████████╗ ██████╗ ██╗   ██╗██╗██████╗ ███████╗]],
        [[╚══██╔══╝██╔═══██╗╚██╗ ██╔╝██║██╔══██╗██╔════╝]],
        [[   ██║   ██║   ██║ ╚████╔╝ ██║██║  ██║█████╗  ]],
        [[   ██║   ██║   ██║  ╚██╔╝  ██║██║  ██║██╔══╝  ]],
        [[   ██║   ╚██████╔╝   ██║   ██║██████╔╝███████╗]],
        [[   ╚═╝    ╚═════╝    ╚═╝   ╚═╝╚═════╝ ╚══════╝]],
    }
    dashboard.section.header.opts = {
        position = "center",
        hl = "AlphaHeader",
    }

    dashboard.section.buttons.val = {
        dashboard.button("SPC f f", " Find File", ""),
        dashboard.button("SPC f h", " Recently Files", ""),
    }
    dashboard.section.buttons.opts = {
        spacing = 1,
    }

    local margin_top_percent = 0.3
    local header_padding_top = {
        type = "padding",
        val = vim.fn.max({2, vim.fn.floor(vim.fn.winheight(0) * margin_top_percent)}),
    }
    local header_padding_bottom = {
        type = "padding",
        val = 2,
    }

    alpha.setup({
        layout = {
            header_padding_top,
            dashboard.section.header,
            header_padding_bottom,
            dashboard.section.buttons,
        },
        opts = {},
    })

    -- Disable status line in dashboard page.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
            -- Temporarily save current status line.
            local old_last_status = vim.opt.laststatus
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                callback = function()
                    vim.opt.laststatus = old_last_status
                end,
            })
            vim.opt.laststatus = 0
        end,
    })
end

local alpha = {
    ["goolord/alpha-nvim"] = {
        disable = false,
        opt = true,
        config = alpha_init,
    },
}

local is_present, plg_core = pcall(require, "toyide.plugins.configs.core")
if not is_present then
    return
end

plg_core.register(alpha)