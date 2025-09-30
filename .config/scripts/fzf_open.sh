#!/usr/bin/env bash

file=$(fd --hidden --type f . . \
  | fzf --tmux +m
  --preview='bat --line-range=:100 {}'
  --preview-border=rounded
  --bind 'focus:transform-preview-label:[[ -n {} ]] && printf "╢ Previewing [%s] ╟" {}'
  --preview-window='~4'
  --color 'preview-border:#30ff00,preview-label:#30ff00,preview-fg:#ffffff'
)

if [[ -n "$file" ]]; then
  if [[ -n "$TMUX" ]]; then
    original_pane=$(tmux display -p '#{pane_id}')
    tmux send-keys -t "$original_pane" "${EDITOR:-vim} \"$file\"" Enter
  else
      "${EDITOR:-vim}" "$file"
  fi
fi
