#!/usr/bin/env bash

# If run from tmux, cd into the pane's current directory
if [ -n "$TMUX" ]; then
    pane_path=$(tmux display-message -p -F "#{pane_current_path}")
    cd "$pane_path" || exit 1
fi

file=$(fd --hidden --type f . . \
  | fzf --tmux +m \
  --preview='bat --line-range=:100 {}' \
  --preview-border=rounded \
  --bind 'focus:transform-preview-label:[[ -n {} ]] && printf "╢ Previewing [%s] ╟" {}' \
  --preview-window='~4' \
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