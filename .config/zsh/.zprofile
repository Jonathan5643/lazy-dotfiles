# =========================
# Export Env
# =========================

# System setting
export SHELL_SESSIONS_DISABLE=1 # Terminal
export UV_MANAGED_PYTHON=1 # UV
export PIP_REQUIRE_VIRTUALENV=1 # UV PIP
export UV_PYTHON_INSTALL_BIN=false # UV Bin

# XDG-aware setting
export _ZO_DATA_DIR="$XDG_STATE_HOME/zoxide"
export UV_CACHE_DIR="$XDG_DATA_HOME/uv/cache"
export NPM_CONFIG_CACHE="$XDG_DATA_HOME/fnm/node-cache/npm"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Mirror acceleration
export FNM_NODE_DIST_MIRROR="https://npmmirror.com/mirrors/node"
export NPM_CONFIG_REGISTRY="https://registry.npmmirror.com"
export UV_PYTHON_INSTALL_MIRROR="https://registry.npmmirror.com/-/binary/python-build-standalone"
export UV_INDEX_URL="https://mirrors.aliyun.com/pypi/simple"

# =========================
# Path
# =========================

# PATH Deduplication
typeset -U path

# PATH
path=(
  # XDG bin
  "$XDG_BIN_HOME"(N)
  "$XDG_BIN_HOME"/*(/N)
  # System PATH
  $path
)
