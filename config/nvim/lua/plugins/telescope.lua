return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()  -- This is called after the plugin is loaded
    end,
    keys = {
        { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" },
        { "<leader>fs", "<cmd>lua require('auto-session.session-lens').search_session()<cr>" },
    }
}
