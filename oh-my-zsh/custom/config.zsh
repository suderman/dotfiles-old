# relative bin, home bin, home local bin
export MYPATH=bin:$HOME/bin:$HOME/local/bin

# usr local bin
export MYPATH=$MYPATH:/usr/local/bin:/usr/local/sbin

# node path
export NODE_PATH=/usr/local/lib/node_modules
export MYPATH=$MYPATH:/usr/local/share/npm/bin

# php path
export MYPATH=$MYPATH:/usr/local/Cellar/php/5.3.10/bin

# Append original path
export PATH=$MYPATH:$PATH

# Man path
export MANPATH="$HOME/local/share:/usr/local/man:$MANPATH"


CHRUBY="/usr/local/share/chruby/chruby.sh"
if [ -f $CHRUBY ]; then
  source $CHRUBY
  # auto-switching
  source /usr/local/share/chruby/auto.sh
fi

# https://github.com/sstephenson/ruby-build/issues/193
export CPPFLAGS=-I/opt/X11/include

# use vim as an editor
export EDITOR=vim
export VISUAL=vim

# Edit long commands in vim ('v' in normal mode)
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Disable autocorrect
unsetopt correct_all

# umask permissions
umask 0002

# Allow use of CTRL-S and CTRL-Q
setopt NO_FLOW_CONTROL
stty -ixon

# app
export APP_SOURCE=~/Dropbox/Installers

# http://direnv.net
eval "$(direnv hook zsh)"

export LC_CTYPE="en_US.UTF-8"

