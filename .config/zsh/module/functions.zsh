# =========================
# functions.zsh
# =========================

# Clean .DS_Store files (display deletion list in terminal)
function clean_dsstore() {
  local dir confirm count=0
  local -a dsstore_files

  # Obtain sudo privileges in advance
  sudo -v || return

  # Input directory (default: HOME)
  printf "请输入要扫描的目录（默认：%s）： " "$HOME"
  IFS= read -r dir
  dir="${dir:-$HOME}"
  dir="${dir/#\~/$HOME}"

  # Check directory existence
  if [[ ! -d "$dir" ]]; then
    printf "\n目录不存在：%s\n" "$dir"
    return
  fi

  printf "\n正在扫描 .DS_Store 文件...\n"

  # Scan once
  while IFS= read -r -d '' file; do
    dsstore_files+=("$file")
    ((count++))
  done < <(
    sudo find "$dir" \
      \( \
        -path "/System/Volumes/Data" -o \
        -name node_modules -o \
        -name .git \
      \) -prune -o \
      -type f \
      -name ".DS_Store" \
      ! -path "$HOME/.DS_Store" \
      ! -path "$HOME/Desktop/.DS_Store" \
      -print0 \
      2>/dev/null
  )

  # Not found
  (( count )) || { printf "未找到 .DS_Store 文件。\n"; return; }

  printf "共找到 %d 个 .DS_Store 文件：\n\n" "$count"
  printf '%s\n' "${dsstore_files[@]}"

  # Delete confirmation
  printf "\n是否删除以上所有文件？(y/n)： "
  IFS= read -r confirm

  [[ "$confirm" =~ ^[Yy]$ ]] || { printf "\n已取消操作。\n"; return; }

  printf "\n正在删除文件...\n"
  printf '%s\0' "${dsstore_files[@]}" | sudo xargs -0 rm -f --
  printf "正在重启 Finder...\n"; command killall Finder 2>/dev/null
  printf "\n删除完成。\n"
}

# Clean Maven *.lastUpdated, _maven.repositories and _remote.repositories files
function clean_maven_cache() {
  local repo_dir confirm count=0
  local -a cache_files

  # Maven repository directory
  repo_dir="${1:-$XDG_DATA_HOME/m2/repository}"

  # Check repository existence
  if [[ ! -d "$repo_dir" ]]; then
    printf "\nMaven 仓库不存在：%s\n" "$repo_dir"
    return
  fi

  printf "\n正在扫描 Maven 下载失败及仓库缓存文件...\n"

  # Scan once
  while IFS= read -r -d '' file; do
    cache_files+=("$file")
    ((count++))
  done < <(
    find "$repo_dir" \
      -type f \
      \( \
        -name "*.lastUpdated" -o \
        -name "_maven.repositories" -o \
        -name "_remote.repositories" \
      \) \
      -print0
  )

  # Not found
  (( count )) || { printf "未找到需要清理的 Maven 缓存文件。\n"; return; }

  printf "共找到 %d 个 Maven 缓存文件：\n\n" "$count"
  printf '%s\n' "${cache_files[@]}"

  # Delete confirmation
  printf "\n是否删除以上所有文件？(y/n)： "
  IFS= read -r confirm

  [[ "$confirm" =~ ^[Yy]$ ]] || { printf "\n已取消操作。\n"; return; }

  printf "\n正在删除文件...\n"
  printf '%s\0' "${cache_files[@]}" | xargs -0 rm -f --

  printf "\n删除完成。\n"
}

# Update common development tools.
function all-update() {
  printf "\n==> zplugin-update\n"
  zplugin-update
  printf "\n==> zbinary-update\n"
  zbinary-update
}

# Yazi change directory
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# history filter(auto)
function zshaddhistory() {
  emulate -L zsh
  local cmd=${1%%$'\n'}
  case "$cmd" in
    ls*|ll|la|lt|tree|cd*|z|z\ *) return 1 ;;
    exit|clear|cls|nvim|vim|vi|y|yazi) return 1 ;;
    flashfetch|fastfetch|macpow|mactop) return 1 ;;
    *help|*--version) return 1 ;;
  esac
  return 0
}
