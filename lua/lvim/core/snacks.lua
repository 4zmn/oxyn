local M = {}

M.config = function()
  lvim.builtin.snacks = {
    active = true,
    on_config_done = nil,
  }
end

M.setup = function()
  local status_ok, snacks = pcall(require, "snacks")
  if not status_ok then
    return
  end

  snacks.setup {
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      char = lvim.icons.ui.LineLeft,
      only_scope = false,
      only_current = true,
    },
    scroll = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣴⠟⠉⠀⠀⠉⠻⣦⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⠃⠀⢠⣶⣶⡄⠀⠘⣧⠀⠀⠀⠀
⠀⠀⠀⠀⣿⠀⠀⣿⣿⣿⣿⠀⠀⣿⠀⠀⠀⠀
⠀⠀⠀⠀⢿⡄⠀⠘⠿⠿⠃⠀⢠⡿⠀⠀⠀⠀
⠀⠀⠀⠀⠈⢿⣦⣄⣀⣀⣠⣴⡿⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠛⠿⠿⠛⠉⠀⠀⠀⠀⠀⠀

              oxyn]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  }

  if lvim.builtin.snacks.on_config_done then
    lvim.builtin.snacks.on_config_done(snacks)
  end
end

return M
