# set the default text editor and visual editor to code
# code = Visual Studio Code
# nvim = Neovim
# nano = Nano
# vim = Vim
export EDITOR="code"
export VISUAL="code"

# enable mouse scrolling in less command
# export LESS="-R"

# set maximum command history for in-memory history during session
export HISTSIZE=1000

# set maximum command history for on-disk history when session ends
export SAVEHIST=1000

# fix pip not being found in the terminal
export PATH="/Users/richardguizar/Library/Python/3.8/bin:$PATH"

# add a gnubin directory to PATH so that "make" runs with an updated version of make from brew
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

# export local bin
export PATH="$HOME/bin:$PATH"

# export spicetify
export PATH=$PATH:/Users/richardguizar/.spicetify