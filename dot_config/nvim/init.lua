vim.g.mapleader = " "
vim.o.autoread = true
vim.opt.updatetime = 200
vim.opt.iskeyword:remove("_")

local autoread_group = vim.api.nvim_create_augroup("kai_autoread", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained", "TermClose", "TermLeave" }, {
  group = autoread_group,
  pattern = "*",
  callback = function()
    if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "c" then
      vim.cmd.checktime()
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = autoread_group,
  pattern = "*",
  callback = function(event)
    local file = event.file or event.match or ""
    if file == "" then
      return
    end
    vim.notify("File reloaded from disk: " .. file, vim.log.levels.WARN)
  end,
})


-- ~/.config/nvim/init.lua
-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Rose Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  -- Tmux navigation plugin
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- optional
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  -- Telescope core + dependencies
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- fzf-native for fast sorting
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      local function send_results_to_qf(prompt_bufnr)
        actions.smart_send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
      end

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-q>"] = send_results_to_qf,
            },
            n = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<C-q>"] = send_results_to_qf,
            },
          },
        },
      })

      -- Load fzf extension if built
      pcall(telescope.load_extension, "fzf")

      -- Keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fd", function()
        builtin.diagnostics({ bufnr = 0 })
      end, { desc = "[F]ind buffer [D]iagnostics" })
    end,
  },
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
        },
      })

      vim.keymap.set("n", "<leader>ft", "<cmd>Neotree toggle<CR>", {
        desc = "Toggle file tree",
      })
    end,
  },
  -- Daily scratchpad plugin
  {
    "VVoruganti/today.nvim",
    config = function()
      local ok, today = pcall(require, "today")
      if not ok then
        return
      end

      if type(today.setup) == "function" then
        today.setup()
      end

      vim.keymap.set("n", "<leader>t", function()
        if vim.fn.exists(":Today") == 1 then
          pcall(vim.cmd.Today)
          return
        end

        local ok_module, today_mod = pcall(require, "today")
        if not ok_module then
          return
        end

        if type(today_mod.open) == "function" then
          today_mod.open()
        elseif type(today_mod.toggle) == "function" then
          today_mod.toggle()
        elseif type(today_mod.open_today) == "function" then
          today_mod.open_today()
        end
      end, { desc = "Open Today scratchpad" })
    end,
  },
  -- Task runner for custom commands like Ruff linting
  {
    "stevearc/overseer.nvim",
    config = function()
      local overseer = require("overseer")
      overseer.setup({})

      local function run_ruff()
        local bufnr = vim.api.nvim_get_current_buf()
        local file = vim.api.nvim_buf_get_name(bufnr)
        if file == "" then
          return
        end

        if vim.api.nvim_buf_get_option(bufnr, "modified") then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent! write")
          end)
        end

        local task = overseer.new_task({
          name = "ruff lint " .. file,
          cmd = { "bash", "-lc", string.format("ruff format %q && ruff check --fix --unsafe-fixes %q", file, file) },
          components = { "default" },
        })

        task:subscribe("on_complete", function()
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
              return
            end
            if vim.api.nvim_buf_get_name(bufnr) ~= file then
              return
            end
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd("silent! edit!")
            end)
          end)
        end)

        task:start()
      end

      vim.keymap.set("n", "<leader>ot", overseer.toggle, { desc = "Toggle Overseer tasks" })
      vim.keymap.set("n", "<leader>ol", run_ruff, { desc = "Ruff format + check --fix" })
      vim.keymap.set("n", "<leader>l", run_ruff, { desc = "Ruff format + check --fix" })
    end,
  },
  -- LSP and tooling management
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local formatter = require("formatter")
      local util = require("formatter.util")

      formatter.setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          python = {
            function()
              return {
                exe = "ruff",
                args = {
                  "format",
                  "--stdin-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "-",
                },
                stdin = true,
              }
            end,
            function()
              return {
                exe = "ruff",
                args = {
                  "check",
                  "--fix",
                  "--unsafe-fixes",
                  "--stdin-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "-",
                },
                stdin = true,
              }
            end,
          },
          c = {
            function()
              return {
                exe = "clang-format",
                args = {
                  "--assume-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end,
          },
          cpp = {
            function()
              return {
                exe = "clang-format",
                args = {
                  "--assume-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end,
          },
          lua = {
            function()
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },
          go = {
            function()
              return {
                exe = "gofmt",
                args = {},
                stdin = true,
              }
            end,
          },
        },
      })

      -- Autoformat on save
      local format_augroup = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = format_augroup,
        pattern = { "*.py", "*.c", "*.cpp", "*.h", "*.hpp", "*.lua", "*.go" },
        command = "FormatWrite",
      })

      -- Manual format keymap
      vim.keymap.set("n", "<leader>l", "<cmd>Format<cr>", { desc = "Format buffer" })
    end,
  },
  -- Markdown rendering plugin
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        -- Disable rendering in insert mode, enable in normal mode
        render_modes = { "n", "c", "i" },
        -- Optional: customize appearance
        heading = {
          -- Add icons to headings
          enabled = true,
          sign = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
          -- Style for code blocks
          enabled = true,
          sign = true,
          style = "full",
          border = "thin",
        },
        bullet = {
          -- Custom bullet points
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
      })
    end,
  },
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline" },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local util = require("lspconfig.util")

      vim.diagnostic.config({
        virtual_text = { current_line = true },
      })

      local lsp_augroup = vim.api.nvim_create_augroup("kai_lsp_keymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_augroup,
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "gr", vim.lsp.buf.references, "Goto References")
        end,
      })

      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        cmd = { "uv", "run", "/Users/kai/.local/bin/basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.cfg", "setup.py", "pyrightconfig.json", ".python-version", ".git" },
      })

      vim.lsp.config("ruff", {
        capabilities = capabilities,
        cmd = { "/Users/kai/.local/bin/ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.cfg", "setup.py", ".git" },
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      mason_lspconfig.setup({
        ensure_installed = { "basedpyright", "ruff" },
      })

      vim.lsp.enable({ "basedpyright", "ruff" })
    end,
  },
})
