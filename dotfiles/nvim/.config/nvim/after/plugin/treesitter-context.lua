require'treesitter-context'.setup{
    enable = true,
    max_lines = 0,
    min_window_height = 2,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = '_',
    zindex = 41, -- needs to be 41 or higher to beat zen-mode's z-index
    on_attach = nil,
}
