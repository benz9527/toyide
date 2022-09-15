local is_present, plg_core = pcall(require, "toyide.plugins.configs.core")
if not is_present then
    return
end
require("toyide.plugins.configs.shortcut_key_search")

require("toyide.core.plugin_installer").install(plg_core.get_enable_plugins())