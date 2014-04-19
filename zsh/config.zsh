# 2014 Jon Suderman
# https://github.com/suderman/dotfiles/

#------------------
# ZSH Configuration
#------------------

# Manually set your language environment
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# use vim as an editor
export EDITOR=vim
export VISUAL=vim

# vi mode
bindkey -v
KEYTIMEOUT=1

# Disable autocorrect
unsetopt correct_all

# umask permissions
umask 0002

# Allow use of CTRL-S and CTRL-Q
setopt NO_FLOW_CONTROL
stty -ixon

# Enable SSH agent forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

#--------------------
# Other Configuration
#--------------------

# http://direnv.net
! command -v direnv >/dev/null 2>&1 || { 
  eval "$(direnv hook zsh)" 
}

# https://github.com/georgebrock/1pass
! command -v 1pass >/dev/null 2>&1 || { 
  # export CFLAGS=-Qunused-arguments
  # export CPPFLAGS=-Qunused-arguments
  # sudo -E easy_install pip
  # sudo -E pip install 1pass
  export ONEPASSWORD_KEYCHAIN="$HOME/Dropbox/Library/1Password.agilekeychain"
}

# https://github.com/jimeh/tmuxifier
! command -v tmuxifier >/dev/null 2>&1 || { 
  export TMUXIFIER_LAYOUT_PATH="$HOME/.dotfiles/tmux/layouts"
  # export TMUXIFIER_TMUX_OPTS="-L my-awesome-socket-name"
  eval "$(tmuxifier init -)"
}

# chruby
CHRUBY="/usr/local/share/chruby/chruby.sh"
if [ -f $CHRUBY ]; then
  source $CHRUBY
  # auto-switching
  source /usr/local/share/chruby/auto.sh
  # https://github.com/sstephenson/ruby-build/issues/193
  export CPPFLAGS=-I/opt/X11/include
fi

# OS X app installer
if [ -d ~/Dropbox/Installers ]; then
  export APP_SOURCE=~/Dropbox/Installers
fi

