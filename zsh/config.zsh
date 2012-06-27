# Save original path for the end
export ORIGINAL_PATH=$PATH

# local bin
export PATH=/usr/local/bin
export PATH=$PATH:/usr/local/sbin

# node path
export NODE_PATH="/usr/local/lib/node"
export PATH=$PATH:/usr/local/share/npm/bin

# php path
export PATH=$PATH:/usr/local/Cellar/php/5.3.10/bin

# MacPorts
export PATH=$PATH:/opt/local/bin:/opt/local/sbin

# Append original path
export PATH=$PATH:$ORIGINAL_PATH

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
if command -v "rbenv" &>/dev/null
then
  export PREFIX=$HOME
  eval "$(rbenv init -)"
  rbenv global 1.9.2-p290
fi

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
if command -v "reattach-to-user-namespace" &>/dev/null
then
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

# installion
export INSTALLION_SOURCE=~/Dropbox/Installers
