local M = {}

M.config = function()
  lvim.builtin.todo_comments = {
    active = true,
    on_config_done = nil,
  }
end

M.setup = function()
  local status_ok, todo = pcall(require, "todo-comments")
  if not status_ok then
    return
  end

  todo.setup {
    signs = true,
    sign_priority = 10,
    keywords = {
      FIX = { icon = lvim.icons.ui.Bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = lvim.icons.ui.CheckCircle, color = "info" },
      HACK = { icon = lvim.icons.ui.Warning, color = "warning" },
      WARN = { icon = lvim.icons.ui.Alert, color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = lvim.icons.ui.Telescope, color = "test", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = lvim.icons.ui.Note, color = "hint", alt = { "INFO" } },
    },
    highlight = {
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s]],
      comments_only = true,
      max_line_len = 400,
    },
    search = { pattern = [[\b(KEYWORDS)\b]] },
  }

  if lvim.builtin.todo_comments.on_config_done then
    lvim.builtin.todo_comments.on_config_done(todo)
  end
end

return M
