local M = {}

M.config = function()
  lvim.builtin.indentlines = {
    active = true,
    on_config_done = nil,
    options = {
      enabled = true,
      buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "text",
      },
      char = lvim.icons.ui.LineLeft,
      context_char = lvim.icons.ui.LineLeft,
      show_trailing_blankline_indent = false,
      show_first_indent_level = true,
      use_treesitter = true,
      show_current_context = true,
    },
  }
end

M.setup = function()
  local status_ok, ibl = pcall(require, "ibl")
  if status_ok then
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#3b4261" })
    ibl.setup {
      exclude = {
        buftypes = lvim.builtin.indentlines.options.buftype_exclude,
        filetypes = lvim.builtin.indentlines.options.filetype_exclude,
      },
      indent = { char = lvim.builtin.indentlines.options.char },
      scope = {
        enabled = lvim.builtin.indentlines.options.show_current_context,
        char = lvim.builtin.indentlines.options.context_char,
      },
    }
  else
    local legacy_ok, indent_blankline = pcall(require, "indent_blankline")
    if not legacy_ok then
      return
    end

    indent_blankline.setup(lvim.builtin.indentlines.options)
  end

  if lvim.builtin.indentlines.on_config_done then
    lvim.builtin.indentlines.on_config_done()
  end
end

return M
