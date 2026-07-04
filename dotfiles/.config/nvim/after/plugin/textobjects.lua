require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

-- Select: visual + operator-pending
local select_maps = {
  ["af"] = "@function.outer",
  ["if"] = "@function.inner",
  ["ac"] = "@class.outer",
  ["ic"] = "@class.inner",
  ["aa"] = "@parameter.outer",
  ["ia"] = "@parameter.inner",
}

for key, query in pairs(select_maps) do
  vim.keymap.set({ "x", "o" }, key, function()
    select.select_textobject(query)
  end)
end

-- Move: normal + visual + operator-pending
local next_start = {
  ["]f"] = "@function.outer",
  ["]c"] = "@class.outer",
  ["]a"] = "@parameter.outer",
}

local prev_start = {
  ["[f"] = "@function.outer",
  ["[c"] = "@class.outer",
  ["[a"] = "@parameter.outer",
}

for key, query in pairs(next_start) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_next_start(query)
  end)
end

for key, query in pairs(prev_start) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    move.goto_previous_start(query)
  end)
end
