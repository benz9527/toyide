local fn = vim.fn

-- install packer automatically
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim.git",
    install_path,
  }
  print "Installing packer close and reopen nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- reloads nvim whenever we save or update the thirdparties.lua automatically
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- uses a protected call so that the error will not out on first run
local ok, packer = pcall(require, "packer")
if not ok then
  return
end

-- make packer with a popup win to show installations
-- https://github.com/wbthomason/packer.nvim
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    cmd = "git",
    depth = 1, -- git clone depth
    clone_timeout = 60,
    default_url_format = "https://github.com/%s.git",
    -- China mainland dev has to use github mirror site to download. Please choose one of below formats.
    -- default_url_format = "https://github.91chi.fun/https://github.com/%s.git" -- Lua format string used for "aaa/bbb" style plugins
    -- default_url_format = "https://hub.fastgit.xyz/%s.git"
  },
}

-- install self-defined third party plugins
return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in nvim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

  -- color scheme
  use "lunarvim/darkplus.nvim"

  -- completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "saadparwaiz1/cmp_luasnip" -- snippet completion

  -- snippets
  use "L3MON4D3/LuaSnip" -- snippet engine
  use "rafamadriz/friendly-sinppets"

  -- Set up our configuration after cloning packer.nvim automatically.
  -- Put this at the end after all plugins.
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
