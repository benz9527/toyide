-- get toyide running lua script relative path
local app_init_script_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = app_init_script_path:match("(.*[/\\])"):sub(1, -2)

require("toyide.core.options")
require("toyide.core.disable_builtin_plugins")
require("toyide.core.keymappings").load_keymappings()
require("toyide.core.plugin_installer").init(base_dir)
require("toyide.plugins")

-- require("toyide.plugins")
-- require("toyide.colorscheme")
-- require("toyide.completion")
-- require("toyide.lsp")
-- require("toyide.telescope")