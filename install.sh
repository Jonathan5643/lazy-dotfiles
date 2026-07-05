#!/usr/bin/env zsh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD_RED='\033[1;31m'
BG_YELLOW='\033[43;1;30m'
CYAN='\033[0;36m'
NC='\033[0m'

set -e

SOURCE_DIR="${SOURCE_DIR:-$HOME/.config/zsh/lazy-dotfiles}"

# Test mode: use /tmp as HOME (no effect on real config)
if [[ "$1" == "t" || "$1" == "test" ]]; then
  echo -e "${BOLD_RED}████████████████████████████████████████████${NC}"
  echo -e "${BOLD_RED}██          TEST MODE / 测试模式          ██${NC}"
  echo -e "${BOLD_RED}██  Installing to /tmp/ — no real config  ██${NC}"
  echo -e "${BOLD_RED}██     安装到 /tmp/，不会影响真实配置     ██${NC}"
  echo -e "${BOLD_RED}████████████████████████████████████████████${NC}"
  HOME="/tmp"
  SOURCE_DIR="/tmp/.config/zsh/lazy-dotfiles"
fi

echo "============================================"
echo "         LazyDotfiles 安装程序"
echo "============================================"
echo ""
echo -e " ${YELLOW}⚠️  WARNING: Back up your existing config before proceeding!${NC}"
echo "       (~/.zshenv, ~/.hushlogin、~/.config/zsh/) "
echo ""
echo -e " ${YELLOW}⚠️  警告：安装前请务必备份现有的配置文件！${NC}"
echo "       （~/.zshenv、~/.hushlogin、~/.config/zsh/）"
echo ""
echo "============================================"
echo ""

# First confirmation
echo -n "Continue installation? (y/N): "
IFS= read -r confirm </dev/tty
[[ "$confirm" =~ ^[Yy]$ ]] || { echo -e "${RED}Aborted.${NC}"; exit 1; }

echo ""

# Second confirmation — warn about overwriting existing files
echo "============================================"
echo -e " ${YELLOW}⚠️  This will OVERWRITE the following files:${NC}"
echo "     • ~/.zshenv"
echo "     • ~/.hushlogin"
echo "     • ~/.config/zsh/..."
echo ""
echo -e " ${YELLOW}⚠️  以下文件将被覆盖：${NC}"
echo "     • ~/.zshenv"
echo "     • ~/.hushlogin"
echo "     • ~/.config/zsh/..."
echo "============================================"
echo ""
echo -n "Overwrite existing files? (y/N): "
IFS= read -r confirm2 </dev/tty
[[ "$confirm2" =~ ^[Yy]$ ]] || { echo -e "${RED}Aborted.${NC}"; exit 1; }

echo ""

# Create required XDG directories
echo -e "${CYAN}>>> Creating XDG directories...${NC}"
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$HOME/.local/bin/enhance-bin"
mkdir -p "$HOME/.local/opt"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state"
mkdir -p "$HOME/.local/workspace"

# Check if already cloned
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo -e "${CYAN}>>> Cloning lazy-dotfiles...${NC}"
  echo ""
  mkdir -p "$HOME/.config/zsh"
  git clone https://github.com/Jonathan5643/lazy-dotfiles.git "$SOURCE_DIR"
else
  echo -e "${CYAN}>>> Updating lazy-dotfiles...${NC}"
  echo ""
  git -C "$SOURCE_DIR" pull --ff-only
fi
echo ""

echo -e "${CYAN}>>> Copying .zshenv...${NC}"
cp "$SOURCE_DIR/.zshenv" "$HOME/"

echo -e "${CYAN}>>> Copying .hushlogin...${NC}"
cp "$SOURCE_DIR/.hushlogin" "$HOME/"

echo -e "${CYAN}>>> Copying .config/zsh...${NC}"
mkdir -p "$HOME/.config/zsh"
cp -r "$SOURCE_DIR/.config/zsh"/. "$HOME/.config/zsh/"

# Create empty subdirectories (git doesn't track empty dirs)
mkdir -p "$HOME/.config/zsh/history"
mkdir -p "$HOME/.config/zsh/plugins"
mkdir -p "$HOME/.config/zsh/site-functions"

echo ""
echo "============================================"
echo -e " ${GREEN}Done! 安装完成 🎉${NC}"
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
