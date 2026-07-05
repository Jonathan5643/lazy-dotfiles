# lazy-dotfiles

> 基于 [XDG 基础目录规范](https://specifications.freedesktop.org/basedir-spec/latest/) 的模块化 zsh 配置。

[English Documentation](README.md) 🌐

🚀 **懒人专属 zsh 配置**：配置自动拉取依赖工具和插件，零手动干预开箱即用。

---

## 功能特性

| 特性 | 说明 |
|------|------|
| 📁 **XDG 规范** | 全部配置、缓存、数据遵循 XDG 标准目录，告别 `$HOME` 文件污染 |
| 🧩 **模块化架构** | 别名、快捷键、函数、补全等按模块拆分，维护简单 |
| ⏳ **惰性补全加载** | 命令补全仅在首次 TAB 时加载，缩短 shell 启动时间 |
| ⚡ **自动二进制管理** | [zbinary](.config/zsh/module/zbinary.zsh) — 从 GitHub 自动下载管理的 16 个 CLI 工具 |
| 🔌 **自动插件管理** | [zplugin](.config/zsh/module/zplugin.zsh) — 自动 git clone 并加载 zsh 插件 |
| 🧹 **退出自动清理** | 退出 shell 时自动清理 fnm 临时目录和系统缓存文件（🔒 默认关闭 — 见安全说明） |
| 🔄 **一键更新** | `all-update` 命令同时更新二进制工具和插件 |
| 🛠️ **工具函数** | 内置 `clean_dsstore`、`clean_maven_cache` 等实用命令 |
| 🇨🇳 **镜像加速** | 内置镜像加速 |

---

## 系统要求

- Zsh 5.2+（macOS 自带）
- macOS

---

## 安装

> **⚠️ 警告**：安装前请务必备份你现有的配置文件！

> 💡 **首次运行**：安装后第一次启动 shell 时，会自动下载所需的 CLI 工具和 zsh 插件，可能需要一些时间。**第二次启动就正常快速了。**
>
> 💡 **提示**：本仓库大多数文件以点（`.`）开头，在 Finder 中是隐藏的。按 `⌘ Command` + `.`（句号键）可切换显示隐藏文件。

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/Jonathan5643/lazy-dotfiles/refs/heads/master/install.sh | zsh
```

### 手动安装（按需复制）

> 安装脚本会自动创建所需的 XDG 目录（`~/.cache/zsh`、`~/.local/bin` 等）。

将以下文件从克隆后的仓库复制到对应位置：

| 源路径 | 目标路径 |
|--------|----------|
| `.zshenv` | `~/` |
| `.config/zsh/` | `~/.config/zsh/`（或只复制 `module/` 目录按需加载） |
| `.hushlogin` | `~/` |

> 💡 `module/` 下的所有文件都是**可选**的。你可以按需选择，在已有的 `.zshrc` 中 `source` 即可。例如只要自动下载二进制和插件：
> ```zsh
> # 添加到你的 ~/.zshrc
> source ~/.config/zsh/module/zbinary.zsh
> source ~/.config/zsh/module/zplugin.zsh
> ```
>
> 每个模块文件末尾维护了各自的注册表，可以手动添加/修改：
> - `zbinary.zsh` — 管理 CLI 工具（第 150–161 行）
> - `zplugin.zsh` — 管理 zsh 插件（第 63–68 行）
> - `completions.zsh` — 管理惰性补全命令（第 40–43 行）


---

## 目录结构

```
~/.zshenv                    # XDG 基础目录设定
~/.hushlogin                 # 屏蔽 "Last login" 提示
~/.config/zsh/
├── .zshrc                   # Zsh 主配置（history/completion/模块加载）
├── .zprofile                # 环境变量（镜像/SDK/PATH）
├── .zlogin                  # 登录欢迎信息
├── .zlogout                 # 退出自动清理缓存
├── module/
│   ├── zbinary.zsh          # 🛠️ 二进制工具自动下载/更新系统（16 个工具）
│   ├── zplugin.zsh          # 🔌 Zsh 插件自动管理（5 个插件）
│   ├── aliases.zsh          # 📎 别名定义
│   ├── bindings.zsh         # ⌨️ 键位绑定（vi 模式/历史搜索）
│   ├── functions.zsh        # ⚙️ 自定义函数
│   └── completions.zsh      # 🎯 惰性补全加载系统
├── history/                 # Shell 历史记录（安装后自动生成）
├── plugins/                 # Zsh 插件（zplugin 自动安装）
└── site-functions/          # 自定义补全函数
```

> 💡 登录时显示的欢迎信息在 `.zlogin` 中，可以修改自定义。当前内容：`echo "Welcome back 👋. Use all-update"`

安装脚本还会创建以下 XDG 目录：

| 目录 | 用途 |
|------|------|
| `~/.cache/zsh` | zsh 补全缓存和历史记录 |
| `~/.local/bin` | CLI 工具（由 `zbinary` 自动下载） |
| `~/.local/bin/enhance-bin` | 增强 CLI 工具（bat、lsd、nvim 等） |
| `~/.local/opt` | SDK 安装目录（Java、Maven 等） |
| `~/.local/share` | 应用数据（uv 缓存等） |
| `~/.local/state` | 运行时状态（zoxide 数据等） |
| `~/.local/workspace` | 项目工作区 |

> 💡 workspace 可以通过修改 `.zshenv` 中的 `WORKSPACE_HOME` 变量来自定义。不建议修改其他 XDG 配置。

---

## 使用说明

### 核心命令

| 命令 | 说明 |
|------|------|
| `all-update` | 一键更新二进制工具和插件 |
| `zbinary-update` | 仅更新二进制工具 |
| `zplugin-update` | 仅更新 zsh 插件 |
| `clean_dsstore` | 递归删除 `.DS_Store`（排除 node_modules/.git） |
| `clean_maven_cache` | 清理 Maven 下载失败缓存 |
| `y` | 启动 Yazi 文件管理器，退出后自动 cd |

### 快捷键

| 功能 | 快捷键 |
|------|--------|
| 历史命令搜索（上） | `↑` |
| 历史命令搜索（下） | `↓` |
| 编辑模式光标 | 插入模式：`▏`，普通模式：`█`（vi 模式） |

### 别名示例

> ℹ️ `module/aliases.zsh` 中部分别名默认已注释，如需使用可取消注释。

| 命令 | 实际执行 |
|------|----------|
| `ls` | `lsd` |
| `cat` | `bat` |
| `vim` / `vi` | `nvim` |
| `grep` | `rg --color=auto` |

---

## TODO

- [ ] 添加 Ghostty 终端配置
- [ ] 添加 Starship 提示符配置

## 安全说明

本项目包含一些工具函数会执行文件操作，公开透明地列在这里：

| 函数 | 操作 | 保护机制 |
|------|------|---------|
| `clean_dsstore` | `sudo rm -f` 递归删除 `.DS_Store` | ✅ 执行前有用户确认对话框；跳过 `node_modules` / `.git` 目录 |
| `clean_maven_cache` | `rm -f` Maven `.lastUpdated` / `_repositories` 缓存 | ✅ 执行前有用户确认；仅限特定文件类型 |
| `.zlogout`（已注释） | `rm -rf` 过期 fnm 临时目录 & `osascript` 移入废纸篓 | 🔒 **默认关闭** — 如需启用请手动取消注释 |

所有删除操作均不会自动执行，需要用户主动调用并确认后方可运行。

## 开源协议

本项目基于 [Apache License 2.0](LICENSE) 开源。
