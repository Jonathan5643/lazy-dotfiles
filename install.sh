#!/usr/bin/env zsh

set -e

SOURCE_DIR="${SOURCE_DIR:-$HOME/.config/zsh/lazy-dotfiles}"

# Test mode: use /tmp as HOME (no effect on real config)
if [[ "$1" == "t" || "$1" == "test" ]]; then
  echo " [TEST MODE] Installing to /tmp — no real config will be touched"
  HOME="/tmp"
  SOURCE_DIR="/tmp/.config/zsh/lazy-dotfiles"
fi

echo "============================================"
echo "         LazyDotfiles 安装程序"
echo "============================================"
echo ""
echo "  ⚠️  警告：安装前请务必备份现有的配置文件！"
echo "       （~/.zshenv、~/.config/zsh/）"
echo ""
echo "  ⚠️  WARNING: Back up your existing config"
echo "       (~/.zshenv, ~/.config/zsh/) before proceeding!"
echo ""
echo "============================================"
echo ""

# First confirmation
echo -n "Continue installation? (y/N): "
IFS= read -r confirm </dev/tty
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

echo ""

# Second confirmation — warn about overwriting existing files
echo "============================================"
echo " ⚠️  This will OVERWRITE the following files:"
echo "     • ~/.zshenv"
echo "     • ~/.config/zsh/"
echo ""
echo " ⚠️  以下文件将被覆盖："
echo "     • ~/.zshenv"
echo "     • ~/.config/zsh/"
echo "============================================"
echo ""
echo -n "Overwrite existing files? (y/N): "
IFS= read -r confirm2 </dev/tty
[[ "$confirm2" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

echo ""

# Create required XDG directories
echo ">>> Creating XDG directories..."
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$HOME/.local/bin/enhance-bin"
mkdir -p "$HOME/.local/opt"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state"
mkdir -p "$HOME/.local/workspace"

# Check if already cloned
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo ">>> Cloning LazyDotfiles..."
  mkdir -p "$HOME/.config/zsh"
  git clone https://github.com/Jonathan5643/lazy-dotfiles.git "$SOURCE_DIR"
else
  echo ">>> Updating LazyDotfiles..."
  git -C "$SOURCE_DIR" pull --ff-only
fi
echo ""

echo ">>> Copying .zshenv..."
cp "$SOURCE_DIR/.zshenv" "$HOME/"

echo ">>> Copying .config/zsh..."
mkdir -p "$HOME/.config/zsh"
cp -r "$SOURCE_DIR/.config/zsh"/. "$HOME/.config/zsh/"

# Create empty subdirectories (git doesn't track empty dirs)
mkdir -p "$HOME/.config/zsh/history"
mkdir -p "$HOME/.config/zsh/plugins"
mkdir -p "$HOME/.config/zsh/site-functions"

echo ""
echo "============================================"
echo " Done! 安装完成 🎉"
echo ""
echo " 📌 First run: the first shell session will"
echo "    automatically download CLI tools and zsh"
echo "    plugins. This may take a moment."
echo ""
echo " 📌 首次运行：第一次启动 shell 时会自动下载"
echo "    CLI 工具和 zsh 插件，可能需要一些时间。"
echo "    第二次启动就正常快速了。"
echo ""
echo " Restart your shell or run / 重启 shell 或执行："
echo "   source ~/.zshenv"
echo "   source ~/.config/zsh/.zshrc"
echo "============================================"
