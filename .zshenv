# =========================
# XDG base directories
# =========================

# Centralizes config/cache/data/state locations
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# =========================
# Other base directories
# =========================

# Workspace base directory (Custom)
export WORKSPACE_HOME="${WORKSPACE_HOME:-$HOME/.local/workspace}"

# Bin base directory
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# Sdk base directory
export XDG_OPT_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}"

# Zsh base directory
export ZDOTDIR="$HOME/.config/zsh"
