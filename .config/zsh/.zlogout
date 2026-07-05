# =========================
# .zlogout
# =========================

# ⚠️ Cleanup operations below are commented out by default.
#    If you want them active, uncomment the relevant sections.

# --- Clean stale fnm multishell directories ---
# These temporary directories may remain if the shell exits unexpectedly
# (e.g. Terminal force quit or system crash).
#if [[ -d "$XDG_STATE_HOME/fnm_multishells" ]]; then
#    find "$XDG_STATE_HOME/fnm_multishells" \
#        -mindepth 1 \
#        -mtime +7 \
#        -exec rm -rf -- {} +
#fi

# --- Clean cache files on exit ---
#trash_items=(
#    # Python
#    "$HOME/Library/Application Support/pyinstaller"
#    "$HOME/Library/Caches/com.apple.python"
#    # SwiftPM
#    "$HOME/Library/Caches/org.swift.swiftpm"
#    "$HOME/Library/org.swift.swiftpm"
#    "$HOME/.config/swiftpm"
#)
#
#for item in "${trash_items[@]}"; do
#    [[ -e "$item" ]] || continue
#
#    osascript >/dev/null 2>&1 <<EOF
#tell application "Finder"
#    delete (POSIX file "$item")
#end tell
#EOF
#done
