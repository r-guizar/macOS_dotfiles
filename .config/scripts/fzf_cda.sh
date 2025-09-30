#!/usr/bin/env bash

# fd - cd to selected directory
base_dir="${1:-.}"

dir=$(fd --hidden --max-depth 4 --type d . "$base_dir" \
  | sed "s|^$base_dir||" \
  | fzf --tmux +m)

full_path="${base_dir%/}/${dir#/}"

if [[ "$full_path" == "${base_dir%/}/" ]]; then
  exit 0
elif [[ -n "$TMUX" ]]; then
  original_pane=$(tmux display -p '#{pane_id}')
  tmux send-keys -t "$original_pane" "cd \"$full_path\"" Enter
else
  cd "$full_path"
fi
