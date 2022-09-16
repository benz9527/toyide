local M = {}

-- Create autocommand groups event if it doesn't exist.
-- `:h nvim_create_autocmd` or `:h nvim_create_augroup`
function M.def_autocmds(cmds)
    for _, entry in ipairs(cmds) do
        local event = entry[1]
        local opts = entry[2]
        if type(opts.group) == "string" and opts.group ~= "" then
            local is_exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
            if not is_exists then
                vim.api.nvim_create_augroup(opts.group, {})
            end
        end
        vim.api.nvim_create_autocmd(event, opts)
    end
end

local core_cmds = {
    {
        "BufWritePost",
        {
            group = "_general_settings",
            pattern = "",
            desc = "trigger reload on saving " .. vim.fn.expand "%:~",
            callback = function()

            end
        }
    },
}