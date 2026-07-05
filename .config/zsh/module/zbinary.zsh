# =========================
# binarys.zsh
# =========================

# Binary Directory
BINDIR="$XDG_BIN_HOME"

# Temporary download directory
BINTMPDIR="/tmp/binary"

# Tool registry — _tool(name repo path archive names asset_name)
_tool() { local n=$1; shift; _binary_repo[$n]="$1"; _binary_path[$n]="$2"; _binary_archive[$n]="$3"; _binary_names[$n]="$4"; _binary_asset_name[$n]="$5"; }
typeset -gA _binary_repo _binary_path _binary_archive _binary_names _binary_asset_name

# ── Internal functions ──

# Get release info (returns "tag_name\tdownload_url") — HTTP redirect, no API
_binary_get_release_info() {
  local tool="$1" repo="$2" tag out
  out=$(command curl -fsSL -o /dev/null -w '%{url_effective}' \
    "https://github.com/${repo}/releases/latest" 2>&1) || {
    echo "curl: ${out%%$'\n'*}"; return 1
  }
  tag="${out##*/}"
  local name="${_binary_asset_name[$tool]}" v="${tag#v}"
  name="${name//\{VERSION\}/$v}"
  name="${name//\{VERSION_NODOT\}/${v//./}}"
  echo "${tag}\thttps://github.com/${repo}/releases/download/${tag}/${name}"
}

# Download archive and install binary(ies). Usage: _binary_install <tool> [latest_version] [download_url]
_binary_install() {
  local tool="$1" ver="${2:-}" url="${3:-}"
  local repo="${_binary_repo[$tool]}" archive="${_binary_archive[$tool]}" names="${_binary_names[$tool]}" info tag

  # If version and URL not provided, fetch from API (with caching)
  if [[ -z "$ver" || -z "$url" ]]; then
    info=$(_binary_get_release_info "$tool" "$repo") || { echo "ERROR: ${info}"; return 1; }
    tag="${info%%$'\t'*}"; url="${info#*$'\t'}"
    [[ -z "$tag" || "$tag" == "null" ]] && { echo "ERROR: could not parse release version"; return 1; }
    ver="${tag#v}"
  fi

  local tdir="$BINTMPDIR/${tool}"
  local afile="${tdir}/archive"
  command mkdir -p "$tdir" || { echo "ERROR: failed to create temp dir '${tdir}'"; return 1; }

  echo -n "  Downloading... "
  local dl_out=$(command curl -fL -o "$afile" "$url" 2>&1) && echo "done" || {
    echo "failed"; echo "ERROR: ${dl_out%%$'\n'*}"; [[ "$dl_out" == *$'\n'* ]] && echo "  ${dl_out#*$'\n'}"; return 1
  }

  echo -n "  Extracting... "
  local ext_out
  case "$archive" in
    tgz|xz) ext_out=$(command tar -xf "$afile" -C "$tdir" 2>&1) && echo "done" || {
      echo "failed"; echo "ERROR: ${ext_out%%$'\n'*}"; [[ "$ext_out" == *$'\n'* ]] && echo "  ${ext_out#*$'\n'}"; return 1; } ;;
    zip)    ext_out=$(command unzip -qo "$afile" -d "$tdir" 2>&1) && echo "done" || {
      echo "failed"; echo "ERROR: ${ext_out%%$'\n'*}"; [[ "$ext_out" == *$'\n'* ]] && echo "  ${ext_out#*$'\n'}"; return 1; } ;;
    *)      echo "ERROR: unknown archive type '$archive'"; return 1 ;;
  esac

  # Install each binary
  local bin src dest ok=1
  for bin in ${=names}; do
    src=$(command find "$tdir" -name "$bin" -type f 2>/dev/null | command head -1)
    [[ -z "$src" ]] && { echo "WARN: '${bin}' not found in archive"; ok=0; continue; }
    dest="$BINDIR/${_binary_path[$bin]:-$bin}"
    command mkdir -p "$(dirname "$dest")" 2>/dev/null
    command mv -f "$src" "$dest" 2>&1 || { echo "ERROR: failed to replace '${dest}'"; ok=0; continue; }
    command xattr -d com.apple.quarantine "$dest" 2>/dev/null
  done

  (( ok )) && echo "  installed -> ${ver}" || echo "installed with warnings"
  command rm -rf "$tdir"
}

# ── Public functions ──
# Load all binaries (install if missing)
_zbinary_load() {
  local t="$1"
  if (( $# > 1 )); then _tool "$t" "${@:2}"; fi
  if [[ ! -x "$BINDIR/${_binary_path[$t]}" ]]; then
    echo "Installing $t..."
    _binary_install "$t" || { echo "ERROR: failed to install $t" >&2; return 1; }
  fi
}

# Update all binaries
zbinary-update() {
  local tool repo dest cur latest info tag url
  local updated=0 skipped=0 failed=0; local -a updated_tools

  for tool in ${(k)_binary_repo}; do
    repo="${_binary_repo[$tool]}"
    dest="$BINDIR/${_binary_path[$tool]}"

    # Strip quarantine attribute so --version/-version doesn't trigger a security dialog
    command xattr -d com.apple.quarantine "$dest" 2>/dev/null

    # Extract version: try --version first, fallback to -version
    # grep -m1 finds the FIRST match across all lines (handles leading blank lines like 7zz -version)
    cur=$(command "$dest" --version 2>&1 | command grep -m1 -oE '[0-9]+(\.[0-9]+)+')
    [[ -z "$cur" ]] && cur=$(command "$dest" -version 2>&1 | command grep -m1 -oE '[0-9]+(\.[0-9]+)+')
    [[ -z "$cur" ]] && {
      local ver_out; ver_out=$("$dest" --version 2>&1)
      [[ -z "$ver_out" ]] && ver_out=$("$dest" -version 2>&1)
      echo "[${tool}] ERROR: ${ver_out%%$'\n'*}"
      [[ "$ver_out" == *$'\n'* ]] && echo "  ${ver_out#*$'\n'}"
      ((failed++))
      continue
    }

    # Get latest release info (no API, uses HTTP redirect)
    info=$(_binary_get_release_info "$tool" "$repo") || {
      echo "[${tool}] ERROR: ${info}"
      ((failed++))
      continue
    }

    tag="${info%%$'\t'*}"; url="${info#*$'\t'}"
    latest="${tag#v}"

    [[ -z "$latest" || "$latest" == "null" ]] && { echo "[${tool}] ERROR: empty version"; ((failed++)); continue; }

    if ! [[ "$(printf '%s\n%s\n' "$cur" "$latest" | command sort -V | command tail -1)" == "$latest" && "$cur" != "$latest" ]]; then
      echo "[${tool}] ${cur} -> ${latest} ... up to date"
      ((skipped++))
      continue
    fi

    [[ -z "$url" || "$url" == "null" ]] && { echo "[${tool}] ERROR: no matching asset"; ((failed++)); continue; }
    local install_out; install_out=$(_binary_install "$tool" "$latest" "$url" 2>&1)
    if [[ $? -eq 0 ]]; then
      echo "[${tool}] ${cur} -> ${latest} ... updated (${latest})"
      ((updated++)); updated_tools+=("$tool")
    else
      echo "$install_out"
      ((failed++))
    fi

  done

  echo
  echo "Summary: ${updated} updated, ${skipped} skipped, ${failed} failed"
  (( updated > 0 )) && echo "Updated: ${(j:, :)updated_tools}"
}

# Load all binaries
_zbinary_load 7zz       "ip7z/7zip"                "enhance-bin/7zz"        xz    "7zz"       "7z{VERSION_NODOT}-mac.tar.xz"
_zbinary_load fnm       "Schniz/fnm"               "fnm"                    zip   "fnm"       "fnm-macos.zip"
_zbinary_load uv        "astral-sh/uv"             "uv"                     tgz   "uv uvx"    "uv-aarch64-apple-darwin.tar.gz"
_zbinary_load bat       "sharkdp/bat"              "enhance-bin/bat"        tgz   "bat"       "bat-v{VERSION}-aarch64-apple-darwin.tar.gz"
_zbinary_load fastfetch "fastfetch-cli/fastfetch"  "enhance-bin/fastfetch"  tgz   "fastfetch" "fastfetch-macos-aarch64.tar.gz"
_zbinary_load lsd       "lsd-rs/lsd"               "enhance-bin/lsd"        tgz   "lsd"       "lsd-v{VERSION}-aarch64-apple-darwin.tar.gz"
_zbinary_load macpow    "k06a/macpow"              "enhance-bin/macpow"     tgz   "macpow"    "macpow-arm64-apple-darwin.tar.gz"
_zbinary_load mactop    "context-labs/mactop"      "enhance-bin/mactop"     tgz   "mactop"    "mactop_{VERSION}_darwin_arm64.tar.gz"
_zbinary_load nvim      "neovim/neovim"            "enhance-bin/nvim"       tgz   "nvim"      "nvim-macos-arm64.tar.gz"
_zbinary_load starship  "starship/starship"        "enhance-bin/starship"   tgz   "starship"  "starship-aarch64-apple-darwin.tar.gz"
_zbinary_load yazi      "sxyazi/yazi"              "enhance-bin/yazi"       zip   "yazi"      "yazi-aarch64-apple-darwin.zip"
_zbinary_load zoxide    "ajeetdsouza/zoxide"       "enhance-bin/zoxide"     tgz   "zoxide"    "zoxide-{VERSION}-aarch64-apple-darwin.tar.gz"
