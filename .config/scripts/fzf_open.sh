#!/usr/bin/env bash

# If run from tmux, cd into the pane's current directory before opening the file
if [ -n "$TMUX" ]; then
    pane_path=$(tmux display-message -p -F "#{pane_current_path}")
    cd "$pane_path" || exit 1
fi

file=$(fd --hidden --type f --exclude Qt . . \
  --exclude "*.so" --exclude "*.a" --exclude "*.o" --exclude "*.out" --exclude "*.dylib" \
  --exclude "*.exe" --exclude "*.bin" --exclude "*.dll" --exclude "*.sys" --exclude "*.pyc" \
  --exclude "*.pyo" --exclude "*.jar" --exclude "*.zip" --exclude "*.tar" --exclude "*.gz" \
  --exclude "*.7z" --exclude "*.xz" --exclude "*.rar" --exclude "*.bz2" --exclude "*.ttf" \
  --exclude "*.otf" --exclude "*.pdf" --exclude "*.mov" --exclude "*.png" --exclude "*.jpg" \
  --exclude "*.gif" --exclude "*.webp" --exclude "*.ico" --exclude "*.mp3" --exclude "*.mp4" \
  --exclude "*.wav" --exclude "*.strings" --exclude "*.db" --exclude "*.DS_Store"   --exclude "*.db-wal" \
  --exclude "*.db-shm" --exclude "*.localized" --exclude "*.lock" --exclude "*.CFUserTextEncoding" \
  --exclude "*.musicdb" --exclude "*.pub" \
  | fzf +m \
  --tmux center,80%,border-native \
  --preview='bat -r :$((FZF_PREVIEW_LINES - 5)) -s --color always {}' \
  --preview-border=rounded \
  --bind 'focus:transform-preview-label:[[ -n {} ]] && printf "╢ Previewing [%s] ╟" {}' \
  --color 'preview-border:#30ff00,preview-label:#30ff00,preview-fg:#ffffff' \
  --bind 'focus:+transform-header:file --brief {} || echo "No file selected"' \
  --header-label="╢ File Type ╟" \
  --header-border=rounded \
  --color 'header-border:#cf00ff,header-label:#cf00ff' \
  --color 'header-fg:#ffffff'
)

if [[ -n "$file" ]]; then
  if [[ -n "$TMUX" ]]; then
    original_pane=$(tmux display -p '#{pane_id}')
    tmux send-keys -t "$original_pane" "${EDITOR:-vim} \"$file\"" Enter
  else
      "${EDITOR:-vim}" "$file"
  fi
fi