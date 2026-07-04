local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Use enhanced omnisharp definition for C# files, regular LSP for others
  vim.keymap.set("n", "gd", function()
    if vim.bo.filetype == "cs" then
      require("omnisharp_extended").telescope_lsp_definitions()
    else
      vim.lsp.buf.definition()
    end
  end, opts)
  vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implentation() end, opts)
  -- vim.keymap.set('n', '<leader>ai', function() vim.map.buf.incoming_calls() end, opts)
  -- vim.keymap.set('n', '<leader>ao', function() vim.lsp.buf.outgoing_calls() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]]", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "[[", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

  local function filterDuplicates(array)
    local uniqueArray = {}
    for _, tableA in ipairs(array) do
      local isDuplicate = false
      for _, tableB in ipairs(uniqueArray) do
        if vim.deep_equal(tableA, tableB) then
          isDuplicate = true
          break
        end
      end
      if not isDuplicate then
        table.insert(uniqueArray, tableA)
      end
    end
    return uniqueArray
  end

  local function on_list(options)
    options.items = filterDuplicates(options.items)
    vim.fn.setqflist({}, ' ', options)
    vim.cmd('botright copen')
  end

  -- dedupe Usage
  vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references(nil, { on_list = on_list }) end, opts)
  -- vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'rust_analyzer', 'eslint', 'gopls', 'lua_ls', 'ansiblels', 'omnisharp' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})


local function set_keymap(keymap, command)
  vim.keymap.set({ "n", "v" }, keymap, function()
    vim.cmd(":" .. command)
  end, { desc = command })
end
set_keymap("<leader>alc", "AdoPure load context")
set_keymap("<leader>alt", "AdoPure load threads")
set_keymap("<leader>aoq", "AdoPure open quickfix")
set_keymap("<leader>aot", "AdoPure open thread_picker")
set_keymap("<leader>aon", "AdoPure open new_thread")
set_keymap("<leader>aoe", "AdoPure open existing_thread")
set_keymap("<leader>asc", "AdoPure submit comment")
set_keymap("<leader>asv", "AdoPure submit vote")
set_keymap("<leader>ast", "AdoPure submit thread_status")
set_keymap("<leader>asd", "AdoPure submit delete_comment")
set_keymap("<leader>ase", "AdoPure submit edit_comment")


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = {
    { name = 'lazydev', group_index = 0 },
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
