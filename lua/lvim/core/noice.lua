local M = {}

M.config = function()
  lvim.builtin.noice = {
    active = true,
    on_config_done = nil,
  }
end

M.setup = function()
  local status_ok, noice = pcall(require, "noice")
  if not status_ok then
    return
  end

  noice.setup {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {
        position = {
          row = "50%",
          col = "50%",
        },
        border = {
          style = "rounded",
        },
      },
    },
    messages = {
      enabled = true,
      view = "notify",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        "vim.lsp.util.convert_input_to_markdown",
        "vim.lsp.util.stylify_markdown",
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = false,
      inc_rename = false,
      lsp_doc_border = false,
    },
  }

  if lvim.builtin.noice.on_config_done then
    lvim.builtin.noice.on_config_done(noice)
  end
end

return M
