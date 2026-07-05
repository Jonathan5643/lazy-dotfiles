# lazy-dotfiles

> Modular zsh config following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

[中文文档](README.zh.md) 🇨🇳

A **lazy-friendly** zsh config: automatically download CLI tools and plugins on first use — zero manual setup.

---

## Features

| Feature | Description |
|---------|-------------|
| 📁 **XDG Compliant** | All config/cache/data follow XDG standard directories — no `$HOME` pollution |
| 🧩 **Modular Architecture** | Aliases, keybindings, functions, completions split into separate modules |
| ⏳ **Lazy Completions** | Command completions load only on first TAB press — faster shell startup |
| ⚡ **Auto Binary Manager** | [zbinary](.config/zsh/module/zbinary.zsh) — auto-downloads & updates 16 CLI tools from GitHub |
| 🔌 **Auto Plugin Manager** | [zplugin](.config/zsh/module/zplugin.zsh) — auto-clones & loads zsh plugins on demand |
| 🧹 **Auto Cleanup on Exit** | Cleans fnm temp dirs and system caches when shell exits (🔒 disabled by default — see Security) |
| 🔄 **One-Key Update** | `all-update` updates binaries and plugins in one command |
| 🛠️ **Utility Functions** | Built-in `clean_dsstore`, `clean_maven_cache` and more |
| 🇨🇳 **Mirror Acceleration** | Built-in mirror acceleration |

---

## Requirements

- Zsh 5.2+ (built-in on macOS)
- macOS

---

## Installation

> **⚠️ WARNING**: Back up your existing config before installing!

> 💡 **First run**: After installation, the first shell session will automatically download all required CLI tools and zsh plugins. This may take a moment. **The second session will be fast and normal.**
>
> 💡 **Tip**: Most files in this repo start with a dot (`.`), which are hidden in Finder. Press `⌘ Command` + `.` (dot) to toggle hidden file visibility.

### Quick Install (one-click script)

```bash
curl -fsSL https://raw.githubusercontent.com/Jonathan5643/lazy-dotfiles/refs/heads/master/install.sh | zsh
```

### Selective Install (copy only what you need)

> The install script also creates the required XDG directories (`~/.cache/zsh`, `~/.local/bin`, etc.) automatically.

Copy the following files from the cloned repo to your home directory:

| Source | Destination |
|--------|-------------|
| `.zshenv` | `~/` |
| `.config/zsh/` | `~/.config/zsh/` (or `~/.config/zsh/module/` for modules only) |
| `.hushlogin` | `~/` |

> 💡 All files in `module/` are **optional**. You can pick only what you need and source them from your existing `.zshrc`. For example, if you only want automatic binary management:
> ```zsh
> # Add to your ~/.zshrc
> source ~/.config/zsh/module/zbinary.zsh
> source ~/.config/zsh/module/zplugin.zsh
> ```
>
> Each module file maintains its own registry at the end of the file — you can add or modify tools, plugins, or completions there:
> - `zbinary.zsh` — manages CLI binaries (lines 150–161)
> - `zplugin.zsh` — manages zsh plugins (lines 63–68)
> - `completions.zsh` — manages lazy-loaded completions (lines 40–43)


---

## Directory Structure

```
~/.zshenv                    # XDG base directory setup
~/.hushlogin                 # Suppress "Last login" message
~/.config/zsh/
├── .zshrc                   # Main zsh config (history/completion/module loading)
├── .zprofile                # Environment variables (mirrors/SDK/PATH)
├── .zlogin                  # Login welcome message
├── .zlogout                 # Auto cleanup on exit
├── module/
│   ├── zbinary.zsh          # 🛠️ Auto binary download & update system (16 tools)
│   ├── zplugin.zsh          # 🔌 Auto zsh plugin manager (5 plugins)
│   ├── aliases.zsh          # 📎 Alias definitions
│   ├── bindings.zsh         # ⌨️ Key bindings (vi mode / history search)
│   ├── functions.zsh        # ⚙️ Custom shell functions
│   └── completions.zsh      # 🎯 Lazy completion loading system
├── history/                 # Shell history (auto-created on first use)
├── plugins/                 # Zsh plugins (auto-installed by zplugin)
└── site-functions/          # Custom completion functions
```

> 💡 The welcome message printed on login lives in `.zlogin`. Edit it to customize the greeting.

The install script also creates these XDG directories:

| Directory | Purpose |
|-----------|---------|
| `~/.cache/zsh` | Zsh completion cache & history file |
| `~/.local/bin` | CLI tools (auto-downloaded by `zbinary`) |
| `~/.local/bin/enhance-bin` | Enhanced CLI tools (bat, lsd, nvim, etc.) |
| `~/.local/opt` | SDK installations (Java, Maven, etc.) |
| `~/.local/share` | Application data (uv cache, etc.) |
| `~/.local/state` | Runtime state (zoxide data, etc.) |
| `~/.local/workspace` | Project workspace directory |

> 💡 You can customize the workspace path in `.zshenv` by changing the `WORKSPACE_HOME` variable. Other XDG configurations are not recommended to modify.

---

## Usage

### Core Commands

| Command | Description |
|---------|-------------|
| `all-update` | One-key update: binaries + plugins |
| `zbinary-update` | Update CLI tools only |
| `zplugin-update` | Update zsh plugins only |
| `clean_dsstore` | Recursively delete `.DS_Store` files (excludes node_modules/.git) |
| `clean_maven_cache` | Clean Maven failed-download caches |
| `y` | Launch Yazi file manager, auto-cd on exit |

### Keybindings

| Action | Key |
|--------|-----|
| History search up | `↑` |
| History search down | `↓` |
| Vi mode cursor | Insert: `▏`, Normal: `█` |

### Alias Examples

> ℹ️ Some aliases in `module/aliases.zsh` are commented out by default. Uncomment them if needed.

| Command | Actual |
|---------|--------|
| `ls` | `lsd` |
| `cat` | `bat` |
| `vim` / `vi` | `nvim` |
| `grep` | `rg --color=auto` |

---
## TODO

- [ ] Add Ghostty terminal configuration
- [ ] Add Starship prompt configuration

## Security

This project includes utility functions that perform file operations. Below is a summary for transparency:

| Function | Action | Guard |
|----------|--------|-------|
| `clean_dsstore` | `sudo rm -f` `.DS_Store` files recursively | ✅ User confirmation prompt before deletion; excludes `node_modules` / `.git` |
| `clean_maven_cache` | `rm -f` Maven `.lastUpdated` / `_repositories` cache files | ✅ User confirmation prompt; limited to specific file types |
| `.zlogout` (commented out) | `rm -rf` old fnm temp dirs & trash cache via `osascript` | 🔒 **Disabled by default** — uncomment manually if desired |

None of the destructive operations run automatically. Each requires explicit user invocation and confirmation.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
