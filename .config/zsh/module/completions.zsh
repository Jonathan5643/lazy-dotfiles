# =========================
# completions.zsh
# =========================

# Record whether lazy completion has been registered for each command
typeset -gA _LAZY_COMP_INIT

# Register lazy completion
# Purpose:
# - Delay loading of CLI completions
# - Execute loader only on first TAB press
# - Avoid loading all completion scripts at zsh startup
_lazy_compdef() {
  local cmd="$1"       # command name（fnm / starship）
  local loader="$2"    # Command to generate completion

  # Prevent duplicate registration of the same command
  [[ -n "${_LAZY_COMP_INIT[$cmd]}" ]] && return
  _LAZY_COMP_INIT[$cmd]=1

  # Generate a safe function name (avoiding illegal characters like -)
  local fn="_lazy_${cmd//[^a-zA-Z0-9_]/_}_setup"

  # lazy wrapper(First TAB trigger):
  # 1. Delete itself (executes only once)
  # 2. Execute completion loader
  # 3. Subsequent completion will be handled by the zsh completion system
  eval "
  $fn() {
    unfunction $fn 2>/dev/null
    eval \"\$($loader)\"
  }

  # Bind the wrapper to the command for completion
  compdef $fn $cmd
  "
}

# Lazy loading completion (only requires pressing TAB once more)
_lazy_compdef fnm "fnm completions --shell zsh" # eval "$(fnm completions --shell zsh)"
_lazy_compdef uvx "uvx generate-shell-completion zsh 2>/dev/null" #i f output="$(uvx generate-shell-completion zsh 2>/dev/null)"; then eval "$output"; fi
_lazy_compdef uv "uv generate-shell-completion zsh 2>/dev/null" # if output="$(uv generate-shell-completion zsh 2>/dev/null)"; then eval "$output"; fi
