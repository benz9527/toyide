local M = {}

local merge_tbl = vim.tbl_deep_extend
local core_plugins = {}

function M.get_enable_plugins()
    local final_tbl = {}
    -- avoid the reference modified by pointer.
    local _plugins = vim.tbl_deep_extend("force", {}, core_plugins)
    for k, v in pairs(_plugins) do
        v[1] = k
        final_tbl[#final_tbl + 1] = v
    end
    return final_tbl
end

function M.register(plugin)

    core_plugins = merge_tbl("force", core_plugins, plugin or {})

end

return M