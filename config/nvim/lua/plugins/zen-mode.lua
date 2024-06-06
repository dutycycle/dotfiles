-- Lua
local writingOpts = {
    window = {
        height = .7,
        width = 80,
        options = {
            number = false,
        }
    }
}

local codingOpts = {
    window = {
        height = 1,
        width = 120
    }
}

return {
  "folke/zen-mode.nvim",
  opts = {
      window = {
          backdrop = 1,
          height = .7,
          width = 100
      }
  },
  keys = {
      { "<leader>zz", function() require("zen-mode").toggle(codingOpts) end, desc="zenmode coding" },
      { "<leader>zx", function() require("zen-mode").toggle(writingOpts) end, desc="zenmode writing" },
  }
}

