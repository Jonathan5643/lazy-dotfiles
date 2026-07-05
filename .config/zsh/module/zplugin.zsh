# =========================
# plugins.zsh
# =========================

# Plugin Directory
ZPLUGINDIR="$XDG_CONFIG_HOME/zsh/plugins"

# Load all plugins (install if missing)
_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    command mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    command git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

# Update all plugins
zplugin-update() {
  local dir before_sha pull_output
  local updated=0 skipped=0 failed=0
  local -a updated_plugins

  for dir in "${ZPLUGINDIR}"/*/; do
    before_sha=$(command git -C "$dir" rev-parse --short HEAD 2>&1) || {
      echo "[${dir:t}] ERROR: ${before_sha%%$'\n'*}"
      [[ "$before_sha" == *$'\n'* ]] && echo "  ${before_sha#*$'\n'}"
      ((failed++))
      continue
    }

    if pull_output=$(command git -C "$dir" pull --ff-only 2>&1); then
      echo -n "[${dir:t}] ${before_sha} -> "
      after_sha=$(command git -C "$dir" rev-parse --short HEAD 2>&1) || {
        echo "[${dir:t}] ERROR: ${after_sha%%$'\n'*}"
        [[ "$after_sha" == *$'\n'* ]] && echo "  ${after_sha#*$'\n'}"
        ((failed++))
        continue
      }
      if [[ "$before_sha" != "$after_sha" ]]; then
        local commit_count=$(command git -C "$dir" rev-list --count ${before_sha}..${after_sha} 2>/dev/null)
        echo "${after_sha} ... updated (${commit_count} commits)"
        ((updated++))
        updated_plugins+=("${dir:t}")
      else
        echo "${after_sha} ... up to date"
        ((skipped++))
      fi
    else
      echo "[${dir:t}] ERROR: ${pull_output%%$'\n'*}"
      [[ "$pull_output" == *$'\n'* ]] && echo "  ${pull_output#*$'\n'}"
      ((failed++))
    fi
  done

  echo
  echo "Summary: ${updated} updated, ${skipped} skipped, ${failed} failed"
  (( updated > 0 )) && echo "Updated: ${(j:, :)updated_plugins}"
}

# Load all plugins
_zplugin_load jeffreytse zsh-vi-mode # Replaced: echo -ne '\e[5 q' (Cursor styles 1-6)
_zplugin_load zsh-users zsh-history-substring-search
_zplugin_load zsh-users zsh-completions # third-party completions
_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-syntax-highlighting # _zplugin_load zdharma-continuum fast-syntax-highlighting
