local base_dir = vim.env.OXYN_BASE_DIR
  or (function()
    local init_path = debug.getinfo(1, "S").source
    return init_path:sub(2):match("(.*[/\\])"):sub(1, -2)
  end)()

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:prepend(base_dir)
end

if not vim._patched_deprecated_tbl then
  vim._patched_deprecated_tbl = true
  vim.tbl_flatten = function(t) return vim.iter(t):flatten(math.huge):totable() end
  vim.tbl_add_reverse_lookup = function(t)
    for k, v in pairs(t) do t[v] = k end
  end
end

require("lvim.bootstrap"):init(base_dir)

require("lvim.config"):load()

local plugins = require "lvim.plugins"

require("lvim.plugin-loader").load { plugins, lvim.plugins }

require("lvim.core.theme").setup()

local Log = require "lvim.core.log"
Log:debug "Starting OXYN"

local commands = require "lvim.core.commands"
commands.load(commands.defaults)
