local path_separator = vim.loop.os_uname().version:match "Windows" and "\\" or "/"

-- Global functions
function _G.join_paths(...)
    local result = table.concat({ ... }, path_separator)
    return result
end

function _G.get_runtime_dir()
    ---@docs nvim :echo stdpath("data")
    -- default vim.fn.stdpath("data") is `/path/to/usr/home/.local/share/nvim`
    return vim.call("stdpath", "data")
end

function _G.get_config_dir()
    -- default vim.fn.stdpath("config") is `/path/to/usr/home/.config/nvim`
    return vim.call("stdpath", "config")
end

function _G.get_cache_dir()
    -- default vim.fn.stdpath("cache") is `/path/to/usr/home/.cache/nvim`
    return vim.call("stdpath", "cache")
end

-- vim.fn.input with <ESC> <CR> <C-c>
-- https://github.com/neovim/neovim/issues/18144
-- https://github.com/neovim/neovim/issues/18143
-- https://github.com/neovim/neovim/blob/6e6f5a783333d1bf9d6c719c896e72ac82e1ae54/runtime/lua/vim/ui.lua#L85-L97
local input_ns_id = vim.api.nvim_create_namespace('')

function _G.safe_input(opts, on_confirm)
    vim.validate {
        otps = { opts, 'table', true, },
        on_confirm = { on_confirm, 'function', false, },
    }

    -- By temporary listener to distinguish between <ESC> and empty string.
    local cancelled = false
    vim.on_key(function(key)
        if key == vim.api.nvim_replace_termcodes('<ESC>', true, true, true) then
            cancelled = true
        end
    end, input_ns_id)

    if opts == nil or vim.tbl_isempty(opts) then
        opts = vim.empty_dict()
    end
    -- Use pcall to allow cancelling with <C-c>.
    local ok, input = pcall(vim.fn.input, opts)
    -- Stop listener.
    vim.on_key(nil, input_ns_id)
    if not ok or cancelled then
        on_confirm(nil)
    else
        on_confirm(input)
    end
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