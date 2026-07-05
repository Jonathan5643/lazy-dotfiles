# =========================
# aliases.zsh
# =========================

# Custom
alias cls=clear
alias 7z=7zz
#alias docker='container'
#alias docker-compose='container-compose'
#alias python='uv run python'
#alias python3='uv run python'
#alias pip='uv pip'
#alias pip3='uv pip'
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# System
alias ls='ls --color=auto'
alias ll="ls -lhF"
alias la='ls -alhF'
alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# Override
alias ls='lsd'
alias ll='lsd -lhF'
alias la='lsd -alhF'
alias lt='lsd --tree'
alias lg='lsd -la --git'
alias vim='nvim'
alias vi='nvim'
alias cat='bat'
