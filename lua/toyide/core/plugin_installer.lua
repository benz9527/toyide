-- Plugin installer is wbthomason/packer.nvim

local M = {}

local fn = vim.fn
local libs = require("toyide.core.libs")

local compile_path = join_paths(get_config_dir(), "plugin", "packer_compiled.lua")
local snapshot_path = join_paths(get_cache_dir(), "snapshots")
local install_path = join_paths(get_runtime_dir(), "site", "pack", "packer", "start", "packer.nvim")

local function on_packer_complete_hook()
    vim.api.nvim_exec_autocmds("User", { pattern = "PackerComplete" })
    -- colorscheme
    -- pcall(vim.cmd, "colorscheme " .. xxx)
end

-- Packer init options
-- https://github.com/wbthomason/packer.nvim
local options = {
    -- package_root = join_paths(get_runtime_dir(), "site", "pack"),
    -- compile_path = compile_path,
    -- snapshot_path = snapshot_path,
    max_jobs = 20,
    log = {
        level = "warn",
    },
    display = {
        -- nerd font icon
        working_sym = " ",
        error_sym = " ",
        done_sym = " ",
        removed_sym = " ",
        moved_sym = " ",
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
    git = {
        cmd = "git",
        -- git clone depth.
        depth = 1,
        clone_timeout = 300,
        -- github mirror or proxy.
        -- Lua format string used for "aaa/bbb" style plugins
        default_url_format = "https://github.com/%s.git",
        -- default_url_format = "https://github.91chi.fun/https://github.com/%s.git"
        -- default_url_format = "https://hub.fastgit.xyz/%s.git"
    }
}

local function pcall_packer_cmd(cmd, kwargs)
    local is_present, msg = pcall(function()
        -- lua <= 5.1, use unpack
        -- lua > 5.1, use table.unpack
        require("packer")[cmd](table.unpack(kwargs or {}))
    end)
    if not is_present then
        -- TODO log with error
    end
end

function M.init(dir)
    if not libs.is_dir(install_path) then
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
        print("Cloning nvim plugins manager packer...")
        fn.system {
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim.git",
            install_path,
        }
        vim.cmd [[packadd packer.nvim]]
        -- IMPORTANT: we only set this the very first time to avoid constantly triggering the rollback function
        -- https://github.com/wbthomason/packer.nvim/blob/c576ab3f1488ee86d60fd340d01ade08dcabd256/lua/packer.lua#L998-L995
        -- TODO How the gen the plugin snapshots automatically?
        -- options.snapshot = join_paths(dir, "snapshots", "default.json")
    end

    local is_present, packer = pcall(require, "packer")
    if is_present then
        packer.on_complete = vim.schedule_wrap(function()
            on_packer_complete_hook()
        end)
        packer.init(options)
    end
end

function M.install(plugins)
    local is_present, packer = pcall(require, "packer")
    if not is_present then
        return
    end

    local ok, _ = xpcall(function()
        packer.reset()
        packer.startup(function(use)
            for _, plg in pairs(plugins) do
                use(plg)
            end
        end)
    end, debug.traceback)
    if not ok then
        print("failed to install plugins")
    end
end

return M