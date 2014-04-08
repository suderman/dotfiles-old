# Sometimes scripts call bash instead of my beloved zsh
# ...so I have to maintain a little bashrc too I guess

# Use what I can
source ~/.dotfiles/zsh/path.zsh
source ~/.dotfiles/zsh/aliases.zsh
source ~/.dotfiles/zsh/functions.zsh

# Manually set your language environment
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# use vim as an editor
export EDITOR=vim
export VISUAL=vim

# umask permissions
umask 0002

#--------------------
# Other Configuration
#--------------------

# http://direnv.net
eval "$(direnv hook bash)" 

# chruby
CHRUBY="/usr/local/share/chruby/chruby.sh"
if [ -f $CHRUBY ]; then
  source $CHRUBY
  # auto-switching
  source /usr/local/share/chruby/auto.sh
  # https://github.com/sstephenson/ruby-build/issues/193
  export CPPFLAGS=-I/opt/X11/include
fi

