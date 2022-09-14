local path_separator = vim.loop.os_uname().version:match "Windows" and "\\" or "/"

-- Global functions
function _G.join_paths(...)
    local result = table.concat({ ... }, path_separator)
    return result
end

-- nvim :echo stdpath("data")

function _G.get_runtime_dir()
    -- nvim is used directly.
    return vim.call("stdpath", "data")
end

function _G.get_config_dir()
    return vim.call("stdpath", "config")
end

function _G.get_cache_dir()
    return vim.call("stdpath", "cache")
end

local M = {}

function M.is_dir(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "directory" or false
end

function M.is_file(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "file" or false
end

return M