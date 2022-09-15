local nvim_notify_opts = {
    -- Default is fade_in_slide_out
    stages = "fade",
    ---@usage Function called when a new window is opened, use for changing win settings/config.
    on_open = nil,
    ---@usage Function called when a window is closed.
    on_close = nil,
    ---@usage Timeout for notifications in ms.
    timeout = 5000,
    ---@usage Can be set as `#000000` format.
    background_colour = "Normal",
    render = "default",
    max_width = 150,
    minimum_width = 50,
    icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
}

local nvim_notify = {
    ["rcarriga/nvim-notify"] = {
        disable = false,
        opt = true,
        config = function()
            local is_present, notify = pcall(require, "notify")
            if not is_present then
                vim.notify("nvim-notify plugin not exists!")
                return
            end

            notify.setup(nvim_notify_opts)

            vim.notify = notify
        end,
        event = { "VimEnter" },
    },
}

local is_present, plg_core = pcall(require, "toyide.plugins.configs.core")
if not is_present then
    return
end

plg_core.register(nvim_notify)