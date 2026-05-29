local M = {}

M.config = function()
  lvim.builtin.auto_session = {
    active = true,
    on_config_done = nil,
  }
end

M.setup = function()
  local status_ok, auto_session = pcall(require, "auto-session")
  if not status_ok then
    return
  end

  auto_session.setup {
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = { "/", "~" },
    root_dir = vim.fn.stdpath "data" .. "/sessions/",
    -- don't bother with session restoration for alpha/nvimtree etc
    close_unsupported_filetypes = true,
    bypass_save_filetypes = { "alpha", "NvimTree", "lir" },
  }

  if lvim.builtin.auto_session.on_config_done then
    lvim.builtin.auto_session.on_config_done(auto_session)
  end
end

return M
