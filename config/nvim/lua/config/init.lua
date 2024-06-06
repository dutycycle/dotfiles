local function augroup(name)
  return vim.api.nvim_create_augroup("dutycycle_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt.whichwrap = vim.o.whichwrap .. "<,>,h,l"
    vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', 'k', 'gk', { noremap = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("bufWritePost", {
    group = augroup("python"),
    pattern = "*.py",
    command = "silent !black %"
})
