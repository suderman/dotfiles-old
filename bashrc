# Sometimes scripts call bash instead of my beloved zsh
# ...so I have to maintain a little bashrc too I guess

# Save original path for the end
export ORIGINAL_PATH=$PATH

# local bin
export PATH=$PATH:/usr/local/bin

# node path
export NODE_PATH="/usr/local/lib/node"
export PATH=$PATH:/usr/local/share/npm/bin

# MacPorts
export PATH=$PATH:/opt/local/bin:/opt/local/sbin

# Append original path
export PATH=$PATH:$ORIGINAL_PATH

# Chruby
CHRUBY="/usr/local/share/chruby/chruby.sh"
if [ -f $CHRUBY ]; then
  source $CHRUBY
  # auto-switching
  source /usr/local/share/chruby/auto.sh
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
