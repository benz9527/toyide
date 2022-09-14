local core_plugins = {
    -- Load the shortcut key search plugin after all the GUI.
    ["folke/which-key.nvim"] = {
        disable = false,
        module = "which-key",
        -- whichkey is already lazy loaded. Until we press the <leader> key it will never be loaded.
        -- https://github.com/folke/which-key.nvim/issues/102
        keys = "<leader>",
        config = function()
            require("toyide.plugins.configs.shortcut_key_search")
        end,
        setup = function()
            local km = require("toyide.core.keymappings")
            km.plugin_enable_and_load_km("whichkey")
        end,
    },
}

local function plugins()
    local final_tbl = {}
    -- avoid the reference modified by pointer.
    local _plugins = vim.tbl_deep_extend("force", {}, core_plugins)
    for k, v in pairs(_plugins) do
        v[1] = k
        final_tbl[#final_tbl + 1] = v
    end
    return final_tbl
end

require("toyide.core.plugin_installer").install(plugins())