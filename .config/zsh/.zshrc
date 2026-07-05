# =========================
# Terminal
# =========================

# Shell History
HISTFILE="$XDG_CONFIG_HOME/zsh/history/history.txt"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_FCNTL_LOCK
setopt HIST_VERIFY

# Shell behaviour
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# Completion Styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Completion Initialization
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Initialization
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --shell zsh)"

# Modular configuration loading
source "$ZDOTDIR"/module/zbinary.zsh
source "$ZDOTDIR"/module/zplugin.zsh
source "$ZDOTDIR"/module/aliases.zsh
source "$ZDOTDIR"/module/bindings.zsh
source "$ZDOTDIR"/module/functions.zsh
source "$ZDOTDIR"/module/completions.zsh

# =========================
# FPATH
# =========================

# FPATH Deduplication
typeset -U fpath

# FPATH
fpath=(
  "$XDG_CONFIG_HOME/zsh/site-functions"
  $fpath
)
