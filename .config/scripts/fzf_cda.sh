#!/usr/bin/env bash

# If run from tmux, cd into the pane's current directory
if [ -n "$TMUX" ]; then
    pane_path=$(tmux display-message -p -F "#{pane_current_path}")
    cd "$pane_path" || exit 1
fi

# fd - cd to selected directory
base_dir="${1:-./}"

if [[ $base_dir == $HOME ]]; then
    sed_cmd='sed "s|^$HOME|~|"'
else
    sed_cmd='sed "s|^$base_dir||"'
fi

dir=$(fd --hidden --max-depth 10 --type d . "$base_dir" \
  | sed "s|^$HOME|~|" \
  | fzf --tmux +m)

if [ "${dir#*~}" != "$dir" ]; then
  tilde="~"
  dir="${HOME}${dir#$tilde}"
fi

if [[ -z $dir ]]; then
  print "exiting"
  exit 0
elif [[ -n "$TMUX" ]]; then
  original_pane=$(tmux display -p '#{pane_id}')
  tmux send-keys -t "$original_pane" "cd \"$dir\"" Enter
else
  cd "$dir"
fi