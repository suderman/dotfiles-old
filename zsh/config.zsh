# Save original path for the end
export ORIGINAL_PATH=$PATH

# local bin
export PATH=/usr/local/bin
export PATH=$PATH:/usr/local/sbin

# node path
export NODE_PATH=/usr/local/lib/node_modules
export PATH=$PATH:/usr/local/share/npm/bin

# php path
export PATH=$PATH:/usr/local/Cellar/php/5.3.10/bin

# Append original path
export PATH=$PATH:$ORIGINAL_PATH

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
if command -v "rbenv" &>/dev/null; then
  export PREFIX=$HOME
  eval "$(rbenv init -)"
  rbenv global 1.9.3-rc1
fi

# chruby
CHRUBY="/usr/local/opt/chruby/share/chruby/chruby.sh"
if [ -f $CHRUBY ]; then
  source $CHRUBY
  # auto-switching
  source /usr/local/opt/chruby/share/chruby/auto.sh
fi

# https://github.com/sstephenson/ruby-build/issues/193
export CPPFLAGS=-I/opt/X11/include

# home bin
export PATH=$HOME/bin:$PATH

# relative bin
export PATH=bin:$PATH

# use vim as an editor
export EDITOR=vim
export VISUAL=vim

# Edit long commands in vim ('v' in normal mode)
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Tmux on OS X needs this to access the pasteboard
if command -v "reattach-to-user-namespace" &>/dev/null; then
  export TMUX_DEFAULT_COMMAND="reattach-to-user-namespace -l zsh"
fi

# Disable autocorrect
unsetopt correct_all

# umask permissions
umask 0002

# Allow use of CTRL-S and CTRL-Q
setopt NO_FLOW_CONTROL
stty -ixon

# gem install lolcommits
# lolcommits --enable
export LOLCOMMITS_TRANZLATE=1

# app
export APP_SOURCE=~/Dropbox/Installers
