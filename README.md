# 4SHVIM

A Neovim distribution by [4zmn](https://github.com/4zmn).

Requires **Neovim >= 0.10**. Neovim is not bundled.

---

## Quick Start

```sh
git clone https://github.com/4zmn/4shvim.git
cd 4shvim
./install.sh
fvim
```

---

## How It Works

### Directory Layout

| Path | Purpose |
|------|---------|
| `~/.local/bin/fvim` | Launcher script |
| `~/.local/share/4shvim/4shvim/` | 4SHVIM runtime (cloned repo) |
| `~/.config/4shvim/config.lua` | User config overrides |
| `~/.cache/4shvim/` | Cache directory |

### Startup Flow

1. **`init.lua`** — Entry point. Sets runtimepath, patches `vim.tbl_flatten` / `vim.tbl_add_reverse_lookup`, then bootstraps.

2. **`bootstrap.lua`** — Checks Neovim version (requires 0.10+). Defines global helpers:
   - `get_runtime_dir()`, `get_config_dir()`, `get_cache_dir()`, `get_lvim_base_dir()` — path resolvers
   - `join_paths(...)` — platform-aware path joining
   - `require_clean()`, `require_safe()`, `reload()` — module utilities
   - Patches `vim.fn.stdpath` to redirect cache to `FOURSHVIM_CACHE_DIR`
   - Configures runtimepath for isolated operation (when `FOURSHVIM_RUNTIME_DIR` is set)
   - Initializes [lazy.nvim](https://github.com/folke/lazy.nvim) plugin loader
   - Bootstraps Mason LSP manager

3. **`lvim.config`** — Initializes default config (`lvim` global table), loads `~/.config/4shvim/config.lua` user overrides, sets leader key, defines autocmds.

4. **`lvim.plugins`** — Returns the base plugin spec table (merged with user's `lvim.plugins`).

5. **`lvim.plugin-loader`** — Loads all plugins via lazy.nvim.

6. **`lvim.core.theme`** — Applies colorscheme (default: `oxocarbon`).

7. **`lvim.core.commands`** — Registers user commands.

### Plugin Management

Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

- **Core plugins** are defined in `lua/lvim/plugins.lua`
- **User plugins** go in `~/.config/4shvim/config.lua` under `lvim.plugins`
- **Lockfile** at `~/.config/4shvim/lazy-lock.json`
- Run `:Lazy` to open the plugin UI

---

## Configuration

Edit `~/.config/4shvim/config.lua`:

```lua
-- Change colorscheme
lvim.colorscheme = "tokyonight"

-- Disable transparent background
lvim.transparent_window = false

-- Enable format on save
lvim.format_on_save.enabled = true

-- Add plugins
lvim.plugins = {
  { "folke/tokyo-night.nvim" },
}

-- Add key mappings
lvim.keys.normal_mode["<C-p>"] = ":Telescope find_files<CR>"
```

### Default Settings (`lua/lvim/config/defaults.lua`)

| Option | Default | Description |
|--------|---------|-------------|
| `leader` | `space` | Leader key |
| `colorscheme` | `oxocarbon` | Colorscheme |
| `transparent_window` | `true` | Transparent backgrounds |
| `format_on_save.enabled` | `false` | Auto-format on save |
| `use_icons` | `true` | Enable Nerd Font icons |
| `reload_config_on_save` | `true` | Auto-reload config on edit |

---

## Key Mappings

### Default Bindings

| Key | Action | Mode |
|-----|--------|------|
| `<C-h/j/k/l>` | Window navigation | Normal, Terminal |
| `<C-↑/↓/←/→>` | Resize windows | Normal |
| `<A-j/k>` | Move lines up/down | Insert, Normal |
| `]q` / `[q` | Next/previous quickfix | Normal |
| `>` / `<` | Indent (keeps selection) | Visual |

### Leader Key Mappings (`<Space>`)

| Key | Action |
|-----|--------|
| `<Space>;` | Dashboard |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>/` | Toggle comment |
| `<Space>c` | Close buffer |
| `<Space>f` | Find file (Telescope) |
| `<Space>e` | Toggle NvimTree |
| `<Space>h` | Clear search highlight |
| `<Space>b` | Buffer management (pick, find, prev, next, close, sort) |
| `<Space>g` | Git (lazygit, gitsigns, telescope) |
| `<Space>l` | LSP (code action, diagnostics, format, rename, symbols) |
| `<Space>L` | 4SHVIM (edit config, docs, find/grep 4SHVIM files, changelog, logs, reload, update) |
| `<Space>p` | Plugins (Lazy install, sync, clean, update, log) |
| `<Space>s` | Search (Telescope: files, help, colorscheme, registers, keymaps) |
| `<Space>d` | Debug (DAP: breakpoints, continue, step, REPL) |
| `<Space>T` | Treesitter info |

---

## UI Features

### Dashboard (Alpha)

Opened by default on startup or with `<Space>;`. Features:
- Animated ASCII banner with multiple variants (auto-scales for small terminals)
- Quick-action buttons: Find File, New File, Projects, Recent Files, Find Text, Config, Quit

### Statusline (Lualine)

Clean, minimal statusline with sections:
- **Left**: Mode indicator, filename, Git diff, Python virtualenv
- **Right**: Diagnostics, active LSP clients, tab width, filetype, cursor location, progress

### Which-Key Popup

Press `<Space>` and wait to see available keymaps in a popup window. Shows all leader-prefixed mappings organized by group.

### Bufferline

Tab bar at the top with:
- File icons and names
- Diagnostics indicators (errors/warnings)
- Offsets for NvimTree, Undotree, DiffView, and Lazy

### NvimTree

File explorer with:
- File icons via `nvim-web-devicons`
- Git status indicators on filenames
- Diagnostics indicators

### Completion (nvim-cmp)

Autocompletion popup with:
- Icons per completion kind
- Bordered windows
- Copilot and TabNine source support (if installed)

### LSP Breadcrumbs (Winbar)

Shows LSP symbol breadcrumbs in the window bar for navigable context.

---

## Installed Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/linter installer |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap popup |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Tab bar |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug adapter protocol |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Code comments |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Terminal management |
| [nvim-breadcrumbs](https://github.com/utilyre/breadcrumbs.nvim) | LSP winbar |
| [lir.nvim](https://github.com/tamago324/lir.nvim) | File manager |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | Word highlighting |

See `lua/lvim/plugins.lua` for the full list.

---

## Updating

```sh
fvim --headless '+Lazy! sync' +qa
```

Or from within 4SHVIM: `<Space>Lu` (or `<Space>L` then `u`).

---

## Uninstall

```sh
~/.local/share/4shvim/4shvim/uninstall.sh
# To also remove user config:
~/.local/share/4shvim/4shvim/uninstall.sh --remove-config
```

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

Use `./install.sh` from this repository to test local changes as a separate user-local app.
