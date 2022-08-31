local colorscheme = "default"

local cs_status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not cs_status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end