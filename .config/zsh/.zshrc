# When writing out the history file, older commands that duplicate newer ones are omitted
setopt HIST_SAVE_NO_DUPS

# push the current directory onto the directory stack
setopt AUTO_PUSHD

# ignore duplicates in the directory stack
setopt PUSHD_IGNORE_DUPS

# do not print the directory stack after pushd or popd
setopt PUSHD_SILENT

#  alias
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias /="cd /"
alias -- -="cd -"
alias cl="clear"

alias ls="ls -G"
alias la="ls -la"
alias ll="ls -l"
alias lah="ls -laH"

alias grep="grep --color=always -E"
alias less="less -K --mouse"

# dont wanna hardcode this but need this to work rn
alias readelf="/opt/homebrew/Cellar/binutils/2.45.1/bin/readelf"

#ZSH_DISABLE_COMPFIX=true

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# completion for hidden files
autoload -U compinit; compinit -u

# with hidden files
_comp_options+=(globdots)

# Needed for my theme to work, ripped from OMZ
source $ZDOTDIR/zsh_sources/plugins/async_prompt.zsh
source $ZDOTDIR/zsh_sources/plugins/git.zsh
source $ZDOTDIR/zsh_sources/plugins/prompt_info_functions.zsh
source $ZDOTDIR/zsh_sources/plugins/virtualenv.plugin.zsh

# Load the theme
source $ZDOTDIR/zsh_sources/themes/stacked.zsh-theme
# source $ZDOTDIR/zsh_sources/themes/stacked_git.zsh-theme
# source $ZDOTDIR/zsh_sources/themes/gnzh.zsh-theme
# source $ZDOTDIR/zsh_sources/themes/agnoster.zsh-theme

# source plugins
source $ZDOTDIR/zsh_sources/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/zsh_sources/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# set alias for d to print the directory stack
function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

compdef _dirs d

# use 1-9 to jump to the directory stack number
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# a: black
# b: red
# c: green
# d: brown
# e: blue
# f: magenta
# g: cyan
# h: light grey
# A: bold black, usually shows up as dark grey
# B: bold red
# C: bold green
# D: bold brown, usually shows up as yellow
# E: bold blue
# F: bold magenta
# G: bold cyan
# H: bold light grey; looks like bright white
# x: default foreground or background

DIR_FG='E'
DIR_BG='x'

SYM_FG='G'
SYM_BG='x'

SOCK_FG='F'
SOCK_BG='x'

PIPE_FG='D'
PIPE_BG='x'

EXE_FG='C'
EXE_BG='x'

BLOCK_SP_FG='D'
BLOCK_SP_BG='g'

CHAR_SP_FG='D'
CHAR_SP_BG='d'

EXE_UID_FG='A'
EXE_UID_BG='b'

EXE_GID_FG='A'
EXE_GID_BG='g'

DIR_WRIT_STICKY_FG='A'
DIR_WRIT_STICKY_BG='c'

DIR_WRIT_NO_STICKY_FG='A'
DIR_WRIT_NO_STICKY_BG='d'

# export LSCOLORS="exfxcxdxbxegedabagacad"
export LSCOLORS="${DIR_FG}${DIR_BG}${SYM_FG}${SYM_BG}${SOCK_FG}${SOCK_BG}${PIPE_FG}${PIPE_BG}${EXE_FG}${EXE_BG}${BLOCK_SP_FG}${BLOCK_SP_BG}${CHAR_SP_FG}${CHAR_SP_BG}${EXE_UID_FG}${EXE_UID_BG}${EXE_GID_FG}${EXE_GID_BG}${DIR_WRIT_STICKY_FG}${DIR_WRIT_STICKY_BG}${DIR_WRIT_NO_STICKY_FG}${DIR_WRIT_NO_STICKY_BG}"

# enable grep colors
export GREP_OPTIONS='--color=auto'

# fzf
#source $ZDOTDIR/zsh_sources/fzf_funcs.zsh
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --type d --hidden --follow'
export FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzf_default_opts

# Use bat for man
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
